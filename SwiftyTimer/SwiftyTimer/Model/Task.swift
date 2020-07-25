//
//  Task.swift
//  SwiftyTimer
//
//  Created by Jiaming Zhou on 5/17/20.
//  Copyright © 2020 Jiaming Zhou. All rights reserved.
//

import Foundation
import RealmSwift

struct Task {
    var state: status
    var timeCreated: Date
    private let realm = try! Realm()
    
    enum status {
        case notStarted
        case ongoing
        case paused
        case completed
    }
    
    mutating func updateState(with state: status) {
        self.state = state
    }
    
    mutating func resetTime() {
        self.timeCreated = Date(timeIntervalSinceNow: 0)
    }
}
