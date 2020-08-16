//
//  BGTask.swift
//  SwiftyTimer
//
//  Created by Jiaming Zhou on 7/24/20.
//  Copyright © 2020 Jiaming Zhou. All rights reserved.
//

import Foundation
import RealmSwift

class BGTask: Object {
    @objc dynamic var BGTaskID = UUID().uuidString
    @objc dynamic var activity: Item?
    @objc dynamic var timeTaskCreated = Date()
    @objc dynamic var timeRemaining = 0
    @objc dynamic var notificationID: String = ""
    
    override class func primaryKey() -> String? {
        return "BGTaskID"
    }
}
