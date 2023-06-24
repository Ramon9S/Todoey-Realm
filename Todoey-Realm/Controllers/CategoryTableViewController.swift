//
//  CategoryTableViewController.swift
//  Todoey-Realm
//
//  Created by Ramon Seoane Martin on 17/6/23.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
	
	// Should not fail due to previous initialisation of Realm
	let realm = try! Realm()
	
	var categoryArray: Results<Category>?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		
		loadCategories()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
		guard let navBar = navigationController?.navigationBar else { fatalError("Navigation Controller does not exist.") }

		let originalColour = UIColor(hexString: "1D9BF6")
		let contrastColour = ContrastColorOf(originalColour!, returnFlat: true)
		
		navBar.backgroundColor = originalColour
		navBar.tintColor = contrastColour
		navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : contrastColour]
		
	}
	
	
	//MARK: - Private Functions
	func setupUI() {
		
		tableView.rowHeight = 80
		tableView.separatorStyle = .none
	}
	
	
	//MARK: - Add New Category
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		let alert = UIAlertController(title: "Add new Todoey Category", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
			
			// Whatever happens once the Add Category buttom on our UIAlert is pressed
			let newCategory = Category()
			newCategory.name = textField.text!
			newCategory.color = UIColor.randomFlat().hexValue()
			
			self.saveCategories(category: newCategory)
		}
		
		// Add a textfield to the alert
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new category"
			textField = alertTextField
		}
		
		// Add an action to the alert
		alert.addAction(action)
		
		present(alert,animated: true, completion: nil)
	}
	
	
	//MARK: - TableView DataSource Methods
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return categoryArray?.count ?? 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		
		if let category = categoryArray?[indexPath.row] {
			
			cell.textLabel?.text = category.name
			
			guard let categoryColor = UIColor(hexString: category.color) else { fatalError() }
			
			cell.backgroundColor = categoryColor
			
			cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
		}
		
		return cell
	}
	
	
	//MARK: - TableView Delegate Methods
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		performSegue(withIdentifier: "goToItems", sender: self)
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		let destinationVC = segue.destination as! ToDoListViewController
		
		if let indexPath = tableView.indexPathForSelectedRow {
			
			destinationVC.selectedCategory = categoryArray?[indexPath.row]
		}
	}
	
	
	//MARK: - Model Manipulation Methods
	
	//MARK: - Save Category Data To Realm DB
	func saveCategories(category: Category) {
		
		// C from CRUD in Realm
		do {
			try realm.write {
				realm.add(category)
			}
		} catch {
			print("Error saving category, \(error)")
		}
		
		self.tableView.reloadData()
	}
	
	//MARK: - Load Category Data From Realm DB
	func loadCategories() {
		
		// R from CRUD in Realm
		categoryArray = realm.objects(Category.self)
		
		self.tableView.reloadData()
	}
	
	//MARK: - Delete Category Data From Swipe
	override func updateModel(at indexPath: IndexPath) {
		
		super.updateModel(at: indexPath) // If needed for superclass code execution
		
		if let category = self.categoryArray?[indexPath.row] {
			
			// U from CRUD in Realm --> similar to C = create = write
			do {
				try self.realm.write {
					
					// First we delete the items of this category, then the category itself
					if let items = self.categoryArray?[indexPath.row].items {
						
						items.forEach { item in
							self.realm.delete(item)
						}
						
						// Finally we delete the category ==> D from CRUD in Realm --> inside write to update de DB
						self.realm.delete(category)
					}
				}
			} catch {
				print("Error deleting category, \(error)")
			}
		}
	}
}
