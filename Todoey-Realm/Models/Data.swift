//
//  Data.swift
//  Todoey-Realm
//
//  Created by Ramon Seoane Martin on 21/6/23.
//

import Foundation
import RealmSwift

class Data: Object {
	@objc dynamic var name: String = ""
	@objc dynamic var age: Int = 0
}
