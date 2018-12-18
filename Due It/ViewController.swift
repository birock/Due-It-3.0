//
//  ViewController.swift
//  Due It
//
//  Created by Dan McKenna on 11/12/18.
//  Copyright © 2018 Due It. All rights reserved.
//

import UIKit
import AVFoundation
//adding firebase for database storage
import FirebaseDatabase
import Firebase
import SceneKit
import FirebaseAuth

var list = [String]()
var numFinished = 0



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func LogoutBtn(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            //clear user tasks list
            userTasks.removeAll()
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    var ref: DatabaseReference!
    var applauseSoundEffect: AVAudioPlayer?
    
    let userEmail=""
    
    var tasks = list;
    
    var dbTaskList=[String]()
    
    func tasksExisting(dbTasks: [String]){
        //userTasks.append(dbTasks)
        //tasks.append(contentsOf: dbTasks)
        dbTaskList.append(contentsOf: dbTasks)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tasks.count);
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Task")
        task.backgroundColor = userTasks[indexPath.row].getTaskColor()
        task.textLabel?.text = tasks[indexPath.row]
        
        
        return(task)
    }
    
    /* commenting out bens function to try creating edit
     
    func tableView(_ tableview: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            self.tasks.remove(at: indexPath.row)
            numFinished += 1
            print("Tasks Completed: ", numFinished)
            list = tasks
            myTableView.reloadData()
        }
   
    }
 */
    
    //Raab testing a delete and edit function
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //let task=tasks[indexPath.row]
        //edit
        let editTask=UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            //call edit task function
            print(".........edit..........")
            self.editT(indexPath: indexPath)
        }
        //delete
        let deleteTask=UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            //call delete task function
            print("..........delete..................")
            self.deleteT(indexPath: indexPath)
        }
        
        let completeTask=UITableViewRowAction(style: .default, title: "Complete") { (action, indexPath) in
            //call complete task function
            print("..........complete..................")
            self.completeT(indexPath: indexPath)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "selectFlowerVC") as! SelectFlowerViewController
            print(vc);
            
            self.show(vc, sender: nil);
            
        }
        
        editTask.backgroundColor = .blue
        deleteTask.backgroundColor = .red
        completeTask.backgroundColor = .green
        return [editTask, deleteTask, completeTask]
    }
    
    //function to edit task
    private func editT(indexPath: IndexPath){
        print(".......made it here.........")
        //go to edit view
        let storyboard:UIStoryboard=UIStoryboard(name:"Main", bundle:nil)
        let EditVC:EditTaskViewController=storyboard.instantiateViewController(withIdentifier: "EditTaskViewController") as! EditTaskViewController
        self.present(EditVC, animated: true, completion: nil)
        
        //send tasks info to the edit screen
        EditVC.view.backgroundColor = userTasks[indexPath.row].getTaskColor()
        EditVC.editTaskTitle.text=userTasks[indexPath.row].getTaskName()
        
        EditVC.setDate(Date: userTasks[indexPath.row].getDueDate())
        
        EditVC.getRow(indexPath: indexPath)
        
        EditVC.editUrgency.value=Float(userTasks[indexPath.row].urgencyCode)
        
    }
    //function to delete task
    private func deleteT(indexPath: IndexPath){
      
        userTasks.remove(at: indexPath.row)
        //self.tableView?.deleteRows(at: [indexPath], with: .automatic)
        list = tasks
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
            list.append(userTasks[i].getTaskName())
        }
        tasks = list;
        
        let dRef = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        dRef.child("users").child(userID!).child("tasks").removeValue()
        
        for task in userTasks{
            
            
            dRef.child("users").child(userID!).child("tasks").child(task.getTaskName()).setValue(task.getTaskName())
            dRef.child("users").child(userID!).child("tasks").child(task.getTaskName()).child("urgencyCode").setValue(Int(task.urgencyCode))
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from: task.getDueDate())
            dRef.child("users").child(userID!).child("tasks").child(task.getTaskName()).child("date").setValue(dateString)
            
            
        }
        
        myTableView.reloadData()

        
    }
    
    //function to complete task
    private func completeT(indexPath: IndexPath){
        
        userTasks.remove(at: indexPath.row)
        
        let path = Bundle.main.path(forResource: "applause2.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            applauseSoundEffect = try AVAudioPlayer(contentsOf: url)
            applauseSoundEffect?.play()
        } catch {
            print("Could not load sound file")
        }
        
        numFinished += 1

        list = tasks
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
            list.append(userTasks[i].getTaskName())
        }
        tasks = list;
        
        let dRef = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        dRef.child("users").child(userID!).child("tasks").removeValue()
        

        for task in userTasks{
            dRef.child("users").child(userID!).child("tasks").child(task.getTaskName()).setValue(task.getTaskName())
            dRef.child("users").child(userID!).child("tasks").child(task.getTaskName()).child("urgencyCode").setValue(Int(task.urgencyCode))

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from: task.getDueDate())
            dRef.child("users").child(userID!).child("tasks").child(task.getTaskName()).child("date").setValue(dateString)
            
            
        }
        


        
        myTableView.reloadData()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        
        let dRef = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        dRef.child("users").child(userID!).child("tasks").removeValue()
        
        for task in userTasks{
            
            
            dRef.child("users").child(userID!).child("tasks").child(task.getTaskName()).setValue(task.getTaskName())
            dRef.child("users").child(userID!).child("tasks").child(task.getTaskName()).child("urgencyCode").setValue(Int(task.urgencyCode))
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from: task.getDueDate())
            dRef.child("users").child(userID!).child("tasks").child(task.getTaskName()).child("date").setValue(dateString)
            
            
        }
        
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
        tasks = list;

        myTableView.reloadData()
    }
    

    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {

        
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
    
}

}
