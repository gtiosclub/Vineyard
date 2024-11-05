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
                URLQueryItem(name: "group", value: "10E765E6-7D77-47A9-A8A2-2D6AD05F3CA4"),
                URLQueryItem(name: "inviter", value: "nYHL6RNMleQWhs3liYxlqzfCDl32")
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
