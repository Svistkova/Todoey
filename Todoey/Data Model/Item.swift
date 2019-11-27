//
//  Item.swift
//  Todoey
//
//  Created by Marina Svistkova on 26.11.2019.
//  Copyright © 2019 Marina Svistkova. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    //нужно создать reverse relations, но это уже делается чуть иначе:
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items") //items - название forward relation
}
