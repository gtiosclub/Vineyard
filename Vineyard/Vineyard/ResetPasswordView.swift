//
//  ResetPassword.swift
//  VineyardAssignment
//
//  Created by Tony Nguyen on 9/10/24.
//
import Foundation
import SwiftUI
import FirebaseAuth
struct ResetPasswordView: View {
    @State var Submitted: Bool = false
    @State var email: String = ""
    @State var errorHandling: String = ""
    @EnvironmentObject var loginViewModel: LoginViewModel
    var body: some View {
        if Submitted {
            VStack {
                Text("Email Sent!")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                Text("An email with instructions to reset your password has been sent.")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()

                
                Button(action: {
                    Task {
                        try await loginViewModel.resetPassWithEmail()
                    }
                }) {
                    Text("Resend Email")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                    Text(errorHandling)
                }
                .padding(.top, 20)
            }
            .padding()
        } else {
            VStack(spacing: 25) {
                
                Text("Vineyard")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                TextField("Email", text: $email)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .foregroundColor(.black)

                
                Button(action: {
                    Task {
                        try await loginViewModel.resetPassWithEmail()

                    }
                    Submitted = true
                }, label: { Text("Send Email Reset")
                        .padding(.horizontal, 30)
                        .padding(.vertical, 8)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding()
                    })
                Text(errorHandling)
            }
            .padding()
        }
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
