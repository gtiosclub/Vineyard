//
//  LoginModel.swift
//  Vineyard
//
//  Created by Tony Nguyen on 9/15/24.
//
import FirebaseAuth
import Foundation
struct LoginModel {
    let auth = Auth.auth()
    public func createUser(email: String, password: String) async throws {
        try await auth.createUser(withEmail:email, password: password)
        guard Auth.auth().currentUser != nil else {
            print("Failed to create currentUser in createUser")
            return
        }
        print("User \(email) created")
        }
    
    public func signIn(email: String, password: String) async throws {
        let authResult = try await auth.signIn(withEmail: email, password: password)
        print("User has Signed In")
        //todo add error messages when login fails
    }
    public func signOut() async throws{
        try auth.signOut()
    }
    public func resetPassWithEmail(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }

}
