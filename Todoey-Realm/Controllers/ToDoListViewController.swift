//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Ramon Seoane Martin on 3/6/23.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
	
	var itemArray = [Item]()
	
	var selectedCategory: Category? {
		didSet {
			loadItems()
		}
	}
	
	// Context to interact with the DB's persistent container 
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext /// Access to the AppDelegate's persisteng storage singleton
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
	}

	
	//MARK: - TableView DataSource Methods
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		let item = itemArray[indexPath.row]

		cell.textLabel?.text = item.title
		cell.accessoryType = item.done ? .checkmark : .none /// Ternary Operator ==> VALUE = CONDITION ? VALUETRUE : VALUEFALSE
				
		return cell
	}

	
	//MARK: - TableView Delegate Methods
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("Fila de la celda seleccionada: \(indexPath.row)")
		print("Elemento de la celda seleccionada: \(itemArray[indexPath.row].title!)")
		print()
		
		itemArray[indexPath.row].done = !itemArray[indexPath.row].done
		
		// First we delete from the context, then from the array
//		context.delete(itemArray[indexPath.row])
//		itemArray.remove(at: indexPath.row)
		
		self.saveItems()
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	
	//MARK: - Private Functions
	func updateCheck(_ indexPath: IndexPath) {
		
		if itemArray[indexPath.row].done == false {
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
			
			// Whatever happens once the Add Item buttom on our UIAlert is pressed
//			let newItem = Item()
			
			let newItem = Item(context: self.context)
			newItem.title = textField.text!
			newItem.done = false
			newItem.parentCategory = self.selectedCategory /// We have this property available because of the defined relations in the DataModel
			
			self.itemArray.append(newItem) /// add to the Items Array
			
			self.saveItems()
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
	func saveItems() {
//		let encoder = PropertyListEncoder()
		
		do {
//			let data = try encoder.encode(itemArray)
//			try data.write(to: dataFilePath!)
			
			try context.save()
		} catch {
//			print("Error encoding item array, \(error)")
			print("Error saving context, \(error)")
		}
		
		self.tableView.reloadData()
	}
	
	func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

		// 1 - Request --> THIS TIME WE ATE PASSING IT AS A PARAMETER + AN OPTIONAL PREDICATE

		// 2 - Predicate for the query ==> PARENTCATEGORY.NAME == TODOLISTVC.SELECTEDCATEGORY
		let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
		
		// 3 - Adding an extra predicate with NSCOMPOUNDPREDICATE with the optional predicate parameter
		if let additionalPredicate = predicate {
			request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
		} else {
			request.predicate = categoryPredicate
		}
		
		// 4 - Fetch the data using the context
		do{
			itemArray = try context.fetch(request)
		} catch {
			print("Error fetching data from context \(error)")
		}
		
		self.tableView.reloadData()
		
		/// Plist version of the storage
//		if let data = try? Data(contentsOf: dataFilePath!) {
//			let decoder = PropertyListDecoder()
//			do {
//				itemArray = try decoder.decode([Item].self, from: data)
//			} catch {
//				print("Error encoding item array, \(error)")
//			}
//		}
	}
	
}


//MARK: - Search bar methods extension
extension ToDoListViewController: UISearchBarDelegate {
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		// 1 - Request
		let request: NSFetchRequest<Item> = Item.fetchRequest()
		
		// 2 - Predicate for the query ==> c: case insensitive, d: diacritic insensitive
		let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
		
		// 3 - Sort Descriptor
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		
		// 4 - Fetch the data with the loadItems func
		loadItems(with: request, predicate: predicate)
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
