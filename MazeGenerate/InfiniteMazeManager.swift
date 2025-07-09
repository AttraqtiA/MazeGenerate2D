//
//  InfiniteMazeManager.swift
//  MazeGenerate
//
//  Created by Samuel Miracle Kristanto on 09/07/25.
//

import SwiftUI
import Combine

class InfiniteMazeManager: ObservableObject {
    // Game State
    @Published var chunks: [MazeChunk] = []
    @Published var scrollOffset: CGFloat = 0
    @Published var isPlaying: Bool = false
    
    // Configuration
    let chunkWidth: Int = 8
    let chunkHeight: Int = 8
    let speed: CGFloat = 1.0
    
    private var generator: MazeGenerator
    private var gameTimer: AnyCancellable?
    
    init() {
        self.generator = MazeGenerator(width: chunkWidth, height: chunkHeight)
        setupInitialChunks()
    }
    
    private func setupInitialChunks() {
        var nextEntryY = chunkHeight / 2
        for _ in 0..<4 {
            let newChunk = generator.generateChunk(entryY: nextEntryY)
            chunks.append(newChunk)
            nextEntryY = newChunk.exitY
        }
    }
    
    func play() {
        guard !isPlaying else { return }
        isPlaying = true
        gameTimer = Timer.publish(every: 1/60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.update()
            }
    }
    
    func pause() {
        isPlaying = false
        gameTimer?.cancel()
    }
    
    private func update() {
        scrollOffset -= speed
        
        let cellSize = UIScreen.main.bounds.height / CGFloat(chunkHeight)
        let firstChunkWidthInPoints = CGFloat(chunkWidth) * cellSize
        
        if abs(scrollOffset) >= firstChunkWidthInPoints {
            chunks.removeFirst()
            
            if let lastChunk = chunks.last {
                let newChunk = generator.generateChunk(entryY: lastChunk.exitY)
                chunks.append(newChunk)
            }
            
            scrollOffset += firstChunkWidthInPoints
        }
    }
}
