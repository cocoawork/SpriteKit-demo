//
//  Quirk.swift
//  MonsterWars
//
//  Created by cocoawork on 2017/9/28.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class Quirk: GKEntity {

    init(team: Team) {
        super.init()
        let texture = SKTexture(imageNamed: "quirk\(team.rawValue)")
        let spriteComponent = SpriteComponent(texture: texture)
        self.addComponent(spriteComponent)
        self.addComponent(TeamComponent(team: team))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
