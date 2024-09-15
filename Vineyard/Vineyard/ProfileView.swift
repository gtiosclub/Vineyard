//
//  ProfileView.swift
//  Vineyard
//
//  Created by Sacchit Mittal on 9/15/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(ViewModel.self) private var viewModel
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.black)
            Text("Name: \(viewModel.user.name)")
            Text("Age: \(viewModel.user.age)")
            Text("You are part of \(viewModel.user.participatingGroups.count) groups:")
            ForEach(viewModel.user.participatingGroups, id: \.id) { group in
                Text(group.groupName)
            }
        }
    }
}

#Preview {
    ProfileView().environment(ViewModel())
}
