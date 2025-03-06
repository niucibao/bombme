//
//  GameOverNode.swift
//  BombME
//
//  Created by Nicola Lauritano on 19/07/24.
//

import Foundation
import SpriteKit

class GameOverNode: SKSpriteNode {
    
    func setup(finalScore: Int) {
        self.alpha = 0
        
        let labelText = SKLabelNode()
        labelText.fontColor = .white
        labelText.fontName = "menlo-Bold"
        labelText.fontSize = 225
        labelText.position = CGPoint(x: 0, y: 0)
        labelText.zPosition = 99
        labelText.text = "GAME OVER"
        self.addChild(labelText)
        
        let scoreText = SKLabelNode()
        scoreText.fontColor = .white
        scoreText.fontName = "menlo-Bold"
        scoreText.fontSize = 125
        scoreText.position = CGPoint(x: 0, y: -125)
        scoreText.zPosition = 99
        scoreText.text = "YOUR SCORE: \(finalScore)"
        self.addChild(scoreText)
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: 0.4), SKAction.fadeAlpha(to: 0.5, duration: 4.5)]) )
    }
}
