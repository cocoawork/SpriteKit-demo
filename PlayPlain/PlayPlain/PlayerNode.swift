//
//  PlayerNode.swift
//  PlayPlain
//
//  Created by cocoawork on 2017/9/29.
//  Copyright © 2017年 cocoawork. All rights reserved.
//

import UIKit
import SpriteKit


class PlayerNode: SKSpriteNode {

    var HP = 100

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func moveTo(location point: CGPoint) {
        let action = SKAction.move(to: point, duration: 0.1)
        self.run(action)
    }

}
