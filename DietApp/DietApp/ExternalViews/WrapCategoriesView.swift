//
//  WrapCategoriesView.swift
//  DietApp
//
//  Created by Omar Yunusov on 01.03.26.
//

import SwiftUI

struct WrapCategoriesView: View {
    
    let categories: [String]
    @Binding var selected: Set<String>
    
    let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 10)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
            
            ForEach(categories, id: \.self) { category in
                Button {
                    if selected.contains(category) {
                        selected.remove(category)
                    } else {
                        selected.insert(category)
                    }
                } label: {
                    Text(category)
                        .font(.subheadline)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            selected.contains(category)
                            ? Color.black
                            : Color.gray.opacity(0.2)
                        )
                        .foregroundColor(
                            selected.contains(category)
                            ? .white
                            : .primary
                        )
                        .clipShape(Capsule())
                }
            }
        }
    }
}
