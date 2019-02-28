//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mark on 2019/2/26.
//  Copyright © 2019 MarkChen. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    var categoryArray: Results<Category>?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No category added yet"
        
        return cell
    }

    
    //MARK: - Data Manipulate Methods
    
    func storeData(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error as saving data \(error)")
        }
    }
    
    func loadData(){

        categoryArray = realm.objects(Category.self)
        
        
        tableView.reloadData()
    }
    
    //MARK: - Add new Category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var categoryName = UITextField()
        
        let alert = UIAlertController(title: "New Caregory", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "new category name"
            categoryName = textField
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (alert) in
            let newCategory = Category()
            
            newCategory.name = categoryName.text!
            
            self.storeData(category: newCategory)
            self.tableView.reloadData()
        }
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
   
}
