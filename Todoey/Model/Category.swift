//
//  Item.swift
//  Todoey
//
//  Created by Nguyễn Đức Hậu on 03/07/2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    //relationship
    let items = List<Item>()
}
