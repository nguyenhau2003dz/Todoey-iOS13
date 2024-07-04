//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
class TodoListViewController: UITableViewController {
    
    var toDoItems: Results<Item>?
  
    let realm = try! Realm()
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Table delegate method
    
    // tra ve so luong item
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }

    //tra ve moi item
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
       let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        
        if let item = toDoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            //Ternary operator ==>
            //value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType =  item.done == true ? .checkmark : .none

        }else{
            cell.textLabel?.text = "No Items added"
        }
                

        
        return cell
        
    }
    
    
    //su kien khi click vao moi item
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row]{
            do{
                
                try realm.write {
                    //update
                    item.done = !item.done
                    
                    //delete
                   // realm.delete(item)
                }
            
            }catch{
                print("Error saving done status\(error)")
            }
        }
        
        tableView.reloadData()
    }
    
    
    
    //MARK: - add items
    // nhan vao nut them item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default){ [self] (action) in
            
            
            if let currentCategory = self.selectedCategory{
                do{
                    
                    //create
                    try realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                    
                }catch{
                        print("Error saving new item, \(error)")
                }

            }
            
            self.tableView.reloadData()
               
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Data Manipulation Methods
    
    func loadItems(){
        
        //read
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
            
        tableView.reloadData()
    }
    
    
}

 //MARK: - Search bar
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
        loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
            
    }

}



