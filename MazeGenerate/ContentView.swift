//
//  ContentView.swift
//  MazeGenerate
//
//  Created by Samuel Miracle Kristanto on 08/07/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var mazeManager = InfiniteMazeManager()
    
    var body: some View {
        GeometryReader { geometry in
            let cellSize = geometry.size.height / CGFloat(mazeManager.chunkHeight)
            let chunkWidth = cellSize * CGFloat(mazeManager.chunkWidth)
            
            ZStack {
                Color.black.ignoresSafeArea()
                
                CombinedMazeView(
                    chunks: mazeManager.chunks,
                    cellSize: cellSize,
                    scrollOffset: mazeManager.scrollOffset
                )
                .drawingGroup()
                
                Circle()
                    .fill(Color.red)
                    .frame(width: cellSize * 0.7, height: cellSize * 0.7)
                    .shadow(color: .red.opacity(0.8), radius: 10, x: 0, y: 0)
                    .position(x: geometry.size.width / 4, y: geometry.size.height / 2)
                
                VStack {
                    Spacer()
                    Button(action: {
                        mazeManager.isPlaying ? mazeManager.pause() : mazeManager.play()
                    }) {
                        Image(systemName: mazeManager.isPlaying ? "pause.fill" : "play.fill")
                            .font(.largeTitle)
                            .padding()
                            .background(Color.white.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .padding()
                }
            }
            .foregroundColor(.white)
            .ignoresSafeArea()
            .onAppear {
                mazeManager.play()
            }
        }
    }
}

struct CombinedMazeView: View {
    let chunks: [MazeChunk]
    let cellSize: CGFloat
    let scrollOffset: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let chunkWidth = cellSize * CGFloat(chunks.first?.grid.count ?? 0)
            let chunkHeight = cellSize * CGFloat(chunks.first?.grid[0].count ?? 0)
            
            Canvas { context, size in
                // Draw all chunks in a single canvas
                for (index, chunk) in chunks.enumerated() {
                    let xOffset = scrollOffset + CGFloat(index) * chunkWidth
                    
                    // Draw walls for each cell in this chunk
                    for y in 0..<chunk.grid[0].count {
                        for x in 0..<chunk.grid.count {
                            let cell = chunk.grid[x][y]
                            let cellX = xOffset + CGFloat(x) * cellSize
                            let cellY = CGFloat(y) * cellSize
                            
                            if cell.topWall {
                                context.stroke(Path { path in
                                    path.move(to: CGPoint(x: cellX, y: cellY))
                                    path.addLine(to: CGPoint(x: cellX + cellSize, y: cellY))
                                }, with: .color(.cyan), lineWidth: 2)
                            }
                            if cell.bottomWall {
                                context.stroke(Path { path in
                                    path.move(to: CGPoint(x: cellX, y: cellY + cellSize))
                                    path.addLine(to: CGPoint(x: cellX + cellSize, y: cellY + cellSize))
                                }, with: .color(.cyan), lineWidth: 2)
                            }
                            if cell.leftWall {
                                context.stroke(Path { path in
                                    path.move(to: CGPoint(x: cellX, y: cellY))
                                    path.addLine(to: CGPoint(x: cellX, y: cellY + cellSize))
                                }, with: .color(.cyan), lineWidth: 2)
                            }
                            if cell.rightWall {
                                context.stroke(Path { path in
                                    path.move(to: CGPoint(x: cellX + cellSize, y: cellY))
                                    path.addLine(to: CGPoint(x: cellX + cellSize, y: cellY + cellSize))
                                }, with: .color(.cyan), lineWidth: 2)
                            }
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: chunkHeight)
        }
    }
}

struct CellView: View {
    let cell: MazeCell
    let cellSize: CGFloat
    
    var body: some View {
        ZStack {
            // Using Paths is more performant for drawing lines than stacking Shapes
            Path { path in
                if cell.topWall { path.move(to: .zero); path.addLine(to: .init(x: cellSize, y: 0)) }
                if cell.bottomWall { path.move(to: .init(x: 0, y: cellSize)); path.addLine(to: .init(x: cellSize, y: cellSize)) }
                if cell.leftWall { path.move(to: .zero); path.addLine(to: .init(x: 0, y: cellSize)) }
                if cell.rightWall { path.move(to: .init(x: cellSize, y: 0)); path.addLine(to: .init(x: cellSize, y: cellSize)) }
            }
            .stroke(Color.cyan, lineWidth: 2)
        }
        .frame(width: cellSize, height: cellSize)
    }
}
