//
//  Helper.swift
//  DemoTrain
//
//  Created by Athira Krishnan on 28.01.24.
//

import Foundation

// MARK: - String
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


