//
//  DashboardView.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import SwiftUI

struct DashboardView: View {
    private var widgets: [Widget] = [TodaysTasksWidget(), RecentActivitiesWidget()]
    @EnvironmentObject var inviteViewModel: InviteViewModel
   
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing:10) {
                //heading
                HStack {
                    VStack(alignment: .leading) {
                        Text("Dashboard")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(Date.now, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    Image(systemName: "ellipsis")
                        .font(.title)
                        .offset(y: -9)
                        .foregroundColor(.gray)
                }
                .padding([.horizontal, .top])
                .padding(.top, 20)
                
                VStack(spacing: 20) {
                    ForEach(widgets.indices, id:\.self) { index in
                        widgets[index].render()
                        
                    }
                }
                .padding()
            }
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
    DashboardView()
}
