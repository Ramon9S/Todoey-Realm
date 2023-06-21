//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Ramon Seoane Martin on 17/6/23.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

	// File path to the documents folder
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	
	var categoryArray = [Category]()
	
	// Context to interact with the DB's persistent container
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext /// Access AppDelegate singleton
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

		print()
		print(dataFilePath)
		print()
		
		loadCategories()
    }

	//MARK: - Add New Category
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		
		var textField = UITextField()
		let alert = UIAlertController(title: "Add new Todoey Category", message: "", preferredStyle: .alert)
		let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
			
			// Whatever happens once the Add Category buttom on our UIAlert is pressed
			let newCategory = Category(context: self.context)
			newCategory.name = textField.text!
			
			self.categoryArray.append(newCategory) /// add to the Items Array
			
			self.saveCategories()
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
		return categoryArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
		let category = categoryArray[indexPath.row]

		cell.textLabel?.text = category.name
				
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
			
			destinationVC.selectedCategory = categoryArray[indexPath.row]
		}
	}
	
	
	//MARK: - Model Manipulation Methods
	func saveCategories() {
		
		do {
			try context.save()
		} catch {
			print("Error saving context, \(error)")
		}
		
		self.tableView.reloadData()
	}
	
	func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {

		do{
			categoryArray = try context.fetch(request)
		} catch {
			print("Error fetching data from context \(error)")
		}
		
		self.tableView.reloadData()
	}
	
	
	
}
