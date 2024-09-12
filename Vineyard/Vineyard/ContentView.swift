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
                Text("\(viewModel.user.name)")
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
