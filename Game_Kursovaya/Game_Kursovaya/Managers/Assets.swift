//
//  Assets.swift
//  Game_Kursovaya
//
//  Created by Роман Лабунский on 23.05.2019.
//  Copyright © 2019 Роман Лабунский. All rights reserved.
//

import SpriteKit

class Assets: SKSpriteNode {
    static let shared = Assets()
    
    var isLoaded = false
    
    let playerShip = SKTextureAtlas(named: "PlayerShip")
    let greenBlueAtlas = SKTextureAtlas(named: "GreenBlue")
    let enemy_1Atlas = SKTextureAtlas(named: "Enemy_1")
    let enemy_2Atlas = SKTextureAtlas(named: "Enemy_2")
    
 
    func preloadAssets() {
        greenBlueAtlas.preload { print("greenBlueAtlas preloaded") }
        enemy_1Atlas.preload { print("enemy_1Atlas preloaded") }
        enemy_2Atlas.preload { print("enemy_2Atlas preloaded") }
        playerShip.preload { print("playerShip preloaded") }
    }
}
