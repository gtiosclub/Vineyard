//
//  LoginView.swift
//  VineyardAssignment
//
//  Created by Jin Lee on 9/10/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String = ""

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

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            Button(action: {
                signUp()
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
        .padding()
    }

    func signUp() {
        if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "All fields are required"
            return
        }

        if password != confirmPassword {
            errorMessage = "Passwords do not match"
            return
        }
        
        errorMessage = "Sign-up successful!"
    }
}
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
