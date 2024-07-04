//
//  Item.swift
//  Todoey
//
//  Created by Nguyễn Đức Hậu on 03/07/2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    //relationship nghic dao
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
