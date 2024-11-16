//
//  FirebaseDataManager.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.

import FirebaseFirestore

class FirebaseDataManager: DatabaseServiceProtocol {
    
    static var shared = FirebaseDataManager()
    
    private let db = Firestore.firestore()
    
    private var listeners: [String: ListenerRegistration] = [:]
    
    typealias GroupUpdateHandler = (Group) -> Void
    
    func addGroupListener(groupID: String, onUpdate: @escaping GroupUpdateHandler) {
        
        // Avoiding duplicate listeners
        guard listeners[groupID] == nil else { return }
        
        let listener = db.collection("groups").document(groupID)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print("Error listening to group changes: \(error)")
                    return
                }
                
                guard let document = documentSnapshot,
                      let updatedGroup = try? document.data(as: Group.self) else {
                    return
                }
                
                onUpdate(updatedGroup)
            }
        
        listeners[groupID] = listener
    }
    
    func removeGroupListener(groupID: String) {
        listeners[groupID]?.remove()
        listeners.removeValue(forKey: groupID)
    }
    
    func removeAllListeners() {
        listeners.forEach { _, listener in listener.remove() }
        listeners.removeAll()
    }
    
    func fetchGroupFromDB(groupID: String) async throws -> Group? {
        let documentSnapshot = try await db.collection("groups").document(groupID).getDocument()
        return try documentSnapshot.data(as: Group.self)
    }
    
    func fetchPersonFromDB(userID: String) async throws -> Person? {
        let documentSnapshot = try await db.collection("people").document(userID).getDocument()
        return try documentSnapshot.data(as: Person.self)
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
            let documentSnapshot = try await db.collection("badges").document(badgeID).getDocument()
            
            if let badge = try? documentSnapshot.data(as: Badge.self) {
                // May not do this here \\
                if let resolution = try? await fetchResolutionFromDB(resolutionID: badge.resolutionID) {
                    var updatedBadge = badge
                    updatedBadge.resolution = resolution
                    badges.append(updatedBadge)
                } else {
                    badges.append(badge)
                }
            }
        }
        return badges
    }
    
    func fetchProgressFromDB(progressIDs: [String]) async throws -> [Progress] {
        var progressList: [Progress] = []
        for progressID in progressIDs {
            let documentSnapshot = try await db.collection("progress").document(progressID).getDocument()
            if let progress = try? documentSnapshot.data(as: Progress.self) {
                var updatedProgress = progress
                // May not do this here \\
                if let resolution = try? await fetchResolutionFromDB(resolutionID: progress.resolutionID) {
                    updatedProgress.resolution = resolution
                }
                // May not do this here \\
                if let person = try? await fetchPersonFromDB(userID: progress.personID) {
                    updatedProgress.person = person
                }
                progressList.append(updatedProgress)
            }
        }
        return progressList
    }
    
    func fetchResolutionFromDB(resolutionID: String) async throws -> Resolution {
        let documentSnapshot = try await db.collection("resolutions").document(resolutionID).getDocument()
        return try documentSnapshot.data(as: Resolution.self)
    }
    
    func fetchResolutionsFromDB(resolutionIDs: [String]) async throws -> [Resolution] {
        var resolutions: [Resolution] = []
        for resolutionID in resolutionIDs {
            let resolution = try await fetchResolutionFromDB(resolutionID: resolutionID) 
                resolutions.append(resolution)
            
        }
        return resolutions
    }
    
    func addPersonToDB(person: Person) async throws {
        guard let id = person.id else { throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing person ID"]) }
        let personRef = db.collection("people").document(id)
        try personRef.setData(from: person)
        
        // Store the related objects as well - might not do this here? \\
        for badge in person.badges ?? [] {
            try await addBadgeToDB(badge: badge)
        }
        for progress in person.allProgress ?? [] {
            try await addProgressToDB(progress: progress)
        }
    }
    
    func addResolutionToDB(resolution: Resolution) async throws {
        guard let id = resolution.id else { throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing resolution ID"]) }
        let resolutionRef = db.collection("resolutions").document(id)
        try resolutionRef.setData(from: resolution)
    }
    
    func addBadgeToDB(badge: Badge) async throws {
        guard let id = badge.id else { throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing badge ID"]) }
        let badgeRef = db.collection("badges").document(id)
        try badgeRef.setData(from: badge)
    }
    
    func addProgressToDB(progress: Progress) async throws {
        guard let id = progress.id else { throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing progress ID"]) }
        let progressRef = db.collection("progress").document(id)
        try progressRef.setData(from: progress)
    }
    
    func addGroupToDB(group: Group) async throws {
        guard let id = group.id else { throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing group ID"]) }
        let groupRef = db.collection("groups").document(id)
        try groupRef.setData(from: group)
        
        // Store the related object as well - might not do this here? \\
        for resolution in group.resolutions ?? [] {
            try await addResolutionToDB(resolution: resolution)
        }
    }

}
