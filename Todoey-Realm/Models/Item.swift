//
//  Item.swift
//  Todoey-Realm
//
//  Created by Ramon Seoane Martin on 3/6/23.
//

import Foundation
import RealmSwift

class Item: Object {
	
	@objc dynamic var title: String = ""
	@objc dynamic var done: Bool = false
	@objc dynamic var dateCreated: Date?
	
	// Item -> Category relation definition
	var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}



