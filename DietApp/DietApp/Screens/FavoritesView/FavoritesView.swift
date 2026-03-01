//
//  FavoritesView.swift
//  DietApp
//
//  Created by Omar Yunusov on 27.02.26.
//

import SwiftUI

struct FavoritesView: View {
    
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.favorites) { recipe in
                    FavoriteRowView(recipe: recipe)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.delete(recipe)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
                .onDelete(perform: viewModel.deleteFavorite)
                
            }
            .listStyle(.plain)
            .navigationTitle("Favorites")
        }
        .onAppear {
            viewModel.fetchFavorites()
        }
    }
}
