//
//  TeamComponent.swift
//  MonsterWars
//
//  Created by cocoawork on 2017/9/27.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


enum Team: Int {
    case team1 = 1
    case team2 = 2

    static let allValues = [team1, team2]

    func oppositeTeam() -> Team {
        switch self {
        case .team1:
            return .team2
        case .team2:
            return .team1
        }
    }

}



class TeamComponent: GKComponent {
    var team: Team
    init(team: Team) {
        self.team = team
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
