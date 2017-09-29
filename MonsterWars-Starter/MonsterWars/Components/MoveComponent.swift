//
//  MoveComponent.swift
//  MonsterWars
//
//  Created by cocoawork on 2017/9/29.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class MoveComponent: GKAgent2D {

    let entityManager: EntityManager

    init(speed: Float, acceleration: Float, radius: Float, entityManager: EntityManager) {
        self.entityManager = entityManager
        super.init()
        self.maxSpeed = speed
        self.maxAcceleration = acceleration
        self.radius = radius
        self.delegate = self
        print(self.mass)
        self.mass = 0.01
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension MoveComponent: GKAgentDelegate {
    func agentWillUpdate(_ agent: GKAgent) {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        position = float2(spriteComponent.node.position)
    }


    func agentDidUpdate(_ agent: GKAgent) {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        spriteComponent.node.position = CGPoint(position)
    }
}
