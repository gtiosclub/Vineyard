//
//  ProfileViewModel.swift
//  Vineyard
//
//  Created by Josheev Rai on 11/15/24.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var user: Person?
    
    func setUser(user: Person?) {
        guard self.user == nil, let user = user else { return }
        self.user = user
    }
    
    func getCurrentUserBadges() async {
        guard let badgeIDs = user?.badgeIDs else { return }

        do {
            let badges = try await FirebaseDataManager.shared.fetchBadgesFromDB(badgeIDs: badgeIDs)
            self.user?.badges = badges
        } catch {
            print("Error fetching badges: \(error.localizedDescription)")
        }
    }
}
