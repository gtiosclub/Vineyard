//
//  LoginView.swift
//  VineyardAssignment
//
//  Created by Aja Sampath on 9/10/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var username: String = ""

    @State private var password: String = ""
    @State var isAuthenticated: Bool = false
    @State private var showAlert = false //temp
    @EnvironmentObject private var loginViewModel: LoginViewModel

    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Text("Vineyard")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 0)
                    .padding(.bottom, 20)
                TextField("Enter email", text: $email)
                    .padding()
                    .frame(height: 40)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                    .padding(.horizontal, 40)
                
                SecureField("Enter password", text: $password)
                    .padding()
                    .frame(height: 40)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                    .padding(.horizontal, 40)
                
                Button(action: {
                    Task {
                        await loginViewModel.signIn(email:email, password:password)
                    }
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(5)
                        .padding(.horizontal, 40)
                }
                if (!loginViewModel.errorMessage.isEmpty) {
                    Text(loginViewModel.errorMessage)
                        .foregroundColor(.red)
                }
                NavigationLink(destination: ResetPasswordView()) {
                    Text("Forgot Password?")
                }
                
                NavigationLink(destination: SignUpView()) {
                    Text("New here?")
                }
                
            }
            
            .padding(.top, -120)

            .onAppear() {
                loginViewModel.errorMessage = ""
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
