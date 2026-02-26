//
//  DietAppApp.swift
//  DietApp
//
//  Created by Omar Yunusov on 14.02.26.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      
      print("Project ID:", FirebaseApp.app()?.options.projectID ?? "NO PROJECT")
    return true
  }
}

@main
struct DietAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
