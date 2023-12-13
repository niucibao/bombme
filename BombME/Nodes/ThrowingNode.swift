//
//  ThrowingNode.swift
//  BombME
//
//  Created by Nicola Lauritano on 26/09/23.
//

import UIKit
import SpriteKit

class ThrowingNode: SKShapeNode {
    
    var throwings = [SKShapeNode]()
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(startPosition: CGPoint, lastPositionVector: CGVector, scene: SKScene) {
        self.init()
        let maxSize = 7.0
        let minSize = 1.0
        let numberOfDots = 5
        
        for i in 0..<numberOfDots {
            let q = Double(i+1)/Double(numberOfDots)
            let radius = q * (maxSize - minSize) + minSize
            let shape = SKShapeNode(circleOfRadius: radius)
            shape.fillColor = .white
            shape.alpha = 1-q 
//            let curve = Double(alpha) * Double(i+1) * 30.0
            shape.position = CGPoint(x: startPosition.x + (q * -lastPositionVector.dx), y: startPosition.y + (q * -lastPositionVector.dy))
            shape.zPosition = 1
            shape.strokeColor = .clear
            throwings.append(shape)
            scene.addChild(shape)
        }
    }
    
    override func removeFromParent() {
        for element in throwings {
            element.removeFromParent()
        }
        
        super.removeFromParent()
    }
    
//    func calculatePos(pos: CGPoint) -> CGPoint{
////        m = (y - y1) / (x - x1) = (232 - 0) / (145 - 0) = 232/145
//        let m = (pos.y - reference.y) / (pos.x - reference.x)
//        
//        var x = sqrt(pow(100.0,2) / (1.0 + pow(m,2)))
//        var y = m * x
//        
//        if pos.x < reference.x {
//            x = -x
//            y = -y
//        }
//        
//        return CGPoint(x: reference.x + x, y: reference.y + y)
//    }

}
