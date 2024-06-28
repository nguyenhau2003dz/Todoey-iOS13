//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
   // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory: Category?{
        didSet{
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            loadItems(with: request)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Table delegate method
    
    // tra ve so luong item
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    //tra ve moi item
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
       let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        

        //Ternary operator ==>
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType =  item.done == true ? .checkmark : .none
        
        return cell
        
    }
    
    
    //su kien khi click vao moi item
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        context.delete(itemArray[indexPath.row])
        
        //xoa item
        //itemArray.remove(at: indexPath.row)
        
       itemArray[indexPath.row].done =  !itemArray[indexPath.row].done

        self.saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //MARK: - add items
    // nhan vao nut them item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default){ [self] (action) in
            
                let newItem = Item(context: context)
                newItem.title = textField.text!
                newItem.done = false
            
                newItem.parentCategory = self.selectedCategory
            
                self.itemArray.append(newItem)
            
                self.saveItem()
            
           
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Data Manipulation Methods
    func saveItem(){
        do{
           try context.save()
        }catch{
            print("Error saving context \(context)")
        }
    
        tableView.reloadData()

    }
    
    func loadItems(with request: NSFetchRequest<Item>, predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addtionalPredicate = predicate{
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
            request.predicate = compoundPredicate
        }else{
            request.predicate = categoryPredicate
        }
        
        
        do{
          itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error) ")
        }
            
        tableView.reloadData()
    }
    
    
}

// MARK: - Search bar
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
                
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            loadItems(with: request)
            DispatchQueue.main.async{
                searchBar.resignFirstResponder()

            }
        }
            
    }

}



