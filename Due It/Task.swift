//
//  Task.swift
//  Due It
//
//  Created by Dan McKenna on 11/18/18.
//  Copyright © 2018 Due It. All rights reserved.
//
import UIKit

class Task: NSObject {
    var taskName: String; //name of the task itself
    var urgencyCode: Int; //how important the task is
    var dateCode: Int; //how close is the task to the due date?
    var taskCode: Int;
    var dueDate: Date; //when the task needs to be completed by
    var taskColor: UIColor; //the color that the task has to be according to date and urgency
    
    /* initialize the task with a name, urgency, and due date from the user.
     * Then init the date code and color generically for now.
     */
    init(name: String, urgency: Int, date: Date) {
        self.taskName = name;
        self.urgencyCode = urgency;
        self.dueDate = date;
        self.dateCode = 0;
        self.taskCode = 0;
        self.taskColor = UIColor.green;
    }
    
    func getTaskCode() -> Int{
        //the code to determine the color is based on the urgency + date
        taskCode = (self.urgencyCode + self.getDateCode());
        print("Task code: ", taskCode)
        return taskCode;
    }
    
    func getDateCode() -> Int{
        //retrieve the amount of days between now and the due date, so everytime this
        // method is called it returns the updated code and updates the field in the object itself.
        
        let currentDate = Date()
        
        //let daysBetween = Calendar.current.component(.day, fromDate: currentDate, toDate: self.dueDate, options: [])
        var set = Set<Calendar.Component>()
        set.insert(.day)
        let daysBetween = Calendar.current.dateComponents(set, from: currentDate, to: dueDate)
        
        //let asd = Calendar.current.co
        //let a = Calendar.current.compo
        //let a = Calendar.current.com
        
        if(daysBetween.day! >= 30){
            self.dateCode = 1;
        }
        else if(daysBetween.day! >= 20){
            self.dateCode = 2;
        }
        else if(daysBetween.day! >= 14){
            self.dateCode = 3;
        }
        else if(daysBetween.day! >= 10){
            self.dateCode = 4;
        }
        else if(daysBetween.day! >= 7) {
            self.dateCode = 5;
        }
        else if(daysBetween.day! >= 5) {
            self.dateCode = 6;
        }
        else if(daysBetween.day! >= 4) {
            self.dateCode = 7;
        }
        else if(daysBetween.day! >= 3) {
            self.dateCode = 8;
        }
        else if(daysBetween.day! >= 2) {
            self.dateCode = 9;
        }
        else{
            self.dateCode = 10;
        }
        
        print("Date code: ", self.dateCode)
        print("Days between: ", daysBetween)
        return self.dateCode;
    }
    
    func getTaskColor() -> UIColor{
        
        /*
         * Ben, for this I'm thinking of coming up with an array of 10 preset colors based on task code.
         * That way, you can save the RBG or Hex values, and quickly return them in this method. Let me know
         * what you think!
         * -- Dan
         */
        
        var colors = [UIColor]()
        
        for i in 1...10 {
            var color = UIColor(red: (CGFloat(Float(i)/10.0)), green: 1.0, blue: 0, alpha: 0.9)
            colors.append(color);
            print((Float(i)/10.0))
        }
        
        for i in 1...10 {
            var color = UIColor(red: 1.0, green: (CGFloat(1.0-(Float(i)/10.0))), blue: 0, alpha: 0.9)
            colors.append(color)
            print(1.0-(Float(i)/10.0))
        }
        
        return colors[self.getTaskCode()-1]
        
    }
    
    func getTaskName() -> String{
        return self.taskName;
    }
    
    func getDueDate() -> Date{
        return self.dueDate;
    }
    
    
    
    
}
