//
//  SelectFlowerViewController.swift
//  Due It
//
//  Created by Dan McKenna on 12/17/18.
//  Copyright © 2018 Due It. All rights reserved.
//

import UIKit

class SelectFlowerViewController: UIViewController {
    @IBOutlet weak var flowerImage: UIImageView!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    
    var flower = 0;
        let flowers = ["flower.png", "yellowstem.png", "purple.png"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flowerImage.image = UIImage(named: flowers[flower]);

        // Do any additional setup after loading the view.
    }
    
    @IBAction func rightBtnPressed(_ sender: Any) {
        flower = flower + 1;
        if(flower >= flowers.count){
            flower = 0;
        }
        flowerImage.image = UIImage(named: flowers[flower]);
    }

    @IBAction func leftBtnPressed(_ sender: Any) {
        flower = flower - 1;
        if(flower > 0){
            flower = flowers.count-1;
        }
        flowerImage.image = UIImage(named: flowers[flower]);
    }

    @IBAction func selectBtnPressed(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "gardenVC") as! GardenViewController
        vc.canEdit = true
        vc.setFlower(flower: flowers[flower]);
//        vc.flowerName = flowers[flower];
        
        self.show(vc, sender: nil)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gVC = segue.destination as! GardenViewController
        gVC.flowerName = flowers[flower];
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
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
