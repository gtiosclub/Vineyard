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
    @Published var isLoading = false
    @Published var isLoggedIn = false
    @Published var errorMessage: String = ""
    private let db = Firestore.firestore()
    private var loginModel = LoginModel()

    public func signIn(email: String, password: String) async {
        errorMessage = ""
        do {
            try await loginModel.signIn(email: email, password: password)
            isLoggedIn = true
        } catch {
            isLoggedIn = false
            handleFirebaseError(error: error)
        }
        isLoading = false
    }
    public func checkLoggedIn() {
        if Auth.auth().currentUser != nil {
            isLoggedIn = true
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
            let newUser = Person(name: "", emails: "")
            //try await  db.document() create the firestore path here and add person or other data
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
    public func signOut() {
        do {
            try loginModel.signOut()
            isLoggedIn = false
        }
        catch {
            //handle these errors visually
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