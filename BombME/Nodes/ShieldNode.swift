//
//  ShieldNode.swift
//  BombME
//
//  Created by Nicola Lauritano on 19/07/24.
//

import Foundation
import SpriteKit

class ShieldNode: SKSpriteNode {
    
    var currentImage: UIImage!
    
    func setup() {
        self.currentImage = UIImage(named: "SHIELD")
        
        texture = SKTexture(image: currentImage)
        configurePhysics()
    }
    
    func appearOnScene(scene: SKScene, playerNode: PlayerNode) {
        let positionX = playerNode.positionInScene.x + playerNode.frame.size.width * 0.5
        let positionY = playerNode.positionInScene.y + playerNode.frame.size.height * 0.5

        self.position = CGPoint(x: positionX, y: positionY)
        self.zPosition = 19
        
        playerNode.addChild(self)
    }
    
    func configurePhysics() {
        self.physicsBody = createCircularBorderPhysicsBody(radius: self.size.width/2)
        self.physicsBody?.isDynamic = false
//        self.scene?.anchorPoint = CGPoint(x: 0, y: -1)
        self.physicsBody?.categoryBitMask = CategoryBitMask.shieldCategory
        self.physicsBody?.collisionBitMask = CategoryBitMask.opponentBombCategory
        self.physicsBody?.contactTestBitMask = CategoryBitMask.opponentBombCategory
    }
    
    func createCircularBorderPhysicsBody(radius: CGFloat) -> SKPhysicsBody {
        // Crea un percorso circolare con UIBezierPath
        let circularPath = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        // Crea il corpo fisico utilizzando il percorso
        let physicsBody = SKPhysicsBody(edgeLoopFrom: circularPath.cgPath)
        
        return physicsBody
    }

    
    func pertosa() {
//        self.removeFromParent()
        self.alpha -= 0.35
        let actualAlpha = self.alpha
        
        blink(actualAlpha: actualAlpha)
        
        if self.alpha <= 0.0 {
            self.physicsBody = nil
        }
        
    }
    
    func blink(actualAlpha: Double) {
        let vibrationDistance: CGFloat = 5.0
        let vibrationDuration: TimeInterval = 0.2
        let vibrationFrequency: Int = 10
        let singleVibrationDuration = vibrationDuration / TimeInterval(vibrationFrequency)
        
        var vibrationActions: [SKAction] = []
        
        for _ in 0..<vibrationFrequency {
            let randomX = CGFloat.random(in: -1...1)
            let randomY = CGFloat.random(in: -1...1)
            let moveUp = SKAction.moveBy(x: vibrationDistance * randomX,
                                         y: vibrationDistance * randomY,
                                         duration: singleVibrationDuration / 2)
            let moveDown = SKAction.moveBy(x: vibrationDistance * -randomX,
                                           y: vibrationDistance * -randomY,
                                           duration: singleVibrationDuration / 2)
            vibrationActions.append(moveUp)
            vibrationActions.append(moveDown)
        }
        
        // Crea una sequenza di vibrazione
        let vibrationSequence = SKAction.sequence(vibrationActions)
        let vibrationAction = SKAction.repeat(vibrationSequence, count: 1)
        
        
        let fadeOut = SKAction.fadeAlpha(to: 0.1, duration: 0.1)
        let fadeIn = SKAction.fadeAlpha(to: actualAlpha, duration: 0.1)
        
        // Crea l'azione di blink
        let blink = SKAction.sequence([fadeOut, fadeIn])
        let repeatBlink = SKAction.repeat(blink, count: 3)
        
        let finalAction = SKAction.sequence([vibrationAction, repeatBlink])
        self.run(finalAction)
        
    }
    
}
