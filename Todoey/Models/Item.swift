//
//  Item.swift
//  Todoey
//
//  Created by Mark on 2019/2/26.
//  Copyright © 2019 MarkChen. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var createdDate: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")

}
