//
//  CategoryTableViewController.swift
//  Todoey-Realm
//
//  Created by Ramon Seoane Martin on 17/6/23.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

	// Should not fail due to previous initialisation of Realm
	let realm = try! Realm()
	
	var categoryArray: Results<Category>?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		loadCategories()
    }

	//MARK: - Add New Category
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		let alert = UIAlertController(title: "Add new Todoey Category", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
			
			// Whatever happens once the Add Category buttom on our UIAlert is pressed
			let newCategory = Category()
			newCategory.name = textField.text!
			
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
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

		cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
				
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
	
	func loadCategories() {

		// R from CRUD in Realm
		categoryArray = realm.objects(Category.self)
		
		self.tableView.reloadData()
	}
	
	
	
}
