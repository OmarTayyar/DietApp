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
            checkAuth()
        }
    }
    
    private func checkAuth() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoggedIn = Auth.auth().currentUser != nil
            self.isLoading = false
        }
    }
}

