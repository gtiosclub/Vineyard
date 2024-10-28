//
//  FirebaseDataManager.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.

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
        let resolutionIDs = data["resolutions"] as? [String] ?? []
        let resolutions = try await fetchResolutionsFromDB(resolutionIDs: resolutionIDs)

        return Group(
            name: name,
            groupGoal: groupGoal,
            people: peopleIDs,
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
            let progressIDs = data["progress"] as? String
            let badgeIDs = data["badges"] as? [String]

            let person = Person(
                name: name,
                groups: groupIDs,
                allProgress: [],
                email: email,
                badges: []
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
                    frequency = Frequency(frequencyType: FrequencyType.daily, count: count)
                case "weekly":
                    frequency = Frequency(frequencyType: FrequencyType.weekly, count: count)
                case "monthly":
                    frequency = Frequency(frequencyType: FrequencyType.monthly, count: count)
                default:
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown frequency type"])
                }
            } else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid frequency data"])
            }

            let difficulty: Difficulty
            let difficultyLevel: DifficultyLevel
            if let type = diffLevelData["type"] as? String, let score = diffLevelData["score"] as? Int {
                switch type {
                case "easy":
                    difficulty = Difficulty(difficultyLevel: DifficultyLevel.easy, score: score)
                case "medium":
                    difficulty = Difficulty(difficultyLevel: DifficultyLevel.medium, score: score)
                case "hard":
                    difficulty = Difficulty(difficultyLevel: DifficultyLevel.hard, score: score)
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
                diffLevel: difficulty
            )

            resolutions.append(resolution)
        }

        return resolutions
    }
    
    func addPersonToDB(person: Person) async throws {
        let db = Firestore.firestore()
        let personRef = db.collection("people").document(person.id)

        let personData: [String: Any] = [
            "name": person.name,
            "email": person.email,
            "groupIDs": person.groups,
            "allProgress": [],
            "badges": []
        ]
        try await personRef.setData(personData)
    }
    
    func addResolutionToDB(resolution: Resolution) async throws {
        let db = Firestore.firestore()
        let resolutionRef = db.collection("resolutions").document(resolution.id)

        let frequencyData: [String: Any]
        let frequency = resolution.defaultFrequency
        let count = frequency.count
        switch frequency.frequencyType {
        case .daily:
            frequencyData = ["type": "daily", "count": frequency.count]
        case .weekly:
            frequencyData = ["type": "weekly", "count": frequency.count]
        case .monthly:
            frequencyData = ["type": "monthly", "count": frequency.count]
        }

        let difficultyLevelData: [String: Any]
        let difficulty = resolution.diffLevel
        let score = difficulty.score
        switch difficulty.difficultyLevel {
        case .easy:
            difficultyLevelData = ["type": "easy", "score": difficulty.score]
        case .medium:
            difficultyLevelData = ["type": "easy", "score": difficulty.score]
        case .hard:
            difficultyLevelData = ["type": "easy", "score": difficulty.score]
        }

        let resolutionData: [String: Any] = [
            "title": resolution.title,
            "description": resolution.description,
            "quantity": resolution.defaultQuantity as Any,
            "frequency": frequencyData,
            "difficultyLevel": difficultyLevelData
        ]
        try await resolutionRef.setData(resolutionData)
    }
    
    func addProgressToDB(progress: Progress) async throws {
        let db = Firestore.firestore()
        let progressRef = db.collection("progress").document(progress.id)
        
        let frequencyData: [String: Any]
        let frequency = progress.frequencyGoal
        let count = frequency.count
        switch frequency.frequencyType {
        case .daily:
            frequencyData = ["type": "daily", "count": frequency.count]
        case .weekly:
            frequencyData = ["type": "weekly", "count": frequency.count]
        case .monthly:
            frequencyData = ["type": "monthly", "count": frequency.count]
        }
        
        let progressData: [String: Any] = [
            "person": progress.person.id,
            "resolution": progress.resolution.id,
            "completion": [],
            "frequencyGoal": frequencyData,
            "quantityGoal": progress.quantityGoal
        ]
        try await progressRef.setData(progressData)
    }
    
    func addGroupToDB(group: Group) async throws {
        let db = Firestore.firestore()
        let groupRef = db.collection("groups").document(group.id)

        let groupData: [String: Any] = [
            "name": group.name,
            "groupGoal": group.groupGoal,
            "people": group.people,
            "resolutions": group.resolutions,
            "deadline": Timestamp(date: group.deadline)
        ]
        try await groupRef.setData(groupData)
    }
    
    func fetchUserGroups(userID: String) async throws -> [Group] {
        let db = Firestore.firestore()
        let userDoc = try await db.collection("people").document(userID).getDocument()
        
        guard let data = userDoc.data(),
              let groupIDs = data["groupIDs"] as? [String] else {
            return []
        }

        var groups: [Group] = []
        for groupID in groupIDs {
            if let group = try await fetchGroupFromDB(groupID: groupID) {
                groups.append(group)
            }
        }
        return groups
    }
}
