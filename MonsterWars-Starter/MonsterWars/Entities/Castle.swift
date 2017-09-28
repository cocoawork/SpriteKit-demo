//
//  Castle.swift
//  MonsterWars
//
//  Created by cocoawork on 2017/9/27.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import SpriteKit
import GameplayKit


class Castle: GKEntity {


    init(imageNamed: String, team: Team) {
        super.init()
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageNamed))
        self.addComponent(spriteComponent)

        let teamComponent = TeamComponent(team: team)
        self.addComponent(teamComponent)

        let castleComponent = CastleComponent()
        self.addComponent(castleComponent)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
