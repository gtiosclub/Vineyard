//
//  TodoView.swift
//  Vineyard
//
//  Created by Sacchit Mittal on 10/3/24.
//

import SwiftUI

struct TodoView: View {
    @State private var viewModel = GroupsListViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10){
                    ForEach($viewModel.user.groups) { $group in
                        ForEach(group.resolutions) { resolution in
                            VStack(alignment: .leading, spacing: 5) {
                                Text("\(resolution.title)")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding()
                        .background(.gray.opacity(0.5))
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Text("Today's Tasks")
                        .font(.system(size: 24, weight: .bold))
                }
            }
        }
    }
}

#Preview {
    TodoView()
}
