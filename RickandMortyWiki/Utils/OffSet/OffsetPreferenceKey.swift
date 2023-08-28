//
//  OffsetPreferenceKey.swift
//  RickandMortyWiki
//
//  Created by Omar Regalado on 27/08/23.
//

import Foundation
import SwiftUI

struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: [CGFloat] = []
    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}
