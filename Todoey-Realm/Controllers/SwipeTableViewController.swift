//
//  SwipeTableViewController.swift
//  Todoey-Realm
//
//  Created by Ramon Seoane Martin on 23/6/23.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
	
	var cell: SwipeTableViewCell?
	
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell

		cell.delegate = self

		return cell
	}
    
	//MARK: - Swipe Cell Delegate Methods
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
		
		guard orientation == .right else { return nil }

		let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [weak self] action, indexPath in
			guard let self else { return }
			// handle action by updating model with deletion
			
			print("Delete Cell")
			
			self.updateModel(at: indexPath)
		}

		// customize the action appearance
		deleteAction.image = UIImage(named: "deleteIcon")

		return [deleteAction]
	}
	
	func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
		
		var options = SwipeTableOptions()
		
		options.expansionStyle = .destructive
		options.transitionStyle = .border
		
		return options
	}
	
	func updateModel(at indexPath: IndexPath) {
		
		// Update our Data Model
		print("Item deleted from superclass")
	}
	

}
