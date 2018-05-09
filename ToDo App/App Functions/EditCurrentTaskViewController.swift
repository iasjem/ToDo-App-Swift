//
//  EditCurrentTaskViewController.swift
//  ToDo App
//
//  Created by Jemimah Beryl M. Sai on 03/05/2018.
//  Copyright © 2018 Jemimah Beryl M. Sai. All rights reserved.
//

import Foundation
import UIKit

class EditCurrentTaskViewController: UIViewController {
    
    @IBOutlet weak var toErrCurrentTask: UILabel!
    @IBOutlet weak var currentTaskTitle: UITextField!
    @IBOutlet weak var currentTaskNotes: UITextField!
    @IBOutlet weak var currentTaskDateCompleted: UIDatePicker!
    @IBOutlet weak var currentTaskIsComplete: UIButton!
    @IBOutlet weak var currentTaskStatus: UITextView!
    
    var isTaskComplete: Bool = false
    var taskDateCompleted: String?
    var myDate = MyDate()
    var list = List()
    
    @objc func saveCurrentTask() {
        prepareDataForSave()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Top navigation bar
        navigationItem.title = "Edit Task"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveCurrentTask))
        
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        taskDateCompleted = myDate.dateToString(currentTaskDateCompleted.date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentTaskDateCompleted.isEnabled = false // set defaults of edit form
        currentTaskIsComplete.setImage(UIImage(named: "CheckBoxUnchecked"), for: UIControlState.normal)
        toErrCurrentTask.text = " "
        
        let dateCreated = UserDefaults.standard.string(forKey: "myDateCreated")!
        let dateUpdated = UserDefaults.standard.string(forKey: "myDateUpdated")!
        
        let myDateCompleted = UserDefaults.standard.string(forKey: "myDateCompleted")
        
        currentTaskTitle.text = UserDefaults.standard.string(forKey: "myTitle")
        currentTaskStatus.text = """
        
        Last Updated: \(String(describing: dateUpdated))
        
        Created Date: \(String(describing: dateCreated))
        
        """
        currentTaskNotes.text = UserDefaults.standard.string(forKey: "myNotes")
        isTaskComplete = UserDefaults.standard.bool(forKey: "isTaskComplete")
        
        if isTaskComplete == true { // is checkbox checked or unchecked?
            currentTaskIsComplete.setImage( UIImage(named: "CheckBoxChecked"), for: UIControlState.normal)
            currentTaskDateCompleted.isEnabled = true
            currentTaskDateCompleted.date = myDate.stringToDate(myDateCompleted!)
        }
    }
    
    @IBAction func checkNewTaskIsComplete(_ sender: Any) { // check box behavior
        let checkBox = currentTaskIsComplete.currentImage?.isEqual(UIImage(named: "CheckBoxUnchecked"))
        if checkBox! {
            currentTaskIsComplete.setImage( UIImage(named: "CheckBoxChecked"), for: UIControlState.normal)
            currentTaskDateCompleted.isEnabled = true
            isTaskComplete = true
        } else {
            currentTaskIsComplete.setImage(UIImage(named: "CheckBoxUnchecked"), for: UIControlState.normal)
            currentTaskDateCompleted.isEnabled = false
            isTaskComplete = false
        }
    }
    
    func prepareDataForSave() {
        guard let title = currentTaskTitle.text, title != "" else { // Title field cannot be empty
            toErrCurrentTask.text = "* Task title is required"
            currentTaskTitle.backgroundColor = UIColor.lightGray
            return
        }
        taskDateCompleted = myDate.dateToString(currentTaskDateCompleted.date)

        print(taskDateCompleted!)
        
        // If successful, time to transfer data
        UserDefaults.standard.set(currentTaskTitle.text!, forKey: "myTitle")
        UserDefaults.standard.set(currentTaskNotes.text!, forKey: "myNotes")
        UserDefaults.standard.set(isTaskComplete, forKey: "isTaskComplete")
        UserDefaults.standard.set(taskDateCompleted!, forKey: "myDateCompleted")
        
        list.setAction("edit") // tell app to make changes from selected list item
        
        // go back to main screen
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
        
    }
    
}
