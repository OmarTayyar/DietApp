//
//  SearchView.swift
//  DietApp
//
//  Created by Omar Yunusov on 27.02.26.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject private var viewModel = SearchViewModel()
    @State private var isSearchFieldFocused = false
    @State private var showFilter = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.filteredRecipes.isEmpty {
                    Spacer()
                    Text("No dishes found")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.filteredRecipes) { recipe in
                            NavigationLink {
                                DetailView(recipe: recipe)
                            } label: {
                                FavoriteRowView(recipe: recipe)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Search")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showFilter.toggle()
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            .searchable(
                text: $viewModel.searchText,
                isPresented: $isSearchFieldFocused,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search dishes..."
            )
            .onAppear {
                isSearchFieldFocused = true
            }
        }
        .sheet(isPresented: $showFilter) {
            FilterSheetView(viewModel: viewModel)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}
