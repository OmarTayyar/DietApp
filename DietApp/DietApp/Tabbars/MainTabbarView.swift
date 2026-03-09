//
//  MainTabbarView.swift
//  DietApp
//
//  Created by Omar Yunusov on 27.02.26.
//

import SwiftUI

struct MainTabbarView: View {

    var body: some View {
        TabView {
            NavigationStack {
                MainView()
            }
            .tabItem {
                Image(systemName: "book.fill")
                Text("Main")
            }

            NavigationStack {
                FavoritesView()
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favorites")
            }

            NavigationStack {
                MyDietView()
            }
            .tabItem {
                Image(systemName: "leaf.fill")
                Text("My Diet")
            }

            NavigationStack {
                SearchView()
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }

            NavigationStack {
                MyProfileView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
        }
    }
}
