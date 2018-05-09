//
//  AddNewTaskViewController.swift
//  ToDo App
//
//  Created by Jemimah Beryl M. Sai on 03/05/2018.
//  Copyright © 2018 Jemimah Beryl M. Sai. All rights reserved.
//

import Foundation
import UIKit

class AddNewTaskViewController: UIViewController {
    
    @IBOutlet weak var newTaskTitle: UITextField!
    @IBOutlet weak var newTaskIsComplete: UIButton!
    @IBOutlet weak var newTaskDateCompleted: UIDatePicker!
    @IBOutlet weak var newTaskNotes: UITextField!
    @IBOutlet weak var toErrNewTask: UILabel!

    var isTaskComplete: Bool = false
    var taskDateCompleted: String = ""
    var list = List()
    var myDate = MyDate()
    @objc func saveNewTask() {
        prepareDataForSave()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New Task"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveNewTask))
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        taskDateCompleted = myDate.dateToString(newTaskDateCompleted.date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newTaskDateCompleted.isEnabled = false
        newTaskIsComplete.setImage(UIImage(named: "CheckBoxUnchecked"), for: UIControlState.normal)
        newTaskTitle.text = ""
        newTaskNotes.text = ""
        toErrNewTask.text = " "
        isTaskComplete = false
    }
    
    @IBAction func checkNewTaskIsComplete(_ sender: Any) {
        let checkBox = newTaskIsComplete.currentImage?.isEqual(UIImage(named: "CheckBoxUnchecked"))
        if checkBox! {
            newTaskIsComplete.setImage( UIImage(named: "CheckBoxChecked"), for: UIControlState.normal)
            newTaskDateCompleted.isEnabled = true
            isTaskComplete = true
            
        } else {
            newTaskIsComplete.setImage(UIImage(named: "CheckBoxUnchecked"), for: UIControlState.normal)
            newTaskDateCompleted.isEnabled = false
            isTaskComplete = false
        }
    }
    
    func prepareDataForSave() {
        guard let title = newTaskTitle.text, title != "" else {
            toErrNewTask.text = "* Task title is required"
            newTaskTitle.backgroundColor = UIColor.lightGray
            return
        }

       
        UserDefaults.standard.set(newTaskTitle.text!, forKey: "myTitle")
        UserDefaults.standard.set(newTaskNotes.text!, forKey: "myNotes")
        UserDefaults.standard.set(isTaskComplete, forKey: "isTaskComplete")
        UserDefaults.standard.set(taskDateCompleted, forKey: "myDateCompleted")
        list.setAction("add")
        
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
        
    }
    
}
