//
//  LoginView.swift
//  VineyardAssignment
//
//  Created by Jin Lee on 9/10/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var username: String = ""

    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @EnvironmentObject private var loginViewModel: LoginViewModel
    var body: some View {
        VStack(spacing: 10) {
            Text("Create Account")
                .font(.largeTitle)
                .bold()
                .padding(.top, 180)
                .padding(.bottom, 10)

            TextField("Username", text: $username)
                .padding(.horizontal, 10)
                .frame(height: 40)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .autocapitalization(.none)
                .padding(.horizontal, 40)
            TextField("Email", text: $email)
                .padding(.horizontal, 10)
                .frame(height: 40)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .autocapitalization(.none)
                .padding(.horizontal, 40)

            SecureField("Password", text: $password)
                .padding(.horizontal, 10)
                .frame(height: 40)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal, 40)

            SecureField("Confirm Password", text: $confirmPassword)
                .padding(.horizontal, 10)
                .frame(height: 40)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal, 40)

            if (!loginViewModel.errorMessage.isEmpty) {
                Text(loginViewModel.errorMessage)
                    .foregroundColor(.red)
            }
            Button(action: {
                Task {
                    await loginViewModel.createUser(email: email, password: password, name: username, age: 1)
                }
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal, 130)
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .onAppear() {
            loginViewModel.errorMessage = ""
        }
        .padding()
    }

}
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
