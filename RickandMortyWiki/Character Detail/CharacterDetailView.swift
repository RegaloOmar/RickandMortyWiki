//
//  CharacterDetailView.swift
//  RickandMortyWiki
//
//  Created by Omar Regalado on 25/08/23.
//

import SwiftUI
import CachedAsyncImage

struct CharacterDetailView: View {
    @StateObject private var viewModel = CharacterDetailViewModel()
    let character: Character
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack {
                CachedAsyncImage(url: URL(string: character.image),
                                 urlCache: .imageCache){ phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 8)
                                    .foregroundColor(.green)
                            }
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                Text(character.name)
                    .font(.largeTitle)
                    .bold()
                
                InformationPage(placeholder: CharactersLocalizedString.locationPlaceholder,
                                information: character.location.name)
                
                InformationPage(placeholder: CharactersLocalizedString.genderPlaceholder,
                                information: character.gender)
                
                InformationPage(placeholder: CharactersLocalizedString.speciePlaceholder,
                                information: character.species)
                
                InformationPage(placeholder: CharactersLocalizedString.originPlaceholder,
                                information: character.origin.name)
                
                InformationPage(placeholder: CharactersLocalizedString.statusPlaceholder,
                                information: character.status.capitalized,
                                status: character.status)
                
                InformationPage(placeholder: CharactersLocalizedString.episodesCountPlaceholder,
                                information: String(character.episode.count))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: [GridItem(.flexible())]) {
                        ForEach(viewModel.episodes) { episode in
                            if isLoading {
                                Color.black.opacity(0.3)
                                    .ignoresSafeArea()
                                
                                SpinningProgressView()
                            } else {
                                EpisodeGridItem(episodeTitle: episode.name,
                                                episodeCode: episode.episode)
                            }
                        }
                    }
                    .onAppear{
                        isLoading = true
                        Task {
                            await viewModel.fetchEpisodes(characterEpisodes: character.episode)
                            isLoading = false
                        }
                    }
                }
                
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct InformationPage: View {
    let placeholder: String
    let information: String
    var status: String? = ""
    
    var body: some View {
        HStack {
            Text(placeholder)
                .font(.title2)
                .bold()
            
            Spacer()
            
            Text(information)
                .font(.title2)
                .foregroundColor(getFontColor(status ?? ""))
        }
        .padding(5)
    }
    
    private func getFontColor(_ status: String) -> Color{
        switch status {
        case FilterLocalizedString.alive:
            return Color.green
        case FilterLocalizedString.dead:
            return Color.red
        case FilterLocalizedString.unkown.lowercased():
            return Color.gray
        default:
            return Color.primary
        }
    }
    
}

struct EpisodeGridItem: View {
    let episodeTitle: String
    let episodeCode: String
    
    var body: some View {
        
        ZStack {
        
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("BlueRick"))
                .frame(width: 150, height: 150)
                .overlay {
                    VStack {
                        Text(episodeTitle)
                            .multilineTextAlignment(.center)
                            .font(.callout)
                            .bold()
                            .padding(.bottom, 5)
                        
                        Text(episodeCode)
                            .font(.headline)
                    }
            }
            
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 5)
                .foregroundColor(Color("GreenPortal"))
                
        }
        
    }
}

struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetailView(character: Character(id: 1,
                                                 name: "Rick Sanchez",
                                                 status: "Alive",
                                                 species: "Human",
                                                 type: "",
                                                 gender: "Male",
                                                 origin: Origin(name: "Earth (C-137)",
                                                                url: "https://rickandmortyapi.com/api/location/1"),
                                                 location: Location(name: "Citadel of Ricks",
                                                                    url: "https://rickandmortyapi.com/api/location/3"),
                                                 image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                                                 episode: [
                                                    "https://rickandmortyapi.com/api/episode/1",
                                                    "https://rickandmortyapi.com/api/episode/2",
                                                    "https://rickandmortyapi.com/api/episode/3",
                                                    "https://rickandmortyapi.com/api/episode/4",
                                                    "https://rickandmortyapi.com/api/episode/5",
                                                    "https://rickandmortyapi.com/api/episode/6",
                                                    "https://rickandmortyapi.com/api/episode/7",
                                                    "https://rickandmortyapi.com/api/episode/8",
                                                    "https://rickandmortyapi.com/api/episode/9",
                                                    "https://rickandmortyapi.com/api/episode/10",
                                                    "https://rickandmortyapi.com/api/episode/11",
                                                    "https://rickandmortyapi.com/api/episode/12",
                                                    "https://rickandmortyapi.com/api/episode/13",
                                                    "https://rickandmortyapi.com/api/episode/14"],
                                                 url: "https://rickandmortyapi.com/api/character/1",
                                                 created: "2017-11-04T18:48:46.250Z"))
    }
}
