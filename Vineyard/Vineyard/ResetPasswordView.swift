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
                        await loginViewModel.resetPassWithEmail(email: email)
                    }
                }) {
                    Text("Resend Email")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                Text(loginViewModel.errorMessage)
                .padding(.top, 20)
            }
            .onAppear() {
                loginViewModel.errorMessage = ""
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
                        Submitted = await loginViewModel.resetPassWithEmail(email: email)
                        
                    }

                }, label: { Text("Send Email Reset")
                        .padding(.horizontal, 30)
                        .padding(.vertical, 8)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding()
                    })
                Text(loginViewModel.errorMessage)
            }
            .padding()
            .onAppear() {
                loginViewModel.errorMessage = ""
            }
        }
    }
    
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
