//
//  ProfileView.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack() {
                    HStack() {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundColor(.gray)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(viewModel.user.name)
                                .font(.system(size: 20, weight: .bold))
                            HStack() {
                                Text("x Friends")
                                    .foregroundColor(.gray)
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .frame(width: 3, height: 3)
                                    .foregroundColor(.gray)
                                if(viewModel.user.groups.count > 1) {
                                    Text("\(viewModel.user.groups.count) groups")
                                        .font(.system(size: 16))
                                        .fontWeight(.regular)
                                        .foregroundColor(.gray)
                                } else {
                                    Text("\(viewModel.user.groups.count) group")
                                        .font(.system(size: 16))
                                        .fontWeight(.regular)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 44)
                    Text("Winery")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 20, weight: .bold))
                        .padding(.top, 44)
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(0..<((viewModel.user.badges.count + 1) / 2)) { rowIndex in
                            HStack(spacing: 10) {
                                VStack(alignment: .leading, spacing: 10) {
                                    //just displaying date for now
                                    Text("\(viewModel.user.badges[rowIndex * 2].dateObtained)")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .frame(height: 100)
                                        .background(Color.gray.opacity(0.5))
                                        .cornerRadius(10)
                                }.frame(maxWidth: .infinity)
                                if rowIndex * 2 + 1 < viewModel.user.badges.count {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("\(viewModel.user.badges[rowIndex * 2 + 1].dateObtained)")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .frame(height: 100)
                                            .background(Color.gray.opacity(0.5))
                                            .cornerRadius(10)
                                    }.frame(maxWidth: .infinity)
                                }  else {
                                    Spacer()
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }.toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Profile")
                        .font(.system(size: 32, weight: .bold))
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
