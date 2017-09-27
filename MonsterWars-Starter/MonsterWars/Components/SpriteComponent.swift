//
//  SpriteComponent.swift
//  MonsterWars
//
//  Created by cocoawork on 2017/9/27.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import SpriteKit
import GameplayKit


class SpriteComponent: GKComponent {

    let node: SKSpriteNode


    init(texture: SKTexture) {
        node = SKSpriteNode(texture: texture, color: UIColor.white, size: texture.size())
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }




}
