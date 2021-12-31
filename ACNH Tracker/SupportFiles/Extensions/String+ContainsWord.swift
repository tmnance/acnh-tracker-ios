//
//  String+ContainsWord.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/30/21.
//

import Foundation

extension String {
    func containsWord(startingWith searchText: String) -> Bool {
        return " \(self)".contains(" \(searchText.lowercased())")
    }

}
