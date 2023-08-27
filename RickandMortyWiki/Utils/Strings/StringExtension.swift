//
//  StringExtension.swift
//  RickandMortyWiki
//
//  Created by Omar Regalado on 25/08/23.
//

import Foundation

extension String {
    public func localizedString() -> String {
        return NSLocalizedString(self, tableName: "LocalizableStrings", bundle: Bundle(for: CharacterListViewModel.self), value: "", comment: "")
    }
}
