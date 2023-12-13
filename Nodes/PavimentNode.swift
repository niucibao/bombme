//
//  Paviment.swift
//  BombME
//
//  Created by Nicola Lauritano on 26/09/23.
//

import UIKit
import CoreGraphics
import SpriteKit

class PavimentNode: SKSpriteNode {
    
    var currentImage: UIImage!
    
    func setup() {
        self.currentImage = self.drawBuilding(size: size)
        
//        let random = Int.random(in: 0...7)
//        self.strokeColor = random < 2 ? .white : .black
//        self.zPosition = random < 2 ? +1 : -1
        texture = SKTexture(image: currentImage)
        configurePhysics()
    }
    
    func configurePhysics() {
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: size)
        self.physicsBody?.isDynamic = false
//        self.scene?.anchorPoint = CGPoint(x: 0, y: -1)
        self.physicsBody?.collisionBitMask = CategoryBitMask.playerCategory | CategoryBitMask.playerBombCategory | CategoryBitMask.opponentCategory
        self.physicsBody?.categoryBitMask = CategoryBitMask.floorCategory
        self.physicsBody?.contactTestBitMask = CategoryBitMask.playerCategory | CategoryBitMask.playerBombCategory | CategoryBitMask.opponentCategory
    }
    
    func appearOnSceneWithRandomAnimation(duration: CGFloat, scene: SKScene) {
        switch Int.random(in: 0...1) {
        case 0:
            self.position.y = scene.size.height / 2 + self.size.height / 2
            self.run(SKAction.move(to: CGPoint(x: self.position.x, y: -(scene.size.height / 2 ) + self.size.height / 2), duration: duration))
        case 1:
            self.position.y = -(scene.size.height / 2 + self.size.height / 2)
            self.run(SKAction.move(to: CGPoint(x: self.position.x, y: -(scene.size.height / 2 ) + self.size.height / 2), duration: duration))
        case 2:
            self.setScale(1.7)
            self.run(SKAction.scale(to: 1, duration: duration))
        case 3:
            self.setScale(0.8)
            self.run(SKAction.scale(to: 1, duration: duration))
        default:
            print("HOW DARE?!")
        }
        
        scene.addChild(self)
    
    }
    
    func drawBuilding(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(origin: .zero, size: size)
            let color = UIColor.black
            
            color.setFill()
            
            ctx.cgContext.addRect(rectangle)
//            ctx.fill(rectangle)
            ctx.cgContext.drawPath(using: .fill)
        }
        
        return img
        
    }
    
    func disappearFromSceneWithRandomAnumation(duration: CGFloat) {
        
        let fadeAction = SKAction.fadeOut(withDuration: duration)
        var action: SKAction!
        switch Int.random(in: 0...2) {
        case 0:
            action = SKAction.group([fadeAction, SKAction.changeVolume(to: 1.5, duration: duration)])
        case 1:
            action = SKAction.group([fadeAction, SKAction.changeVolume(to: 0.5, duration: duration)])
        case 2:
            action = fadeAction
        default:
            print("HOW DARE?!")
        }
        
        
        self.run(action) {
            self.removeFromParent()
        }
        
    }
    
    func pertosa(at point: CGPoint) {
        let convertedPoint = CGPoint(x: point.x + size.width/2, y: abs(point.y - (size.height / 2)))
        
        let render = UIGraphicsImageRenderer(size: self.size)
        let img = render.image { ctx in
            currentImage.draw(at: .zero)
            
            ctx.cgContext.addEllipse(in: CGRect(x: convertedPoint.x - 25, y: convertedPoint.y - 25, width: 50, height: 50))
            ctx.cgContext.setBlendMode(.clear)
            ctx.cgContext.drawPath(using: .fill)
        }
        
        texture = SKTexture(image: img)
        currentImage = img
        configurePhysics()
        
    }

}
