//
//  TaskListViewController.swift
//  ToDo App
//
//  Created by Jemimah Beryl M. Sai on 03/05/2018.
//  Copyright © 2018 Jemimah Beryl M. Sai. All rights reserved.
//

import Foundation
import UIKit

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var filterByDate: String = "month" // kind of filter performed. default is by month (month or year)
    var filterByType: Bool = false
    
    var list = List()
    var action = ""
    
    var indexPathAtRow: Int?
    
    func filterList() { // will be reused
        if filterByType == false {
            navigationItem.title = "To Do's"
        } else {
            navigationItem.title = "Archives"
        }
    }
    
    @objc func filterListitems() {
        filterByType = !filterByType
        filterList()
        self.tableView.reloadData()
    }
    
    @objc func addNewTask() {
        performSegue(withIdentifier: "showAddForm", sender: nil)
    }

    @objc func editActiveTask() {
        performSegue(withIdentifier: "showEditForm", sender: nil)
    }
    
    @objc func removeActiveTask() {
        let alert = UIAlertController(title: "Warning!", message: "Task item \(self.indexPathAtRow!)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
        }))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: {_ in
            self.list.setAction("remove")
            self.reloadTableView()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func reloadTableView() {
        navBarOne()
        let getAction = list.getAction(action)
        indexPathAtRow = UserDefaults.standard.integer(forKey: "indexPathAtRow")
        switch getAction {
        case "add": // see addNewItem() function
            addNewItem()
        case "edit": // see editSelectedItem() function
            editSelectedItem(indexPathAtRow!)
        case "remove":
             list.removeItem(self.filterByType, self.indexPathAtRow!)
        default: break;
        }
        self.tableView.reloadData()
        list.clearUserData() // clear user data
    }
    
    func addNewItem() {
        print(UserDefaults.standard.string(forKey: "myDateCompleted")!)
        list.addItem(title: UserDefaults.standard.string(forKey: "myTitle")!, note: UserDefaults.standard.string(forKey: "myNotes")!, isTaskComplete:  UserDefaults.standard.bool(forKey: "isTaskComplete"), dateCompleted: UserDefaults.standard.string(forKey: "myDateCompleted")!)
    }
    
    func editSelectedItem(_ indexPathAtRow: Int) {
        let oldState = UserDefaults.standard.bool(forKey: "oldState")
        let indexPathAtRow = UserDefaults.standard.integer(forKey: "indexPathAtRow")
        let title = UserDefaults.standard.string(forKey: "myTitle")!
        let notes = UserDefaults.standard.string(forKey: "myNotes")
        let dateCompleted = UserDefaults.standard.string(forKey: "myDateCompleted")
        let isTaskComplete = UserDefaults.standard.bool(forKey: "isTaskComplete")
        
        list.isToBeChangedArr(isTaskComplete, oldState, indexPathAtRow, title, notes!, dateCompleted!)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterList()
        list.setAction("")
        
        reloadTableView()

        tableView.delegate = self
        tableView.dataSource = self

        // When tapping out of bounds from the list, deselect selected list item
        let tapUIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: tableView.frame.height))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapFooterView))
        tapUIView.addGestureRecognizer(tapGesture)
        tableView.tableFooterView = tapUIView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadTableView() // reload view
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
            navBarOne() // go back default and deselect a list item
        }
    }
    
    @objc func didTapFooterView(sender: UITapGestureRecognizer) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
            navBarOne()
        }
    }
    
    func navBarOne() { // first navigation bar by default
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterListitems))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addNewTask))
    }
    
    func navBarTwo() { // second navigation bar after selecting a list item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(removeActiveTask))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editActiveTask))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navBarTwo()
        indexPathAtRow = indexPath.row
        UserDefaults.standard.set(list.typeOfArray(filterByType, indexPath).title, forKey: "myTitle")
        UserDefaults.standard.set(list.typeOfArray(filterByType, indexPath).note, forKey: "myNotes")
        UserDefaults.standard.set(list.typeOfArray(filterByType, indexPath).isTaskComplete, forKey: "isTaskComplete")
        UserDefaults.standard.set(list.typeOfArray(filterByType, indexPath).dateCompleted, forKey: "myDateCompleted")
        UserDefaults.standard.set(list.typeOfArray(filterByType, indexPath).dateCreated, forKey: "myDateCreated")
        UserDefaults.standard.set(list.typeOfArray(filterByType, indexPath).dateUpdated, forKey: "myDateUpdated")
        UserDefaults.standard.set(indexPathAtRow, forKey: "indexPathAtRow")
        UserDefaults.standard.set(list.typeOfArray(filterByType, indexPath).isTaskComplete, forKey: "oldState")

    }
    
    // Filter list items by active and archived tasks
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.countItems(filterByType)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TaskListTableViewCell
            cell.taskTitle.text = list.typeOfArray(filterByType, indexPath).title
            cell.taskNotes.text = list.typeOfArray(filterByType, indexPath).note
        cell.taskStatus.text = "Completed Date: \(String(describing: list.typeOfArray(filterByType, indexPath).dateCompleted!))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
