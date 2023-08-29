//
//  NetworkService.swift
//  RickandMortyWiki
//
//  Created by Omar Regalado on 24/08/23.
//

import Foundation

protocol RickandMortyServiceProtocol {
    func getCharactersInfo() async throws -> Root
    func loadMore(url: String) async throws -> Root
    func getCharactersWithFilters(status: String) async throws -> Root
    func fetchEpisodes(from characterEpisodesURL: [String]) async throws -> [Episode]
}

class RickAndMortyService: RickandMortyServiceProtocol {
    
    private var baseURLComponents: URLComponents {
        var components = CharactersEndpoint.baseURLComponents
        components.path = "/api/character"
        return components
    }

    func getCharactersInfo() async throws -> Root {
        let urlComponents = baseURLComponents
                
        guard let url = urlComponents.url else {
            throw RickAndMortyServiceError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let root = try decoder.decode(Root.self, from: data)
        return root
    }
    
    func loadMore(url: String) async throws -> Root {
        guard let url = URL(string: url) else {
            throw RickAndMortyServiceError.invalidURL
        }
                
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let root = try decoder.decode(Root.self, from: data)
        return root
    }
    
    func getCharactersWithFilters(status: String) async throws -> Root {
        var urlComponents = baseURLComponents
        urlComponents.queryItems = [URLQueryItem(name: "status", value: status)]
        
        guard let url = urlComponents.url else {
            throw RickAndMortyServiceError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let root = try decoder.decode(Root.self, from: data)
        return root
    }
    
    func fetchEpisodes(from characterEpisodesURL: [String]) async throws -> [Episode]{
        var episodes: [Episode] = []
        
        for episodeURL in characterEpisodesURL {
            do {
                guard let url = URL(string: episodeURL) else {
                    throw RickAndMortyServiceError.invalidURL
                }
                let episode = try await fetchEpisode(from: url)
                episodes.append(episode)
            } catch {
                print(error.localizedDescription)
            }
        }
        return episodes
    }
    
    private func fetchEpisode(from url: URL) async throws -> Episode {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let episode = try decoder.decode(Episode.self, from: data)
        return episode
    }
}

enum RickAndMortyServiceError: Error {
    case invalidURL
}

struct CharactersEndpoint {
    static var baseURLComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rickandmortyapi.com"
        return components
    }
}

