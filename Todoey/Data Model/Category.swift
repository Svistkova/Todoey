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
    //now we need to construct relations between Categories and Items. List - is a Realm container (such as array)
    let items = List<Item>()
}
