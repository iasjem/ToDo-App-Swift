//
//  TaskArrayList.swift
//  ToDo App
//
//  Created by Jemimah Beryl M. Sai on 05/05/2018.
//  Copyright © 2018 Jemimah Beryl M. Sai. All rights reserved.
//

import Foundation

struct ListItem: Equatable {
    var title: String = ""
    var note: String?
    var isTaskComplete: Bool = false
    var dateCompleted: String?
    var dateUpdated: String = ""
    var dateCreated: String = ""
    
    init(_ title: String, _ note: String, _ isTaskComplete: Bool, _ dateCompleted: String, _ dateCreated: String) {
        self.title = title
        self.note = note
        self.isTaskComplete = isTaskComplete
        self.dateCreated = dateCreated
        self.dateUpdated = dateCreated
        self.dateCompleted = dateCompleted
    }
    
    static func == (lhs: ListItem, rhs: ListItem) -> Bool { // for comparing of ListItem types
        return lhs.title == rhs.title && lhs.note! == rhs.note! && lhs.dateCreated == rhs.dateCreated
    }
}

class List {
    
    var listArr = [ListItem]()
    var archivedListArr = [ListItem]()
    var myDate = MyDate()
    
    func addItem (title: String, note: String, isTaskComplete: Bool, dateCompleted: String) {
        let dateCreated: String = myDate.dateToString(myDate.today)
        if isTaskComplete == true { // if task has already been completed
            archivedListArr.append(ListItem(title, note, isTaskComplete, dateCompleted, dateCreated))
        } else {
            listArr.append(ListItem(title, note, isTaskComplete, dateCompleted, dateCreated))
        }
    }

    func editItem (_ i: Int, _ newTitle: String, _ newNotes: String, _ newIsTaskComplete: Bool, _ newDateCompleted: String) {
        
        let existTitle = typeOfArray(newIsTaskComplete, i).title
        let existNotes = typeOfArray(newIsTaskComplete, i).note!
        let existIsTaskCompleted = typeOfArray(newIsTaskComplete, i).isTaskComplete
        let existDateCompleted = typeOfArray(newIsTaskComplete, i).dateCompleted!
        
        let newDateUpdated = myDate.dateToString(myDate.today)
        
        let title = newTitle != "" ? newTitle : existTitle
        let notes = newNotes != existNotes ? newNotes : existNotes
        let isTaskComplete = newIsTaskComplete != existIsTaskCompleted ? newIsTaskComplete : existIsTaskCompleted
        let dateCompleted = newDateCompleted != existDateCompleted ? newDateCompleted : existDateCompleted
        
        if isTaskComplete == false { // is task is still active
            listArr[i].title = title
            listArr[i].note! = notes
            listArr[i].isTaskComplete = isTaskComplete
            listArr[i].dateCompleted = dateCompleted
            listArr[i].dateUpdated = newDateUpdated
        } else {
            archivedListArr[i].title = title
            archivedListArr[i].note! = notes
            archivedListArr[i].isTaskComplete = isTaskComplete
            archivedListArr[i].dateCompleted = dateCompleted
            archivedListArr[i].dateUpdated = newDateUpdated
        }
    }
    
    func isToBeChangedArr( _ newIsTaskComplete: Bool, _ oldState: Bool, _  i: Int, _ newTitle: String, _ newNotes: String, _ newDateCompleted: String) {
        if newIsTaskComplete != oldState { // remove item from preivous array list
            removeItem (oldState, i)
            addItem(title: newTitle, note: newNotes, isTaskComplete: newIsTaskComplete, dateCompleted: newDateCompleted)
        } else { // continue to edit to selected list item from its current array list
            editItem (i, newTitle, newNotes, newIsTaskComplete, newDateCompleted)
        }
    }
    
    func removeItem (_ filterByType: Bool, _ i: Int) {
        if filterByType == false { // if list item still active
            listArr.remove(at: i)
        } else {
            archivedListArr.remove(at: i)
        }
    }
    
    /* Identiying array list to be used for accessing properties and tableview cells */
    func typeOfArray (_ filterByType: Bool, _ indexPath: Int) -> ListItem {
        var i: ListItem! // filter if list item is active or archived
        if filterByType == false { // if list item still active
            i = listArr[indexPath]
        } else {
            i = archivedListArr[indexPath]
        }
        return i
    }
    
    func typeOfArray (_ filterByType: Bool, _ indexPath: IndexPath) -> ListItem {
        var cell: ListItem! // filter for table view cells
        if filterByType == false { // if list item still active
            cell = listArr[indexPath.row]
        } else {
            cell = archivedListArr[indexPath.row]
        }
        return cell
    }
    
    var defaults = UserDefaults.standard
    
    func setAction(_ action: String) { // set action for each button pressed
        defaults.set(action, forKey: "myAction")
    }
    
    func getAction(_ action: String)  -> String {
        return defaults.string(forKey: "myAction")!
    }
    
    func clearUserData() { // clear data from User defaults to make space for other
        defaults.set("", forKey: "myAction")
        defaults.removeObject(forKey: "myTitle")
        defaults.removeObject(forKey: "myNotes")
        defaults.removeObject(forKey: "myDateCompleted")
        defaults.removeObject(forKey: "isTaskComplete")
        defaults.removeObject(forKey: "myDateCreated")
        defaults.removeObject(forKey: "myDateUpdated")
    }
    
    /* For testing purposes */
    func testArrays() {
        for x in listArr {
            print(x.title)
            print(x.note!)
            print(x.isTaskComplete)
            print(x.dateCompleted!)
        }
    }
    
    func countItems (_ filterByType: Bool) -> Int {
        if filterByType == false { // if list item still active
            return listArr.count
        } else {
            return archivedListArr.count
        }
    }
    
}



