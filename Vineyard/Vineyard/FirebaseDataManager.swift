//
//  FirebaseDataManager.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.

import FirebaseFirestore

class FirebaseDataManager: DatabaseServiceProtocol {
    
    static var shared = FirebaseDataManager()
    
    private let db = Firestore.firestore()
    
    func fetchGroupFromDB(groupID: String) async throws -> Group? {
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
            peopleIDs: peopleIDs,
            resolutions: resolutions,
            resolutionIDs: resolutionIDs,
            deadline: deadline,
            score: 0
        )
    }
    
    func fetchPersonFromDB(userID: String) async throws -> Person? {
        let personRef = db.collection("people").document(userID)
        let document = try await personRef.getDocument()
        
        guard let data = document.data(),
              let name = data["name"] as? String,
              let email = data["email"] as? String,
              let groupIDs = data["groupIDs"] as? [String] else {
            return nil
        }
        
        return Person(
            id: userID,
            name: name,
            groupIDs: groupIDs,
            allProgress: [],
            email: email,
            badges: []
        )
    }
    
    func fetchPeopleFromDB(peopleIDs: [String]) async throws -> [Person] {
        var people: [Person] = []

        for personID in peopleIDs {
            if let person = try await fetchPersonFromDB(userID: personID) {
                people.append(person)
            } else {
                print("Failed to fetch person with ID \(personID)")
            }
        }

        return people
    }
    
    func fetchBadgesFromDB(badgeIDs: [String]) async throws -> [Badge] {
        var badges: [Badge] = []
        
        for badgeID in badgeIDs {
            let badgeRef = db.collection("badges").document(badgeID)
            let document = try await badgeRef.getDocument()
            
            guard let data = document.data(),
                  let resolutionID = data["resolutionID"] as? String,
                  let groupID = data["groupID"] as? String,
                  let dateObtainedTimestamp = data["dateObtained"] as? Timestamp else {
                continue
            }
            
            let dateObtained = dateObtainedTimestamp.dateValue()
            
            if let resolution = try await fetchResolutionFromDB(resolutionID: resolutionID),
               let group = try await fetchGroupFromDB(groupID: groupID) {
                
                let badge = Badge(resolution: resolution, resolutionID: resolutionID, group: group, groupID: groupID,  dateObtained: dateObtained)
                badges.append(badge)
            }
        }
        
        return badges
    }
    
    func fetchProgressFromDB(progressIDs: [String]) async throws -> [Progress] {
        var progressList: [Progress] = []

        for progressID in progressIDs {
            let progressRef = db.collection("progress").document(progressID)
            let document = try await progressRef.getDocument()

            guard let data = document.data(),
                  let personID = data["person"] as? String,
                  let resolutionID = data["resolution"] as? String,
                  let completion = data["completion"] as? [Timestamp],
                  let frequencyData = data["frequencyGoal"] as? [String: Any],
                  let quantityGoal = data["quantityGoal"] as? Float else {
                continue
            }
            let completionDates = completion.map { $0.dateValue() }
            
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

            guard let person = try await fetchPersonFromDB(userID: personID),
                  let resolution = try await fetchResolutionFromDB(resolutionID: resolutionID) else {
                continue
            }

            let progress = Progress(
                id: progressID,
                resolution: resolution,
                resolutionID: resolutionID,
                completionArray: completionDates,
                quantityGoal: quantityGoal,
                frequencyGoal: frequency,
                person: person,
                personID: personID
            )
            progressList.append(progress)
        }
        
        return progressList
    }
    
    private func fetchResolutionFromDB(resolutionID: String) async throws -> Resolution? {
        let resolutionRef = db.collection("resolutions").document(resolutionID)
        let document = try await resolutionRef.getDocument()
        
        guard let data = document.data(),
              let title = data["title"] as? String,
              let description = data["description"] as? String,
              let frequencyData = data["frequency"] as? [String: Any],
              let diffLevelData = data["difficultyLevel"] as? [String: Any] else { return nil }
        
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
        let _difficultyLevel: DifficultyLevel
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

        
        return Resolution(
            title: title,
            description: description,
            quantity: data["quantity"] as? Int,
            frequency: frequency,
            diffLevel: difficulty
        )
    }
    
    func fetchResolutionsFromDB(resolutionIDs: [String]) async throws -> [Resolution] {
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
            let _difficultyLevel: DifficultyLevel
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
        let personRef = db.collection("people").document(person.id)
        
        var badgeIDs: [String] = []
        for badge in person.badges ?? [] {
            badgeIDs.append(badge.id)
            try await self.addBadgeToDB(badge: badge)
        }
        
        var progressIDs: [String] = []
        for progress in person.allProgress ?? [] {
            progressIDs.append(progress.id)
            try await self.addProgressToDB(progress: progress)
        }

        let personData: [String: Any] = [
            "name": person.name,
            "email": person.email,
            "groupIDs": person.groups,
            "allProgress": progressIDs,
            "badges": badgeIDs
        ]
        try await personRef.setData(personData)
    }
    
    func addResolutionToDB(resolution: Resolution) async throws {
        let resolutionRef = db.collection("resolutions").document(resolution.id)

        let frequencyData: [String: Any]
        let frequency = resolution.defaultFrequency
        let _count = frequency.count
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
        let _score = difficulty.score
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
    
    func addBadgeToDB(badge: Badge) async throws {
        let badgeRef = db.collection("badges").document(badge.id)
        
        let badgeData: [String: Any] = [
            "resolutionID": badge.resolutionID,
            "groupID": badge.groupID,
            "dateObtained": Timestamp(date: badge.dateObtained)
        ]
        
        try await badgeRef.setData(badgeData)
    }
    
    func addProgressToDB(progress: Progress) async throws {
        let progressRef = db.collection("progress").document(progress.id)
        
        let frequencyData: [String: Any]
        let frequency = progress.frequencyGoal
        let _count = frequency.count
        switch frequency.frequencyType {
        case .daily:
            frequencyData = ["type": "daily", "count": frequency.count]
        case .weekly:
            frequencyData = ["type": "weekly", "count": frequency.count]
        case .monthly:
            frequencyData = ["type": "monthly", "count": frequency.count]
        }
        
        let progressData: [String: Any] = [
            "person": progress.personID,
            "resolution": progress.resolutionID,
            "completion": [],
            "frequencyGoal": frequencyData,
            "quantityGoal": progress.quantityGoal
        ]
        try await progressRef.setData(progressData)
    }
    
    func addGroupToDB(group: Group) async throws {
        let groupRef = db.collection("groups").document(group.id)
        
        var resolutionIDs: [String] = []
        for resolution in group.resolutions ?? [] {
            resolutionIDs.append(resolution.id)
        }

        let groupData: [String: Any] = [
            "name": group.name,
            "groupGoal": group.groupGoal,
            "people": group.people,
            "resolutions": resolutionIDs,
            "deadline": Timestamp(date: group.deadline)
        ]
        try await groupRef.setData(groupData)
    }
    
    func listenToGroup(groupID: String, completion: @escaping (Group?) -> Void) {
        let groupRef = db.collection("groups").document(groupID)
        
        groupRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot, let data = document.data() else {
                print("Error fetching group document: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            let name = data["name"] as? String ?? ""
            let groupGoal = data["groupGoal"] as? String ?? ""
            let peopleIDs = data["people"] as? [String] ?? []
            let resolutionIDs = data["resolutions"] as? [String] ?? []
            let deadline = (data["deadline"] as? Timestamp)?.dateValue() ?? Date()
            
            // Fetch resolutions asynchronously if needed
            Task {
                let resolutions = try? await self.fetchResolutionsFromDB(resolutionIDs: resolutionIDs)
                let updatedGroup = Group(
                    name: name,
                    groupGoal: groupGoal,
                    peopleIDs: peopleIDs,
                    resolutions: resolutions ?? [],
                    resolutionIDs: resolutionIDs,
                    deadline: deadline,
                    score: 0
                )
                completion(updatedGroup)
            }
        }
    }

}
