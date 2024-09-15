//
//  ContentView.swift
//  Vineyard
//
//  Created by Sankaet Cheemalamarri on 9/10/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(ViewModel.self) private var viewModel
    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.user.participatingGroups) { group in
                    // TODO: Use a NavigationLink to select a list.
                    NavigationLink(group.groupName) {
                        ResolutionView(group: group)
                    }
                }
            }.toolbar {
                ToolbarItem(placement: .principal) {
                    Text("\(viewModel.user.name)")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    }
                }
            }
            
        }.navigationTitle("Group Menu")
    }
}

#Preview {
    ContentView().environment(ViewModel())
}
