//
//  ViewController.swift
//  Todoey
//
//  Created by Marina Svistkova on 08/10/2019.
//  Copyright © 2019 Marina Svistkova. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    
    //переменная из CategoryViewController
    var selectedCategory: Category? {
        didSet {
            //все, что внутри didSet, начнет работать как только у selectedCaregory появится значение
            loadItems()  // Obtain the data from database (so, all the updates are preserved)
        }
    }
    //нужно обратиться к контейнеру, который находится в файле AppDelrgate.Просто так это сделать не получится, поэтому используем синглтон shared, который дает доступ к файлам всего приложения
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // тут мы получаем доступ к Persistent Store's contents

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        
    }
    
//MARK: - TableView DataSourse Methods

    // creates the number of lines in list
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
}
// gives a text to the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // use ternary operator
        // value = condition ? ValueIfTrue : ValueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
// Удаление элементов из списка. Тут важно соблюдать очередность.
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //creating alert window
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //create buttons in alert window below
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //теперь указывает новому файлу ссылку на контейнер, в котором новый файл будет храниться
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            // указатель того, к какой категории todoey относится этот элемент
            newItem.parentCategory = self.selectedCategory
            //what will happen once the user clicks the Add Item button on our UIAlert
            self.itemArray.append(newItem)
           
            self.saveItems()
            
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

// tis save the data to the core data
func saveItems() {

    do {
        //это сохраняет данные в постоянной БД
       try context.save()
    } catch {
        print("Error saving context, \(error)")
    }
    
    tableView.reloadData()
}
    
    //this method loads the saved files form core data
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) { // последнее (после =) - это значение по умолчанию (default value)
        //чтобы загружались только те Items, которые относятся к выбранной Категории
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
       
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        
        do {
        itemArray = try context.fetch(request)
        } catch {
            print ("Error fetching data from context \(error)")
        }
            tableView.reloadData()
    }

}


// MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //сортировка результатов in alphabetic order. sortDescriptor это array, поэтому из него вычленяем отдельный элемент
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
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

