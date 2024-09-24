//
//  ProfileView.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel
    var body: some View {
        VStack {
            Text("Welcome to the profile")
            Button(action: {
                loginViewModel.signOut()
            }) {
                Text("Logout")
            }
        }
    }
}

#Preview {
    ProfileView()
}
