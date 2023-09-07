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
    func fetchEpisodes(from episodesURL: [String]) async throws -> [Episode]
    func fecthCharacter(from characterURL: String) async throws -> Character
}

protocol UserDefaultsManagerProtocol {
    func save<Element: Codable>(data: Element, key: String)
}

class UserDefaultsManager: UserDefaultsManagerProtocol {
    
    let userDefaults = UserDefaults.standard
    
    func save<Element: Codable>(data: Element, key: String) {
        guard let encodedData = try? JSONEncoder().encode(data) else {
            return
        }
        userDefaults.set(encodedData, forKey: key)
    }
    
    
}

class RickAndMortyService: RickandMortyServiceProtocol {
        
    private var baseURLComponents: URLComponents {
        var components = CharactersEndpoint.baseURLComponents
        components.path = "/api/character"
        return components
    }
    
    fileprivate func execute<T: Decodable>(url: URL, dataType: T.Type) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let responseHTTP = response as? HTTPURLResponse,
              responseHTTP.statusCode == 200 else {
            throw RickAndMortyServiceError.codeError
        }
        let decoder = JSONDecoder()
        let respnseData = try decoder.decode(T.self, from: data)
        return respnseData
    }

    func getCharactersInfo() async throws -> Root {
        let urlComponents = baseURLComponents
                
        guard let url = urlComponents.url else {
            throw RickAndMortyServiceError.invalidURL
        }
        return try await execute(url: url, dataType: Root.self)
    }
    
    func loadMore(url: String) async throws -> Root {
        guard let url = URL(string: url) else {
            throw RickAndMortyServiceError.invalidURL
        }
                
        return try await execute(url: url, dataType: Root.self)
    }
    
    func getCharactersWithFilters(status: String) async throws -> Root {
        var urlComponents = baseURLComponents
        urlComponents.queryItems = [URLQueryItem(name: "status", value: status)]
        
        guard let url = urlComponents.url else {
            throw RickAndMortyServiceError.invalidURL
        }
        
        return try await execute(url: url, dataType: Root.self)
    }
    
    func fetchEpisodes(from episodesURL: [String]) async throws -> [Episode]{
        var episodes: [Episode] = []
        
        for episodeURL in episodesURL {
            do {
                guard let url = URL(string: episodeURL) else {
                    throw RickAndMortyServiceError.invalidURL
                }
                let episode = try await fetchEpisode(from: url)
                episodes.append(episode)
            } catch {
                throw error
            }
        }
        return episodes
    }
    
    private func fetchEpisode(from url: URL) async throws -> Episode {
        return try await execute(url: url, dataType: Episode.self)
    }
    
    func fecthCharacter(from characterURL: String) async throws -> Character {
        guard let url = URL(string: characterURL) else {
            throw RickAndMortyServiceError.invalidURL
        }
        
        return try await execute(url: url, dataType: Character.self)
    }
}

enum RickAndMortyServiceError: Error {
    case invalidURL
    case codeError
}

struct CharactersEndpoint {
    static var baseURLComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rickandmortyapi.com"
        return components
    }
}

