//
//  ThrowingNode.swift
//  BombME
//
//  Created by Nicola Lauritano on 26/09/23.
//

import UIKit
import SpriteKit

class CursorNode: SKShapeNode {
    
    var centerNode: SKShapeNode!
    var pinningNode: SKShapeNode!
    var distanceNode: SKShapeNode!
    
    var reference: CGPoint!
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(atPoint reference: CGPoint, scene: SKScene) {
        self.init()
        self.reference = reference
        
        self.centerNode = SKShapeNode(circleOfRadius: 2)
        self.centerNode.position = reference
        self.centerNode.fillColor = .white
        self.centerNode.zPosition = 3
        self.centerNode.strokeColor = .clear
        scene.addChild(self.centerNode)
        
        self.pinningNode = SKShapeNode(circleOfRadius: 20)
        self.pinningNode.position = reference
        self.pinningNode.fillColor = .lightGray
        self.pinningNode.zPosition = 2
        self.pinningNode.strokeColor = .clear
        scene.addChild(pinningNode)
        
        self.distanceNode = SKShapeNode(circleOfRadius: 100)
        self.distanceNode.position = reference
        self.distanceNode.fillColor = .lightGray
        self.distanceNode.alpha = 0.4
        self.distanceNode.zPosition = 4
        self.distanceNode.strokeColor = .clear
        scene.addChild(distanceNode)
    }
    
    func moveTo(point: CGPoint) {
        let distance = sqrt(pow(point.x - reference.x,2) + pow(point.y - reference.y,2))
        self.pinningNode.position = distance > 100 ? calculatePos(pos: point) : point
    }
    
    override func removeFromParent() {
        centerNode.removeFromParent()
        pinningNode.removeFromParent()
        distanceNode.removeFromParent()
    }
    
    func calculatePos(pos: CGPoint) -> CGPoint{
//        m = (y - y1) / (x - x1) = (232 - 0) / (145 - 0) = 232/145
        let m = (pos.y - reference.y) / (pos.x - reference.x)
        
        var x = sqrt(pow(100.0,2) / (1.0 + pow(m,2)))
        var y = m * x
        
        if pos.x < reference.x {
            x = -x
            y = -y
        }
        
        return CGPoint(x: reference.x + x, y: reference.y + y)
    }
    
    func getVector() -> CGVector {
        let x = pinningNode.position.x - centerNode.position.x
        let y = pinningNode.position.y - centerNode.position.y
        
        return CGVector(dx: x, dy: y)
    }
    
    func getImpulse() -> CGVector {
        let vector = getVector()
        return CGVector(dx: -vector.dx / 20.0, dy: -vector.dy / 20.0)
    }

}
