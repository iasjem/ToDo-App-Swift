//
//  TaskListTableViewCell.swift
//  ToDo App
//
//  Created by Jemimah Beryl M. Sai on 05/05/2018.
//  Copyright © 2018 Jemimah Beryl M. Sai. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskTitle: UILabel!
    
    @IBOutlet weak var taskNotes: UILabel!
    
    @IBOutlet weak var taskStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
