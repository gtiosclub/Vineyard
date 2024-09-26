//
//  GroupsListView.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import SwiftUI

struct GroupsListView: View {
    @State private var viewModel = GroupsListViewModel()
    var body: some View {
        NavigationStack {
            List {
                Text("\(viewModel.user.name)'s groups")
                ForEach($viewModel.user.groups) { $group in
                    // TODO: Use a NavigationLink to select a list.
                    NavigationLink(group.name) {
                        ResolutionView(group: $group)
                    }
                }
            }.navigationTitle("Group Menu")
            
        }

    }
}

#Preview {
    GroupsListView()
}
