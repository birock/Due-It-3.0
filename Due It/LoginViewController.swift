//
//  LoginViewController.swift
//  Due It
//
//  Created by Rebecca Raab on 11/28/18.
//  Copyright © 2018 Due It. All rights reserved.
//

import UIKit
import SpriteKit
import SceneKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    var ref: DatabaseReference!
    var tasks = [String]();
//variables and funcitons for creating user login
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var createButton: UIButton!
    //Create Account Function
    @IBAction func CreateAccount(_ sender: Any) {
        
        if let email=Username.text, let password=Password.text{
            
            Auth.auth().createUser(withEmail: email, password: password) { user, error in
                
                //error
                if let firebaseError=error{
                    print(firebaseError.localizedDescription)
                    return
                }
                //account created
                print("Success")
                
                
                //database ref
                let ref=Database.database().reference()
                //let userRef=ref.child("users")
                let userRef = ref.child("users").child(user!.user.uid)
                userRef.setValue(["email":email])


                //go to to due list screen
                self.goToApp()
            }
        }
    }
    @IBOutlet weak var loginButton: UIButton!
    //Login Function
    @IBAction func Login(_ sender: Any) {
        if let email=Username.text, let password=Password.text{
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                //error
                if let firebaseError=error{
                    print(firebaseError.localizedDescription)
                    return
                }
                //no error
                print("success")
                

                
                //go to to due list screen
                self.goToApp()
            }

        }
    }
    
    override func viewDidLoad() {
        //view.backgroundColor = UIColor.orange
        //print("Hello")
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
    }
    override func didReceiveMemoryWarning() {
        
    }
    
    //Go to the to DUE list screen
    func goToApp(){
        let storyboard:UIStoryboard=UIStoryboard(name:"Main", bundle:nil)
        let viewController:ViewController=storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(viewController, animated: true, completion: nil)
        //raab
        let dRef = Database.database().reference()
        //let tName: String = input.text!
        
        let userID = Auth.auth().currentUser?.uid
        
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
        
        
        let r = dRef.child("users").child(userID!)
        r.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get all user informaiton
            let value = snapshot.value as? NSDictionary
            //get the email from the database
            let email = value?["email"] as? String ?? ""
            //get a dictionary full of task NSDictionaries
            let tasks = value?["tasks"] as? NSDictionary
            
            //iterate through each task dictionary
            if tasks != nil{
                for (key, value) in tasks!{
                    //for the current task, find all the information
                    let task = tasks?[key] as! NSDictionary
                    let tDate = task["date"] as? String
                    let urgencyCode = task["urgencyCode"] as? Int
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let dateObj = dateFormatter.date(from: tDate!)
                    
                    let newTask = Task(name: key as! String, urgency: urgencyCode!, date: dateObj!)
                    userTasks.append(newTask)
                    
                }
                
                
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        

//        r.observe(.value){ snapshot in
//            for child in snapshot.children{
//
//                let task=child as! DataSnapshot
////
////                self.tasks.append(t)
////                print("added t: ",t)
//                //list.append(t)
//            }
//
//        }
        
        viewController.tasksExisting(dbTasks: tasks)
        
    }
    
  
}
