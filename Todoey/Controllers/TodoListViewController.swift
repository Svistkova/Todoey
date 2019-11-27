//
//  ViewController.swift
//  Todoey
//
//  Created by Marina Svistkova on 08/10/2019.
//  Copyright © 2019 Marina Svistkova. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    //переменная из CategoryViewController
    var selectedCategory: Category? {
        didSet {
            //все, что внутри didSet, начнет работать как только у selectedCaregory появится значение
              loadItems()  // Obtain the data from database (so, all the updates are preserved)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }
    
//MARK: - TableView DataSourse Methods

    // creates the number of lines in list
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
}
// gives a text to the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            // use ternary operator
            // value = condition ? ValueIfTrue : ValueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Update in CRUD. If we tap into the ite, it puts on/off the check mark
        if let item = todoItems?[indexPath.row] {
            do{
             try realm.write {
                // Delete in CRUD
//                realm.delete(item)
                item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
     

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //creating alert window
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //create buttons in alert window below
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            

             // указатель того, к какой категории todoey относится этот элемент
            if let currentCtegory = self.selectedCategory {
                // this save the data to the core data
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    //every new instance that we create is assigned by the current date and time
                    newItem.dateCreated = Date()
                    //what will happen once the user clicks the Add Item button on our UIAlert
                    currentCtegory.items.append(newItem)
                      }
                    } catch {
                    print("Error saving item \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        // create the textfield in window so the user can type a new Item
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        // add action to alert
        alert.addAction(action)
        
        // make alert to show up
        present(alert, animated: true, completion: nil)
    }

//MARK: - Model manipulation methods

    //this method loads the saved files form core data
    
    func loadItems() {
        //чтобы загружались только те Items, которые относятся к выбранной Категории
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//
//        do {
//        itemArray = try context.fetch(request)
//        } catch {
//            print ("Error fetching data from context \(error)")
//        }
            tableView.reloadData()
    }

}


// MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true) //сортировка результатов in alphabetic order/ creation date
        
        tableView.reloadData()
    }
    
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        //сортировка результатов in alphabetic order. sortDescriptor это array, поэтому из него вычленяем отдельный элемент
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

                //убираем этот процесс в бэкграунд
            DispatchQueue.main.async {
                //убираем клаву и мигающий курсор
                searchBar.resignFirstResponder()
            }
        }
    }
}

