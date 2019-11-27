//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Marina Svistkova on 25.11.2019.
//  Copyright © 2019 Marina Svistkova. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
// инициализируем релм object
    let realm = try! Realm()
    
    var categories: Results<Category>?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 // means 'if categories is not nil, return categories.count BUT if it is, then return 1'. ?? nil coalesing operator
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
    }
  
    
    //MARK: - TableView Delegate Metods
    
    // if we tap the category, it will leat to the tableview with items
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self )
    }
    
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        //grab the category that corresponds to the selected cell
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    
    //MARK: - Add New Categories

    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
  //          self.categories.append(newCategory) - это нам не нужно, тип Results is autoupdating
            self.save(category: newCategory)
        }
        
        alert.addTextField { (field) in
            field.placeholder = "Create a new category"
            textField = field
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Methods - Save Data and Load Data
    // Create in CRUD
    func save (category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving  category \(error)")
        }
        
        tableView.reloadData()
    }
  
    // Read in CRUD
    func loadCategories() {
        //проперти categories идет в релм и вытаскивает оттуда objects, которые belong to Category data type
        categories = realm.objects(Category.self)
        
        //после этого мы подгружаем новые данные на tableview
        tableView.reloadData()
        
    }
    
    
}
