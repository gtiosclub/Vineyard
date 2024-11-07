//
//  VineyardApp.swift
//  Vineyard
//
//  Created by Sankaet Cheemalamarri on 9/10/24.
//

import SwiftUI
import FirebaseCore

@main
struct VineyardApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var loginViewModel = LoginViewModel()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(loginViewModel)
                .onAppear() {
                    loginViewModel.checkLoggedIn()
                }
        }
    }
    class AppDelegate: NSObject, UIApplicationDelegate {
      func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
      }
    }
}
