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
    let speed: CGFloat = 2.0
    let bufferChunks: Int = 2
    
    private var generator: MazeGenerator
    private var gameTimer: AnyCancellable?
    private var cellSize: CGFloat = 0
    private var chunkWidthInPoints: CGFloat = 0
    private var removingChunk = false
    
    init() {
        self.generator = MazeGenerator(width: chunkWidth, height: chunkHeight)
        self.cellSize = UIScreen.main.bounds.height / CGFloat(chunkHeight)
        self.chunkWidthInPoints = CGFloat(chunkWidth) * cellSize
        setupInitialChunks()
    }
    
    private func setupInitialChunks() {
        var nextEntryY = chunkHeight / 2
        for _ in 0..<(4 + bufferChunks) {
            let newChunk = generator.generateChunk(entryY: nextEntryY)
            chunks.append(newChunk)
            nextEntryY = newChunk.exitY
        }
    }
    
    func play() {
        guard !isPlaying else { return }
        isPlaying = true
        gameTimer = Timer.publish(every: 1/120, on: .main, in: .common)
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
        // Continuous scrolling
        scrollOffset -= speed
        
        // Only manage chunks when we've scrolled far enough
        if abs(scrollOffset) >= chunkWidthInPoints && !removingChunk {
            removingChunk = true
            
            // Calculate exact alignment point for the offset
            let exactChunkWidth = cellSize * CGFloat(chunkWidth)
            let adjustedOffset = scrollOffset + exactChunkWidth
            
            // Perform operations in a transaction for visual consistency
            //            withAnimation(.none)
            //            {
            // Remove first chunk
            
            if !chunks.isEmpty {
                chunks.removeFirst()
                print("(scrollOffset: \(scrollOffset), adjustedOffset: \(adjustedOffset))")
                
                // Add new chunk at the end
                if let lastChunk = chunks.last {
                    let newChunk = generator.generateChunk(entryY: lastChunk.exitY)
                    chunks.append(newChunk)
                }
                
                // Precisely adjust scroll offset
                
                scrollOffset = adjustedOffset
            }
            
            removingChunk = false
            //            }
        }
    }
}
