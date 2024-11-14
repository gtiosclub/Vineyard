//
//  GroupListView.swift
//  Vineyard
//
//  Created by Jiyoon Lee on 10/20/24.
//

import SwiftUI
import PopupView

struct GroupListView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var inviteViewModel: InviteViewModel
    @State var viewModel: GroupsListViewModel = .init()
    @State private var isPresentingAddGroup = false
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Your Groups")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("\(viewModel.user?.groupIDs.count ?? 0) active group(s)")
                            .foregroundColor(.white)
                            .font(.subheadline)
                        
                    }
                    Spacer()
                    
                    Button(action: {
                        print("changing mode")
                    }) {
                        Image(systemName: "list.bullet")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                    }
                    Button(action: {
                        print("add")
                        viewModel.isPresentingCreateGroupView = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                    }
                }
                .padding([.horizontal, .top])
                .padding(.top, 10)
                .padding(.bottom, 30)
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(viewModel.groups, id: \.id) { group in
                            NavigationLink(destination: GroupView(group: group)) {
                                GroupCardView(group: group)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .contextMenu {
                                Button(role: .destructive) {
                                    viewModel.leaveGroup(group)
                                } label: {
                                    Label("Leave Group", systemImage: "person.fill.xmark")
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarHidden(true)
            .background(alignment: .top) {
                Image("topBackground")
                    .ignoresSafeArea(.container, edges: .top)
            }
        }
        .fullScreenCover(isPresented: $viewModel.isPresentingCreateGroupView) {
            CreateGroupView().environment(viewModel)
        }
        .onAppear {
            viewModel.setUser(user: loginViewModel.currentUser)
            viewModel.loadGroups()
        }
        .popup(isPresented: $inviteViewModel.invitedToGroup) {
            InvitePopupView()
        } customize: {
            $0
            .type(.floater())
            .appearFrom(.bottomSlide)
            
        }
        .alert(isPresented: $inviteViewModel.inviteErrorStatus) {
            Alert(title: Text(inviteViewModel.inviteError ?? ""))
        }
    }
}

#Preview {
    GroupListView()
        .environmentObject(InviteViewModel())
        .environmentObject(LoginViewModel())
}
