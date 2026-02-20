//
//  ContentView.swift
//  DietApp
//
//  Created by Omar Yunusov on 14.02.26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(.dietAppLogo)
                .resizable()
                .frame(width: 150, height: 150)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
