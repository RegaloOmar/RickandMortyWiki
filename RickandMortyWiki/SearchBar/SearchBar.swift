//
//  SearchBar.swift
//  RickandMortyWiki
//
//  Created by Omar Regalado on 27/08/23.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField(SearchBarLocalizedString.placeholder, text: $searchText)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
