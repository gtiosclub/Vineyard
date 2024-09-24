//
//  FirebaseDataManager.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import FirebaseFirestore

class FirebaseDataManager: DatabaseServiceProtocol {
    
    func fetchGroupFromDB(groupID: String) async throws -> Group? {
        let db = Firestore.firestore()
        let groupRef = db.collection("groups").document(groupID)
        let document = try await groupRef.getDocument()
        
        guard let data = document.data(),
              let name = data["name"] as? String,
              let groupGoal = data["groupGoal"] as? String,
              let deadlineTimestamp = data["deadline"] as? Timestamp else {
            return nil
        }
        let deadline = deadlineTimestamp.dateValue()
        let peopleIDs = data["people"] as? [String] ?? []
        let people = try await fetchPeopleFromDB(peopleIDs: peopleIDs)
        let resolutionIDs = data["resolutions"] as? [String] ?? []
        let resolutions = try await fetchResolutionsFromDB(resolutionIDs: resolutionIDs)
        
        return Group(
            name: name,
            groupGoal: groupGoal,
            people: people,
            resolutions: resolutions,
            deadline: deadline
        )
        
    }
    
    func fetchPeopleFromDB(peopleIDs: [String]) async throws -> [Person] {
        let db = Firestore.firestore()
        var people: [Person] = []
        
        for id in peopleIDs {
            let personRef = db.collection("people").document(id)
            let document = try await personRef.getDocument()
            
            guard let data = document.data(),
                  let name = data["name"] as? String,
                  let email = data["email"] as? String,
                  let resolutionIDs = data["resolutionIDs"] as? [String] else { continue }
            let groupIDs = data["groupIDs"] as? [String] ?? []
            
            var groups: [Group] = []
            for groupID in groupIDs {
                if let group = try await fetchGroupFromDB(groupID: groupID) {
                    groups.append(group)
                }
            }
            
            let resolutions = try await fetchResolutionsFromDB(resolutionIDs: resolutionIDs)
            
            let person = Person(
                name: name,
                groups: groups,
                resolutions: resolutions,
                emails: email
            )
            people.append(person)
        }
        
        return people
    }
    
    func fetchResolutionsFromDB(resolutionIDs: [String]) async throws -> [Resolution] {
        let db = Firestore.firestore()
        var resolutions: [Resolution] = []
        
        for resolutionID in resolutionIDs {
            let resolutionRef = db.collection("resolutions").document(resolutionID)
            let document = try await resolutionRef.getDocument()
            
            guard let data = document.data(),
                  let title = data["title"] as? String,
                  let description = data["description"] as? String,
                  let frequencyData = data["frequency"] as? [String: Any],
                  let diffLevelData = data["difficultyLevel"] as? [String: Any] else { continue }
            
            let frequency: Frequency
            if let type = frequencyData["type"] as? String, let count = frequencyData["count"] as? Int {
                switch type {
                case "daily":
                    frequency = .daily(count: count)
                case "weekly":
                    frequency = .weekly(count: count)
                case "monthly":
                    frequency = .monthly(count: count)
                default:
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown frequency type"])
                }
            } else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid frequency data"])
            }
            
            let difficultyLevel: DifficultyLevel
            if let type = diffLevelData["type"] as? String, let score = diffLevelData["score"] as? Int {
                switch type {
                case "easy":
                    difficultyLevel = .easy(score: score)
                case "medium":
                    difficultyLevel = .medium(score: score)
                case "hard":
                    difficultyLevel = .hard(score: score)
                default:
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown difficulty level type"])
                }
            } else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid difficulty level data"])
            }
            
            let quantity = data["quantity"] as? Int
            
            let resolution = Resolution(
                title: title,
                description: description,
                quantity: quantity,
                frequency: frequency,
                diffLevel: difficultyLevel
            )
            
            resolutions.append(resolution)
        }
        
        return resolutions
    }
    
    func addPersonToDB(person: Person) async throws {
        let db = Firestore.firestore()
        let personRef = db.collection("people").document(person.id.uuidString)
        
        let personData: [String: Any] = [
            "name": person.name,
            "email": person.emails,
            "groupIDs": person.groups.map { $0.id.uuidString },
            "resolutionIDs": person.resolutions.map { $0.id.uuidString }
        ]
        try await personRef.setData(personData)
    }
    
    func addResolutionToDB(resolution: Resolution) async throws {
        let db = Firestore.firestore()
        let resolutionRef = db.collection("resolutions").document(resolution.id.uuidString)
        
        let frequencyData: [String: Any]
        switch resolution.frequency {
        case .daily(let count):
            frequencyData = ["type": "daily", "count": count]
        case .weekly(let count):
            frequencyData = ["type": "weekly", "count": count]
        case .monthly(let count):
            frequencyData = ["type": "monthly", "count": count]
        }
        
        let difficultyLevelData: [String: Any]
        switch resolution.diffLevel {
        case .easy(let score):
            difficultyLevelData = ["type": "easy", "score": score]
        case .medium(let score):
            difficultyLevelData = ["type": "medium", "score": score]
        case .hard(let score):
            difficultyLevelData = ["type": "hard", "score": score]
        }
        
        let resolutionData: [String: Any] = [
            "title": resolution.title,
            "description": resolution.description,
            "quantity": resolution.quantity as Any,
            "frequency": frequencyData,
            "difficultyLevel": difficultyLevelData
        ]
        try await resolutionRef.setData(resolutionData)
    }
    
    func addGroupToDB(group: Group) async throws {
        let db = Firestore.firestore()
        let groupRef = db.collection("groups").document(group.id.uuidString)
        
        let groupData: [String: Any] = [
            "name": group.name,
            "groupGoal": group.groupGoal,
            "people": group.people.map { $0.id.uuidString },
            "resolutions": group.resolutions.map { $0.id.uuidString },
            "deadline": Timestamp(date: group.deadline)
        ]
        try await groupRef.setData(groupData)
    }
    
    
}
