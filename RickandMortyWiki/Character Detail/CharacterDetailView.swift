//
//  CharacterDetailView.swift
//  RickandMortyWiki
//
//  Created by Omar Regalado on 25/08/23.
//

import SwiftUI
import CachedAsyncImage

struct CharacterDetailView: View {
    let character: Character

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
                                information: character.status)
                
                
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct InformationPage: View {
    let placeholder: String
    let information: String
    var statusColor: Color? = .primary
    
    var body: some View {
        HStack {
            Text(placeholder)
                .font(.title2)
                .bold()
            
            Spacer()
            
            Text(information)
                .font(.title2)
        }
        .padding(5)
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
