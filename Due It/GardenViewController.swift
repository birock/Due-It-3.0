//
//  GardenViewController.swift
//  Due It
//
//  Created by Dan McKenna on 11/28/18.
//  Copyright © 2018 Due It. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class GardenViewController: UIViewController {
    @IBOutlet weak var BackgroundImageView: UIImageView!
    var canEdit: Bool = false
    var counter = 1
    var flowerName = ""
    
    @objc func tapAction(sender: UITapGestureRecognizer){
        // Get points for the UIImageView
        
        guard canEdit && counter > 0 else{
            return
        }
        
        let touchPoint = sender.location(in: self.BackgroundImageView)
        print(touchPoint)
        
        // Get points from the image itself
        let z1 = touchPoint.x// * (BackgroundImageView.image?.size.width)! / BackgroundImageView.frame.width
        let z2 = touchPoint.y// * (BackgroundImageView.image?.size.height)! / BackgroundImageView.frame.height
        
        let singleton = Singleton.getSingleton()
        singleton?.coordinates?.append((z1,z2))
        
        //add to database
        let dRef = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        dRef.child("users").child(userID!).child("flowers").childByAutoId().setValue([z1, z2]);

        addFlower(z1: z1,z2: z2)
        counter -= 1
    }
    
    func addFlower(z1:CGFloat, z2:CGFloat){
        let pin = UIImageView(frame: CGRect(x: z1 - 20, y: z2 - 20, width: 40, height: 40))
        pin.image = UIImage(named: "flower.png")
        BackgroundImageView.addSubview(pin)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let singleton = Singleton.getSingleton()
        
        //retrieve all flowers from a user from database
        let dRef = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        let r = dRef.child("users").child(userID!)
        r.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get all user information
            let value = snapshot.value as? NSDictionary
            //get a dictionary full of task NSDictionaries
            let coords = value?["flowers"] as? NSDictionary
            //iterate through each task dictionary
            if coords != nil{
                for (key, value) in coords!{
                    //for the user, load all the coordinates of their flowers
                    let coord = coords?[key] as! [CGFloat]
                    singleton?.coordinates?.append((coord[0], coord[1]))
                }
                
                for coordinate in singleton!.coordinates!{
                    let (z1, z2) = coordinate
                    self.addFlower(z1: z1,z2: z2)
                }
            
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        


        
        for coordinate in singleton!.coordinates!{
            let (z1, z2) = coordinate
            addFlower(z1: z1,z2: z2)
        }

        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        
        self.BackgroundImageView.isUserInteractionEnabled = true
        self.BackgroundImageView.addGestureRecognizer(tapGestureRecognizer)
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
