//
//  PlayerSpaceShip.swift
//  Game_Kursovaya
//
//  Created by Роман Лабунский on 13.05.2019.
//  Copyright © 2019 Роман Лабунский. All rights reserved.
//

import SpriteKit
import CoreMotion

class PlayerSpaceShip: SKSpriteNode {
    
    var motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0
    let screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

    static func populate(at point: CGPoint) -> PlayerSpaceShip {
        let playerShipTexture = Assets.shared.playerShip.textureNamed("playerShip1_red")
        let playerShip = PlayerSpaceShip(texture: playerShipTexture)
        playerShip.setScale(0.5)
        playerShip.position = point
        playerShip.zPosition = 5
        
        // обработка физического прикосновения
        playerShip.physicsBody = SKPhysicsBody(texture: playerShipTexture, alphaThreshold: 0.5, size: playerShip.size)
        playerShip.physicsBody?.isDynamic = false
        playerShip.physicsBody?.categoryBitMask = BitMaskCategory.player.rawValue
        playerShip.physicsBody?.collisionBitMask = BitMaskCategory.enemy.rawValue | BitMaskCategory.powerUp.rawValue
        playerShip.physicsBody?.contactTestBitMask = BitMaskCategory.enemy.rawValue | BitMaskCategory.powerUp.rawValue
        
        
        return playerShip
    }
    
    
    func checkXPosition() {
        // управление лайнером
        self.position.x += xAcceleration * 50
        
        if self.position.x < -30{
            self.position.x = screenSize.width + 30
        } else if self.position.x > screenSize.width + 30{
            self.position.x = -30
        }
    }
    
    func performeFly() {
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let data = data {
                let acceleration = data.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.7 + self.xAcceleration * 0.3
            }
        }
    }
}
