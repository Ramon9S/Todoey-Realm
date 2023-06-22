//
//  Category.swift
//  Todoey-Realm
//
//  Created by Ramon Seoane Martin on 22/6/23.
//

import Foundation
import RealmSwift

class Category: Object {
	
	@objc dynamic var name: String = ""
	
	// Category -> Item to-many relation definition
	let items = List<Item>()
}

