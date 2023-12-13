//
//  BorderNode.swift
//  BombME
//
//  Created by Nicola Lauritano on 18/10/23.
//

import UIKit
import SpriteKit

class BorderNode: SKSpriteNode {
    func drawBorder(rectWidth: CGFloat) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -self.frame.width/2 - rectWidth , y: self.frame.height))
        path.addLine(to: CGPoint(x: -self.frame.width/2 - rectWidth, y: -self.frame.height / 2))
        path.addLine(to: CGPoint(x: self.frame.width/2 + rectWidth , y: -self.frame.height / 2))
        path.addLine(to: CGPoint(x: self.frame.width/2 + rectWidth, y:  self.frame.height ))
//        path.move(to: CGPoint(x: self.frame.origin.x - rectWidth/4, y: self.frame.origin.y - rectWidth/4))
//        path.addLine(to: CGPoint(x: self.frame.origin.x - rectWidth/4, y: self.frame.origin.y - rectWidth/4 - self.frame.height - rectWidth/2 ))
//        path.addLine(to: CGPoint(x: self.frame.origin.x - rectWidth/4 - self.frame.width - rectWidth/2, y: self.frame.origin.y - rectWidth/4 - self.frame.height - rectWidth/2 ))
//        path.addLine(to: CGPoint(x: self.frame.origin.x - rectWidth/4 - self.frame.width - rectWidth/2, y: self.frame.origin.y - rectWidth/4 ))
        
        let shapeNode = SKShapeNode(path: path.cgPath)
        shapeNode.fillColor = .clear
        
        
        addChild(shapeNode)
        
        configurePhysicsBody(path: path)
    }
    
    func configurePhysicsBody(path: UIBezierPath) {
        self.physicsBody = SKPhysicsBody(edgeChainFrom: path.cgPath)
        // Imposta le proprietà del corpo fisico se necessario
        self.physicsBody?.isDynamic = false // Per rendere il corpo fisico statico
        
        self.physicsBody?.categoryBitMask = CategoryBitMask.borderCategory
        self.physicsBody?.contactTestBitMask = CategoryBitMask.opponentCategory | CategoryBitMask.playerCategory | CategoryBitMask.opponentBombCategory | CategoryBitMask.playerBombCategory
    }
}
