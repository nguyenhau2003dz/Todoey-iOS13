//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nguyễn Đức Hậu on 27/06/2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
       loadCategory()
    }
    
    //MARK: - Table delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    
    //important
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CategoryCell")
        

        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "Not category added yet"
        
        return cell
        
    }
    
    
    
    // MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add categỏy", style: .default){[self] (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            
                        
            
            self.save(category: newCategory)        }
        
        alert.addTextField(){(alertTextField) in
            alertTextField.placeholder = "Input category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    


    //MARK: - Data Manipulation Methods
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error save category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory(){

        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }

    
}
