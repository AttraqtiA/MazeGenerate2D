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
            
            ZStack {
                Color.black.ignoresSafeArea()
                
                HStack(spacing: 0) {
                    ForEach(mazeManager.chunks) { chunk in
                        MazeChunkView(chunk: chunk, cellSize: cellSize)
                    }
                }
                .offset(x: mazeManager.scrollOffset)
                
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
            // This prevents the animation from stuttering when a chunk is added/removed
            .animation(.linear(duration: 1/60), value: mazeManager.scrollOffset)
        }
    }
}

struct MazeChunkView: View {
    let chunk: MazeChunk
    let cellSize: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<chunk.grid[0].count, id: \.self) { y in
                HStack(spacing: 0) {
                    ForEach(0..<chunk.grid.count, id: \.self) { x in
                        CellView(cell: chunk.grid[x][y], cellSize: cellSize)
                    }
                }
            }
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
