//
//  SplashView.swift
//  DietApp
//
//  Created by Omar Yunusov on 21.02.26.
//

import SwiftUI

struct SplashView: View {
    
    @State private var isActive = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity = 0.5
    
    
    var body: some View {
        if isActive {
            LoginView()
        } else {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                Image(.dietAppLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240, height: 240)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.scale = 1.0
                            self.opacity = 1.0
                        }
                    }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
