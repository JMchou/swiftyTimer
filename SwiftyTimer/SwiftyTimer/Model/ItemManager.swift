//
//  ItemManager.swift
//  SwiftyTimer
//
//  Created by Jiaming Zhou on 6/25/20.
//  Copyright © 2020 Jiaming Zhou. All rights reserved.
//

import Foundation
import RealmSwift

final class ItemManager {
    private let realm = try! Realm()
    static let standard = ItemManager()
    
    private init() {}
    
    func createItem(name: String, iconName: String, duration: Int, Color: String) {
        let newItem = Item(duration: duration)
        newItem.name = name
        newItem.iconName = iconName
        newItem.color = Color
        
        try! realm.write {
            realm.add(newItem)
        }
    }
    
    func retrieveItems() -> Results<Item> {
        let items = realm.objects(Item.self).sorted(byKeyPath: "timeCreated")
        return items
    }

    func deleteItem(item: Item) {
        try! realm.write{
            realm.delete(item)
        }
    }
    
    func modifyItem(content: () -> Void) {
        try! realm.write{
            content()
        }
    }
}
