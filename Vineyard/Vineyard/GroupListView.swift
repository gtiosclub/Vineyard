//
//  GroupListView.swift
//  Vineyard
//
//  Created by Jiyoon Lee on 10/20/24.
//

import SwiftUI

struct GroupListView: View {
    @StateObject var viewModel = GroupListViewModel()
    //let activityProg = progress.completionArray.count / progress.frequencyGoal.count
    var body: some View {
        VStack (alignment: .center) {
            HStack {
                VStack (alignment: .leading) {
                    Text("Your Groups")
                        .font(.system(size: 30, weight: .bold))
                    Text("\(viewModel.person.groups.count) active group(s)")
                }
                Spacer()
                Image(systemName: "list.bullet")
                Image(systemName: "plus")
            }.padding(40)
            ForEach(viewModel.person.groups) { group in
                VStack {
                    HStack {
                        Text(group.name)
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                        let number = group.people.count
                        Text("\(number) People")
                        ZStack(alignment: .trailing) { // Use ZStack for overlapping circles
                            ForEach(0..<number, id: \.self) { i in
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 40, height: 40)
                                    .overlay(Circle().stroke(Color.black, lineWidth: 3))
                                    .offset(x: CGFloat(i) * 15)
                            }
                        }
                    }.padding()
                    HStack {
                        Spacer()
                        let userProg = 0.0 //What do we want here???
                        ProgressView(value: 0.0, total: 100)
                            .progressViewStyle(LinearProgressViewStyle())
                            .frame(width: 100)
                    }
                }
            }
                .frame(maxWidth: 250, minHeight: 70)
                .padding(40)
                .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(.gray).opacity(0.3))
                )
            Spacer()
        }
        
    }
}

#Preview {
    GroupListView()
}
