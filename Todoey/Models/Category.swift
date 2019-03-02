//
//  File.swift
//  Todoey
//
//  Created by Mark on 2019/2/26.
//  Copyright © 2019 MarkChen. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String?
    var items = List<Item>()

}
