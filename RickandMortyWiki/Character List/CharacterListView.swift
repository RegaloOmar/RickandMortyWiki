//
//  CharacterListView.swift
//  RickandMortyWiki
//
//  Created by Omar Regalado on 24/08/23.
//

import SwiftUI
import CachedAsyncImage

struct CharacterListView: View {
    
    @StateObject private var viewModel = CharacterListViewModel()
    @State private var searchText = ""
    @State private var isSearchBarHidden = false
    
    var body: some View {
       NavigationView {
           VStack {
               HStack {
                   SearchBar(searchText: $searchText)
                       .padding()
                       .transition(.move(edge: .top))
               }
               GeometryReader { geometry in
                   ScrollView {
                       ScrollViewReader { scrollView in
                           LazyVGrid(columns: [GridItem(.fixed(CGFloat((geometry.size.width / 2) - 5))),
                                               GridItem(.fixed(CGFloat((geometry.size.width / 2) - 5)))],
                                     spacing: 5) {
                               ForEach(filteredCharacters) { item in
                                   NavigationLink(destination: CharacterDetailView(character: item)) {
                                       CharacterView(character: item)
                                   }
                               }
                           }
                           .onAppear {
                               Task {
                                   await viewModel.fetchCharactersData()
                               }
                           }
                       }
                   }
                   .scrollIndicators(.never)
                   .navigationTitle("Rick-O-pedia")
               }
           }
       }
   }
    
    //MARK:- Search Bar function
    private var filteredCharacters: [Character] {
        searchText.isEmpty ? viewModel.characters : viewModel.characters.filter({
            $0.name.localizedStandardContains(searchText)
        })
    }
}

struct CharacterView: View {
    let character: Character
    
    var body: some View {
        ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.green)
            
            VStack{
                CachedAsyncImage(url: URL(string: character.image),
                                 urlCache: .imageCache){ phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle()
                                .stroke(lineWidth: 1.5)
                                .foregroundColor(.green))
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
             
                HStack {
                    Text(character.name)
                        .font(.system(.headline,
                                      design: .rounded,
                                  weight: .bold))
                        .foregroundColor(.primary)
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(colorFromStatus(character.status))
                }
                Text("Last Seen in:")
                    .font(.system(.callout))
                    .foregroundColor(.primary)
                Text(character.location.name)
                    .font(.system(.footnote))
                    .foregroundColor(.primary)
                    
                Spacer()
                
            }
            .padding()
        }
    }
    
    func colorFromStatus(_ status: String) -> Color {
        switch status {
        case "Alive":
            return Color.green
        case "Dead":
            return Color.red
        default:
            return Color.gray
        }
    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
            .preferredColorScheme(.dark)
    }
}
