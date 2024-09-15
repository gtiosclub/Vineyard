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
    
    @State private var showAlert = false //temp
    @State private var alertMessage = "" //temp
    
    //dict
    let userCred: [String: String] = [
        "Test1": "pass123",
        "Test2": "pass456",
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Text("Vineyard")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 0)
                    .padding(.bottom, 20)
                
                TextField("Enter username", text: $username)
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
                    authenticateUser()
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
                
                NavigationLink(destination: ResetPasswordView()) {
                    Text("Forgot Password?")
                }
                
                NavigationLink(destination: SignUpView()) {
                    Text("New here?")
                }
                
            }
            
            .padding(.top, -120)
            
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertMessage))
            } //temp
            
        }
    }
    
    func authenticateUser() {
        if let storedPassword = userCred[username], storedPassword == password {
            isAuthenticated = true
            
            alertMessage = "Login Successful" //temp
        } else {
            isAuthenticated = false
            alertMessage = "Login Failed" //temp
        }
        
        showAlert = true //temp
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isAuthenticated: .constant(false))
    }
}
