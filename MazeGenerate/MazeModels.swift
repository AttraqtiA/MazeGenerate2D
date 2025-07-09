//
//  Untitled.swift
//  MazeGenerate
//
//  Created by Samuel Miracle Kristanto on 09/07/25.
//

import Foundation

struct MazeCell {
    var topWall = true, bottomWall = true, leftWall = true, rightWall = true
    var visited = false
}

struct Point: Hashable {
    var x: Int, y: Int
}

struct MazeChunk: Identifiable {
    let id = UUID()
    let grid: [[MazeCell]]
    let entryY: Int
    let exitY: Int
}
