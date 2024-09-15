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
                HStack {
                    Spacer()
                    Text("\(viewModel.user.name)")
                        .frame(maxWidth: 275, alignment: .center)
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.trailing, 22)
                            .foregroundColor(.black)
                    }
                }
                List(viewModel.user.participatingGroups) { group in
                    // TODO: Use a NavigationLink to select a list.
                    NavigationLink(group.groupName) {
                        ResolutionView(group: group)
                    }
                }
            }
            
        }.navigationTitle("Group Menu")

    }
}

#Preview {
    ContentView().environment(ViewModel())
}
