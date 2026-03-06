//
//  RootView.swift
//  DietApp
//
//  Created by Omar Yunusov on 21.02.26.
//

import SwiftUI
import FirebaseAuth

struct RootView: View {
    
    @State private var isLoading = true
    @State private var isLoggedIn = false
    
    var body: some View {
        Group {
            if isLoading {
                SplashView()
            } else if isLoggedIn {
                MainTabbarView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            listenAuth()
        }
    }
    
    private func listenAuth() {
        Auth.auth().addStateDidChangeListener { _, user in
            DispatchQueue.main.async {
                self.isLoggedIn = user != nil
                self.isLoading = false
            }
        }
    }
}
