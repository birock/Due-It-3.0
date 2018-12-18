//
//  AddTaskViewController.swift
//  Due It
//
//  Created by Ben Rock on 11/24/18.
//  Copyright © 2018 Due It. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit
//Raab adding firebase for database storage
import FirebaseDatabase
import FirebaseAuth
import Firebase


var userTasks = [Task]()

class AddTaskViewController: UIViewController {
    
    //list for database
   // var toDueList: DatabaseReference!
    //database vars
    var ref:DatabaseReference?
    var handle:DatabaseHandle?
    var userList:[Task]=[]
    
    //@IBOutlet var particles: SKView!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var dateInput: UIDatePicker!
    @IBOutlet weak var urgencyInput: UISlider!
    
    @IBAction func changeUrgency(_ sender: Any) {
        let newTask = Task(name: input.text!, urgency: Int(urgencyInput.value), date: dateInput.date)
        view.backgroundColor = newTask.getTaskColor()
    }
    
    @IBAction func changeDate(_ sender: Any) {
        let newTask = Task(name: input.text!, urgency: Int(urgencyInput.value), date: dateInput.date)
        view.backgroundColor = newTask.getTaskColor()
    }
    
    @IBAction func add_item(_ sender: Any) {
        let newTask = Task(name: input.text!, urgency: Int(urgencyInput.value), date: dateInput.date)
        
        if (input.text != "") {
            if (input.text != "") {
                
                userTasks.append(newTask)
                userTasks.sort { (first, second) -> Bool in
                    if(first.taskCode > second.taskCode){
                        return true;
                    }
                    else{
                        return false;
                    }
                }
                list.removeAll()
                for i in 0..<userTasks.count {
                    
                    // Formatting task due date for display
                    let formatter = DateFormatter()
                    formatter.dateFormat = "(MMMM d, YYYY)"
                    let taskDate = formatter.string(from: userTasks[i].getDueDate())
                    
                    list.append(userTasks[i].getTaskName() + " " + taskDate)
                    
                }
            }
            
          //addToDataBase()
           //ref?.child("tasks").childByAutoId().setValue(newTask)
           
        let dRef = Database.database().reference()

            
        let userID = Auth.auth().currentUser?.uid
            print("current user id: ", userID!)
        
            dRef.child("users").child(userID!).child("tasks").child(input.text!).setValue(input.text!)
        dRef.child("users").child(userID!).child("tasks").child(input.text!).child("urgencyCode").setValue(Int(urgencyInput.value))
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from: dateInput.date)
            dRef.child("users").child(userID!).child("tasks").child(input.text!).child("date").setValue(dateString)
            
          
            
        
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Syncing with Database
//        handle=ref?.child("tasks").observe(.childAdded, with: {(snapshot) in
//            if let item=snapshot.value as? Task{
//                self.userList.append(item)
//                //self.myTableView.reloadData()
//                self.ref?.keepSynced(true)
//            }
//            
//        })

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
