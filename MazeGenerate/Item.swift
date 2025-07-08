//
//  Item.swift
//  MazeGenerate
//
//  Created by Samuel Miracle Kristanto on 08/07/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
