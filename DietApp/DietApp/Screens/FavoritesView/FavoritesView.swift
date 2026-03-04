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
            
            Group {
                if viewModel.favorites.isEmpty {
                    
                    VStack(spacing: 16) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.gray.opacity(0.4))
                        
                        Text("No Favorites")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    
                } else {
                    
                    List {
                        ForEach(viewModel.favorites) { recipe in
                            
                            NavigationLink {
                                DetailView(recipe: recipe)
                            } label: {
                                FavoriteRowView(recipe: recipe)
                            }
                            .buttonStyle(.plain)
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
                }
            }
            .navigationTitle("Favorites")
        }
        .onAppear {
            viewModel.fetchFavorites()
        }
    }
}
