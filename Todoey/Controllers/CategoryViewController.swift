//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mark on 2019/2/26.
//  Copyright © 2019 MarkChen. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
       
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    
    //MARK: - Data Manipulate Methods
    
    func storeData(){
        do{
            try context.save()
        } catch {
            print("Error as saving data \(error)")
        }
    }
    
    func loadData(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            categoryArray =  try context.fetch(request)
            
        }catch{
            print("Error as loading data \(error)")
        }
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
            let category = Category(context: self.context)
            
            category.name = categoryName.text
            
            self.categoryArray.append(category)
            self.storeData()
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
   
}
