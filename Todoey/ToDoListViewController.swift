//
//  ViewController.swift
//  Todoey
//
//  Created by Mark on 2019/2/23.
//  Copyright © 2019 MarkChen. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArrary = [String]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // the delegates are all handled by UITableViewController
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
            itemArrary = items
        } else {
            print("the reloading process is failed")
        }
        
    }

    //MARK: - TableView Datasource Methodes
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArrary.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArrary[indexPath.row]
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)" + ":  \(itemArrary[indexPath.row])")
        
//        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Items", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will hapeen if press the action alert
            
            if let name = textField.text{
                self.itemArrary.append(name)
                self.defaults.set(self.itemArrary, forKey: "ToDoListArray")
                self.tableView.reloadData()
            }else {
                print("the item name is empty")
            }
            
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    
    
}

