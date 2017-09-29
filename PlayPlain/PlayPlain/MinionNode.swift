//
//  MinionNode.swift
//  PlayPlain
//
//  Created by cocoawork on 2017/9/29.
//  Copyright © 2017年 cocoawork. All rights reserved.
//

import UIKit
import SpriteKit

class MinionNode: SKSpriteNode {
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = 2
        self.physicsBody?.contactTestBitMask = 1
        self.name = "minionNode"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
