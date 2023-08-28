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
}

class RickAndMortyService: RickandMortyServiceProtocol {
    
    private let baseURL = URL(string: "https://rickandmortyapi.com/api/")!

    func getCharactersInfo() async throws -> Root {
        let url = baseURL.appendingPathComponent("character")
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let root = try decoder.decode(Root.self, from: data)
        return root
    }
    
    func loadMore(url: String) async throws -> Root {
        let url = URL(string: url)!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let root = try decoder.decode(Root.self, from: data)
        return root
    }
}
