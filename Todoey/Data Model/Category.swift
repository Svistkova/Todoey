//
//  Category.swift
//  Todoey
//
//  Created by Marina Svistkova on 26.11.2019.
//  Copyright © 2019 Marina Svistkova. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""

    let items = List<Item>()
}
