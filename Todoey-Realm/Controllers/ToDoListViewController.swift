//
//  ToDoListViewController.swift
//  Todoey-Realm
//
//  Created by Ramon Seoane Martin on 3/6/23.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
	
	var toDoItems: Results<Item>?
	let realm = try! Realm()
	
	
	var selectedCategory: Category? {
		didSet {
			loadItems()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
	}

	
	//MARK: - TableView DataSource Methods
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	
		return toDoItems?.count ?? 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		
		if let item = toDoItems?[indexPath.row] {
			
			cell.textLabel?.text = item.title
			cell.accessoryType = item.done ? .checkmark : .none /// Ternary Operator ==> VALUE = CONDITION ? VALUETRUE : VALUEFALSE
		} else {
			cell.textLabel?.text = "No Items Added"
			cell.accessoryType = .none
		}

		return cell
	}

	
	//MARK: - TableView Delegate Methods
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if let item = toDoItems?[indexPath.row] {
			
			// U from CRUD in Realm --> similar to C = create = write
			do {
				try realm.write {
					item.done = !item.done
					
					// D from CRUD in Realm --> inside write to update de DB
//					realm.delete(item)
				}
			} catch {
				print("Error updating done status, \(error)")
			}
		}
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		tableView.reloadData()
	}
	
	
	//MARK: - Private Functions
	func updateCheck(_ indexPath: IndexPath) {
		
		if toDoItems?[indexPath.row].done == false {
			tableView.cellForRow(at: indexPath)?.accessoryType = .none
		} else {
			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		}
	}
	
	//MARK: - Add New Items
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			
			if let currentCategory = self.selectedCategory {
				do {
					
					// C from CRUD in Realm
					try self.realm.write {
						
						let newItem = Item()
						newItem.title = textField.text!
						newItem.dateCreated = Date()
						
						currentCategory.items.append(newItem)
					}
				} catch {
					print("Error saving new items, \(error)")
				}
			}
			self.tableView.reloadData()
		}
		
		// Add a textfield to the alert
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField = alertTextField
		}
		
		// Add an action to the alert
		alert.addAction(action)
		
		present(alert,animated: true, completion: nil)
		
	}
	

	//MARK: - Model Manipulation Methods
	
	func loadItems() {

		// R from CRUD in Realm
		toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
		
		self.tableView.reloadData()
	}
}


//MARK: - Search bar methods extension
extension ToDoListViewController: UISearchBarDelegate {

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

		// c: case insensitive, d: diacritic insensitive
		// Query in Realm
		toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
		
		self.tableView.reloadData()
	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

		if searchBar.text?.count == 0 {

			loadItems()

			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
		}
	}

}
