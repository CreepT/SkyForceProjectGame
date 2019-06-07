//
//  GreenShot.swift
//  Game_Kursovaya
//
//  Created by Роман Лабунский on 20.05.2019.
//  Copyright © 2019 Роман Лабунский. All rights reserved.
//

import SpriteKit

class GreenShot: Shot {

    init() {
        let textureAtlas = Assets.shared.greenBlueAtlas //SKTextureAtlas(named: "GreenBlue")
        super.init(textureAtlas: textureAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
