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
    @State private var selectedFilter = "All"
    @State private var showFilters = false
    private var filterList = ["All", "Alive", "Dead", "Unkown"]
    
    var body: some View {
       NavigationView {
           GeometryReader { geometry in
               ZStack {
                   ScrollView {
                       ScrollViewReader { scrollView in
                           LazyVGrid(columns: [GridItem(.fixed(CGFloat((geometry.size.width / 2) - 5))),
                                               GridItem(.fixed(CGFloat((geometry.size.width / 2) - 5)))],
                                     spacing: 5) {
                               ForEach(filteredCharacters) { character in
                                   NavigationLink(destination: CharacterDetailView(character: character)) {
                                       CharacterView(character: character)
                                           .onAppear {
                                               if character.id == viewModel.characters.last?.id {
                                                   Task {
                                                       await viewModel.loadMore()
                                                   }
                                               }
                                           }
                                   }
                               }
                           }
                           .onAppear {
                               scrollView.scrollTo(0)
                               Task {
                                   await viewModel.fetchCharactersData()
                               }
                           }
                           .searchable(text: $searchText,
                                       placement: .navigationBarDrawer(displayMode: .automatic),
                                       prompt: SearchBarLocalizedString.placeholder)
                       }
                       
                   }
                   .sheet(isPresented: $showFilters, content: {
                       List(filterList, id: \.self) { filter in
                           HStack {
                               Text(filter)
                           }
                       }
                       .preferredColorScheme(.dark)
                   })
                   
                   .scrollIndicators(.never)
                   .navigationTitle("Rick-O-pedia")
               }
               
               VStack {
                   Spacer()
                   HStack {
                       Spacer()
                       Button {
                           showFilters.toggle()
                       } label: {
                           Image(systemName: "line.3.horizontal.decrease.circle.fill")
                               .resizable()
                               .frame(width: geometry.size.width/7,
                                      height: geometry.size.width/7)
                               .foregroundColor(.cyan)
                               .background {
                                   Circle()
                                       .foregroundColor(.white)
                               }
                       }
                       
                       
                   }
                   .padding()
               }
           }
           .navigationBarTitleDisplayMode(.inline)
       }
   }
    
    //MARK:- Search Bar function
    private var filteredCharacters: [Character] {
        if searchText.isEmpty {
            return viewModel.characters
        } else {
            return viewModel.characters.filter({
                $0.name.localizedStandardContains(searchText)
            })
        }
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
        case FilterLocalizedString.alive:
            return Color.green
        case FilterLocalizedString.dead:
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
