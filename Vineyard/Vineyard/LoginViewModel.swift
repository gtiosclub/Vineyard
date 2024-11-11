//
//  LoginViewModel.swift
//  Vineyard
//
//  Created by Tony Nguyen on 9/15/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase
enum LoginErrors: Error, LocalizedError {
    //use these as error handling for adding warning messages
    case invalidEmail
    case invalidPassword
    case connectionError
    case passwordLength
    case incorrectEmail
    case invalidUsername

    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Invalid email address."
        case .invalidUsername:
            return "Invalid username."
        case .invalidPassword:
            return "Password is incorrect."
        case .connectionError:
            return "Network connection issue."
        case .incorrectEmail:
            return "Email is invalid"
        case .passwordLength:
            return "Password is invalid"
        case .unknownError(let message):
            return message
        }
    }
}
@MainActor
class LoginViewModel: ObservableObject {
    @Published var currentUser: Person?
    @Published var isLoading = false
    @Published var isLoggedIn = false
    @Published var errorMessage: String = ""
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    private var loginModel = LoginModel()

    public func signIn(email: String, password: String) async {
        errorMessage = ""
        isLoading = true
        
        do {
            try await loginModel.signIn(email: email, password: password)
            guard let uid = auth.currentUser?.uid else {
                errorMessage = "User ID not found."
                isLoggedIn = false
                return
            }
            
            let user = try await FirebaseDataManager.shared.fetchPersonFromDB(
                userID: auth.currentUser!.uid
            )

            currentUser = user
            isLoggedIn = true
        } catch {
            isLoggedIn = false
            handleFirebaseError(error: error)
        }
        
        isLoading = false
    }

    
    public func checkLoggedIn() async {
        if auth.currentUser != nil {
            isLoggedIn = true
            do {
                let user = try await FirebaseDataManager.shared.fetchPersonFromDB(
                    userID: auth.currentUser!.uid
                )

                currentUser = user
            } catch {
                print(error)
            }
        } else {
            isLoggedIn = false
            print("asdf")
        }

    }
    public func createUser(email: String, password: String, name: String, age: Int) async {
        isLoading = true
        errorMessage = ""
        do {
            try await loginModel.createUser(email: email, password: password)
            let newUser = Person(id: auth.currentUser!.uid, name: name, email: email)
            print(newUser)
            try db.collection("people").document(auth.currentUser!.uid).setData(from: newUser)
            currentUser = newUser
            
            isLoggedIn = true
        } catch {
            handleFirebaseError(error: error)
        }
        if name.isEmpty {
            errorMessage = LoginErrors.invalidUsername.errorDescription ?? ""
        }
        isLoading = false
    }
    
    public func signOut() async {
        do {
            try await loginModel.signOut()
            currentUser = nil
            isLoggedIn = false
        } catch {
            //add signout error handleFirebaseError(error: )
            errorMessage = "Error signing out: \(error.localizedDescription)"
        }
    }
    
    public func resetPassWithEmail(email: String) async -> Bool {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            errorMessage = "Failed to send email"
        }
        return true
    }
    
    func getCurrentUserBadges() async {
        guard let badgeIDs = currentUser?.badgeIDs else { return }

        do {
            let badges = try await FirebaseDataManager.shared.fetchBadgesFromDB(badgeIDs: badgeIDs)
            self.currentUser?.badges = badges
        } catch {
            print("Error fetching badges: \(error.localizedDescription)")
        }
    }

    private func handleFirebaseError(error: Error) {
        
        let authError = error as NSError
        switch authError.code {
        case AuthErrorCode.invalidEmail.rawValue:
            errorMessage = LoginErrors.invalidEmail.errorDescription ?? ""
        case AuthErrorCode.wrongPassword.rawValue:
            errorMessage = LoginErrors.invalidPassword.errorDescription ?? ""
        case AuthErrorCode.networkError.rawValue:
            errorMessage = LoginErrors.connectionError.errorDescription ?? ""
        case AuthErrorCode.weakPassword.rawValue:
            errorMessage = LoginErrors.passwordLength.errorDescription ?? ""
        default:
            errorMessage = LoginErrors.unknownError(authError.localizedDescription).errorDescription ?? ""
        }
    }

}
