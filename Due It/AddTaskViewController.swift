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
                    list.append(userTasks[i].getTaskName())
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
    /*
    //Add to DB
    func addToDataBase(){
        //adding to database list
        let key=toDueList.childByAutoId().key
        let task=userTasks
        toDueList.child(key!).setValue(task)
    }
 */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        particles = SKView(frame: CGRect(x: 0, y: 0, width: 666, height: 500))
        particles.backgroundColor = UIColor.black
        self.view.addSubview(particles)
        
        if let view = self.particles as SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "particles.scnp") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
        }
 */
        
        
        //Syncing with Database
        handle=ref?.child("tasks").observe(.childAdded, with: {(snapshot) in
            if let item=snapshot.value as? Task{
                self.userList.append(item)
                //self.myTableView.reloadData()
                self.ref?.keepSynced(true)
            }
            
        })
        //firebase
        //FirebaseApp.configure()
        //toDueList=Database.database().reference().child("tasks")
        
        // Do any additional setup after loading the view.
        /*
        sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 666, height: 500))
        sceneView.backgroundColor = UIColor.black
        self.view.addSubview(sceneView)
        
        if let view = self.sceneView as SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "particles") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
        }
 */
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
