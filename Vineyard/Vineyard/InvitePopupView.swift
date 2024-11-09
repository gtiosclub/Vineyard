//
//  InvitePopupView.swift
//  Vineyard
//
//  Created by Степан Кравцов on 31/10/24.
//

import SwiftUI

struct InvitePopupView: View {
    @EnvironmentObject var inviteViewModel: InviteViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
//    private let dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM/dd/YYYY"
//        return formatter
//    }()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            VStack {
                
                Text("\(inviteViewModel.inviter!.name) invited you to \(inviteViewModel.group!.name)!")
                    .bold()
                    .font(.title3)
                HStack {
                    HStack(spacing: -20 * 0.5) {
                        ForEach(0..<inviteViewModel.group!.peopleIDs.count) { index in
                            ZStack {
                                Circle()
                                    .foregroundStyle(Color.black.opacity(0.3))
                                    .frame(width: 21, height: 21)
                                    .zIndex(Double(inviteViewModel.group!.peopleIDs.count - index))
                                Circle()
                                    .foregroundStyle(.ultraThinMaterial)
                                    .frame(width: 20, height: 20)
                                    .zIndex(Double(inviteViewModel.group!.peopleIDs.count - index))
                                
                            }
                            
                        }
                    }
                    Text("\(inviteViewModel.group!.peopleIDs.count) \(inviteViewModel.group!.peopleIDs.count == 1 ? "person" : "people")")
                        .bold()
                    Spacer()
                    Text("\(inviteViewModel.group!.resolutionIDs.count) \(inviteViewModel.group!.resolutionIDs.count == 1 ? "Resolution" : "Resolutions")")
                    
                }
                //.frame(maxWidth: .infinity)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
                .padding(.horizontal, 24)
                Text("Group goal: \(inviteViewModel.group!.groupGoal)")
                Spacer()
                    .frame(height: 50)
                HStack(spacing: 40) {
                    Button(action:{
                        Task {
                            await inviteViewModel.joinGroup(currentUser: loginViewModel.currentUser)
                            inviteViewModel.invitedToGroup = false
                            inviteViewModel.groupID = nil
                            inviteViewModel.inviterID = nil
                        }
                    }) {
                        Text("Accept invite")
                            .foregroundStyle(.black)
                            .bold()
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundStyle(.ultraThinMaterial)
                            }
                    }
                    Button(action:{
                        dismiss()
                        inviteViewModel.invitedToGroup = false
                        inviteViewModel.groupID = nil
                        inviteViewModel.inviterID = nil
                        
                    }) {
                        Text("Decline invite")
                            .foregroundStyle(.black)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundStyle(.ultraThinMaterial)
                            }
                    }
                }
                
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(.white)
                
                .shadow(radius: 10)
        }
    }
}

#Preview {
    @Previewable @StateObject var model = InviteViewModel()
    
    InvitePopupView().environmentObject(model)
}
