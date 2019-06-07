//
//  Island.swift
//  Game_Kursovaya
//
//  Created by Роман Лабунский on 12.05.2019.
//  Copyright © 2019 Роман Лабунский. All rights reserved.
//

import SpriteKit
import GameplayKit

final class Island: SKSpriteNode, GameBackgroundSpriteable {
    
    static func populate(at point: CGPoint?) -> Island {
        let islandImageName = ConfigurateIslandName()
        let island = Island(imageNamed: islandImageName)
        island.setScale(randomScaleFactor)
        island.position = point ?? randomPoint()
        island.zPosition = 1
        island.name = "sprite"
        island.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        island.run(rotateForRandomAngle())
        island.run(move(from: island.position))
        
        return island
    }
    
   fileprivate static func ConfigurateIslandName() -> String{
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 4)
        let randomNumber = CGFloat(distribution.nextInt())
        let imageName = "is" + "\(randomNumber)"
        
        return imageName
    }
    
    fileprivate static var randomScaleFactor: CGFloat {
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 10)
        let randomNumber = CGFloat(distribution.nextInt()) / 10
        
        return randomNumber
    }
    
   fileprivate static func rotateForRandomAngle() -> SKAction{
        let distribution = GKRandomDistribution(lowestValue: 0, highestValue: 360)
        let randomNumber = CGFloat(distribution.nextInt()) / 10
     
        return SKAction.rotate(byAngle: randomNumber * CGFloat(Double.pi / 180), duration: 1)
    }
    
    fileprivate static func move(from point: CGPoint) -> SKAction{
        let movePiont = CGPoint(x: point.x, y: -200)
        let moveDistance = point.y + 200
        let movementSpeed: CGFloat = 100
        let duration = moveDistance / movementSpeed
        
        return SKAction.move(to: movePiont, duration: TimeInterval(duration))
    }
}
