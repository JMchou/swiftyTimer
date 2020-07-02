//
//  Item.swift
//  SwiftyTimer
//
//  Created by Jiaming Zhou on 6/25/20.
//  Copyright © 2020 Jiaming Zhou. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var name: String?
    @objc dynamic var iconName: String?
    @objc dynamic var duration: Int = 0
    @objc dynamic var color: String?
    @objc dynamic var timeCreated = Date()
    
    convenience init(duration: Int) {
        self.init()
        self.duration = duration
    }
}
