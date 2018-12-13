//
//  EditTaskViewController.swift
//  Due It
//
//  Created by Rebecca Raab on 11/30/18.
//  Copyright © 2018 Due It. All rights reserved.
//

import UIKit
//Raab adding firebase for database storage
import FirebaseDatabase
import SceneKit
import SpriteKit
import Foundation

class EditTaskViewController: UIViewController {

  
    var rowOfTask=0
    
    @IBOutlet weak var editTaskTitle: UITextField!
    @IBOutlet weak var editDate: UIDatePicker!    
    
    //date update
    @IBAction func dateChange(_ sender: Any) {
        let editTask = Task(name: editTaskTitle.text!, urgency: Int(editUrgency.value), date: editDate.date)
        view.backgroundColor = editTask.getTaskColor()
        
    }
    
    @IBOutlet weak var editUrgency: UISlider!
    
    //urgency update
    @IBAction func urgencyChange(_ sender: Any) {
        let editTask = Task(name: editTaskTitle.text!, urgency: Int(editUrgency.value), date: editDate.date)
        view.backgroundColor = editTask.getTaskColor()
    }
    
    //when user clicks edit need to update the task in list
    @IBAction func editButton(_ sender: Any) {
        
        if (editTaskTitle.text != "") {
            let editTask = Task(name: editTaskTitle.text!, urgency: Int(editUrgency.value), date: editDate.date)
            userTasks[rowOfTask]=editTask
            list[rowOfTask]=editTaskTitle.text!
            
            //addToDataBase()
            // ref?.child("list").childByAutoId().setValue(newTask)
      
        }
        
    }
    
   
    
    //set date picker to orig task date
    func setDate(Date: Date){
        editDate.date=Date
    }
    //get row of task
    func getRow(indexPath: IndexPath){
        rowOfTask=indexPath.row
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
