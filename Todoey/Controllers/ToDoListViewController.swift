//
//  ViewController.swift
//  Todoey
//
//  Created by Mark on 2019/2/23.
//  Copyright © 2019 MarkChen. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    // the delegates are all handled by UITableViewController

    
    var itemArrary = [Item]()
    let defaults = UserDefaults.standard
    
    let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reStoreData()
        // problems occur as storing objects to default
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArrary = items
//        } else {
//            print("the reloading process is failed")
//        }
        
    }

    //MARK: - TableView Datasource Methodes
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArrary.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("loading data")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArrary[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
       
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = itemArrary[indexPath.row]
        item.done = !item.done
        
        storeArray()
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()

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
            
            let item = Item()
            
            if let name = textField.text{
                item.title = name
                self.itemArrary.append(item)
            }else {
                print("the item name is empty")
            }
            
            self.storeArray()
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    //MARK: - store and restore Data
    func storeArray(){
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArrary)
            try data.write(to: self.dataPath!)
        } catch {
            print("Something is wrong as storing array  \(error)")
        }
    }
    func reStoreData(){
        if let data = try? Data(contentsOf: dataPath!) {
            do{
                let decoder = PropertyListDecoder()
                try itemArrary = decoder.decode([Item].self, from: data)
            } catch {
                print(error)
            }
        }
    }
}

