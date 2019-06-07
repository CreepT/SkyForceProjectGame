//
//  Background.swift
//  Game_Kursovaya
//
//  Created by Роман Лабунский on 12.05.2019.
//  Copyright © 2019 Роман Лабунский. All rights reserved.
//

import SpriteKit

class Background: SKSpriteNode {
    
    static func populatedBackground(at point: CGPoint) -> Background{
        
        let background = Background(imageNamed: "background")
        background.position = point
        background.zPosition = 0
        
        return background
    }
}
