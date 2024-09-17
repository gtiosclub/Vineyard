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
    func createUser(email: String, password: String) async throws {
        do {
            try await auth.createUser(withEmail:email, password: password)
            guard Auth.auth().currentUser != nil else {
                print("Failed to create currentUser in createUser")
                return
            }
            print("User \(email) created")
        }
        catch {
            print("Error creating user: \(error)")
            //todo add error message 
            throw error
        }
    }
    func signIn(email: String, password: String) async throws {
        do {
            let authResult = try await auth.signIn(withEmail: email, password: password)
            let user = authResult.user
            print("User has Signed In")
        } catch {
            print("Can't Sign in user: \(error.localizedDescription)")
        }
    }
    func signOut() async throws{
        try auth.signOut()
    }

}
