//
//  LoginView.swift
//  VineyardAssignment
//
//  Created by Aja Sampath on 9/10/24.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            
            
            
            TextField("Enter username", text: $username)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
                .padding(.horizontal, 20)
            
            SecureField("Enter password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
                .padding(.horizontal, 20)
            
            Button(action: {
                authenticateUser()
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(5)
                    .padding(.horizontal, 20)
            }
            NavigationLink(destination: ResetPasswordView()) {
                Text("Forgot Password?")
            }

            
        }

    }

                    func authenticateUser() {
                        if username == "TestUser" && password == "Password123" {
                            isAuthenticated = true
                        } else {
                            isAuthenticated = false
                        }
                    }
                }

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isAuthenticated: .constant(false))
    }
}
