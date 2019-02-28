//
//  ViewController.swift
//  Todoey
//
//  Created by Mark on 2019/2/23.
//  Copyright © 2019 MarkChen. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    // the delegates are all handled by UITableViewController

    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var todoItem: Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - TableView Datasource Methodes
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItem?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItem?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else{
            cell.textLabel?.text = "No item added"
        }
        
      
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItem?[indexPath.row] {
            do{
                try realm.write {
//                    realm.delete(item)
                    
                    item.done = !item.done
                }
            } catch{
                print("Error as saving done data : \(error)")
            }
        }
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

            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let item = Item()
                        item.createdDate = Date()
                        print(item.createdDate!)
                        
                        item.title = textField.text!
                        currentCategory.items.append(item)
                    }
                } catch{
                    print("Error as saving \(error)")
                }
            
            }
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    //MARK: - store and restore Data
//    func storeArray(){
//
//        do {
//            try context.save()
//        } catch {
//            print("Something is wrong as saving context  \(error)")
//        }
//    }
    func loadData(){
        todoItem = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
}

//MARK: - SearchBar implement
extension ToDoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        todoItem = todoItem?.filter(NSPredicate(format: "title CONTAINS[c] %@", searchBar.text!)).sorted(byKeyPath: "createdDate", ascending: true)
        tableView.reloadData()

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

