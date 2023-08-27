//
//  OffsetPreferenceKey.swift
//  RickandMortyWiki
//
//  Created by Omar Regalado on 27/08/23.
//

import Foundation

struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
