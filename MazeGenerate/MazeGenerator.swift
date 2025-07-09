//
//  MazeGenerator.swift
//  MazeGenerate
//
//  Created by Samuel Miracle Kristanto on 09/07/25.
//

import Foundation

class MazeGenerator {
    let width: Int
    let height: Int

    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    func generateChunk(entryY: Int) -> MazeChunk {
        var grid = Array(repeating: Array(repeating: MazeCell(), count: height), count: width)
        var stack: [Point] = []
        
        let startPoint = Point(x: 0, y: entryY)
        grid[startPoint.x][startPoint.y].visited = true
        stack.append(startPoint)

        while !stack.isEmpty {
            let currentPoint = stack.last!
            let neighbors = getUnvisitedNeighbors(for: currentPoint, in: grid)
            
            if let nextPoint = neighbors.randomElement() {
                grid = removeWall(from: currentPoint, to: nextPoint, in: grid)
                grid[nextPoint.x][nextPoint.y].visited = true
                stack.append(nextPoint)
            } else {
                stack.removeLast()
            }
        }
        
        grid[0][entryY].leftWall = false
        let exitY = Int.random(in: 0..<height)
        grid[width - 1][exitY].rightWall = false
        
        return MazeChunk(grid: grid, entryY: entryY, exitY: exitY)
    }
    
    private func getUnvisitedNeighbors(for point: Point, in grid: [[MazeCell]]) -> [Point] {
        var neighbors: [Point] = []
        let potential = [
            Point(x: point.x, y: point.y - 1), Point(x: point.x + 1, y: point.y),
            Point(x: point.x, y: point.y + 1), Point(x: point.x - 1, y: point.y)
        ]
        for p in potential {
            if (0..<width).contains(p.x) && (0..<height).contains(p.y) && !grid[p.x][p.y].visited {
                neighbors.append(p)
            }
        }
        return neighbors
    }

    private func removeWall(from: Point, to: Point, in grid: [[MazeCell]]) -> [[MazeCell]] {
        var newGrid = grid
        if from.x < to.x { newGrid[from.x][from.y].rightWall = false; newGrid[to.x][to.y].leftWall = false }
        else if from.x > to.x { newGrid[from.x][from.y].leftWall = false; newGrid[to.x][to.y].rightWall = false }
        else if from.y < to.y { newGrid[from.x][from.y].bottomWall = false; newGrid[to.x][to.y].topWall = false }
        else if from.y > to.y { newGrid[from.x][from.y].topWall = false; newGrid[to.x][to.y].bottomWall = false }
        return newGrid
    }
}
