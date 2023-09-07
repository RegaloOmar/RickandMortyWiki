//
//  ImageCache.swift
//  RickandMortyWiki
//
//  Created by Omar Regalado on 25/08/23.
//

import Foundation
import SwiftUI

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512_000_000, diskCapacity: 10_000_000_000)
}
