//
//  InviteTestView.swift
//  Vineyard
//
//  Created by Степан Кравцов on 29/10/24.
//

import SwiftUI
import PopupView

struct InviteTestView: View {
    @State var invited: Bool = false
    var body: some View {
        Button(action: {generateTestInvite()}) {
            Text("Invite")
        }
    }
    func generateTestInvite() {
        var components = URLComponents()
            components.scheme = "vineyard"
            components.host = "join-group"
            components.queryItems = [
                URLQueryItem(name: "group", value: "6011868E-42DB-4F50-A02D-2CBE50AF4736"),
                URLQueryItem(name: "inviter", value: "q7tdzEjiZpSfB578wiHRjelsDxU2")
            ]

            // Getting a URL from our components is as simple as
            // accessing the 'url' property.
            let url = components.url
        print(url)
    }
}

#Preview {
    InviteTestView()
}
