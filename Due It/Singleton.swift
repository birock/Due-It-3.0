//
//  Singleton.swift
//  Due It
//
//  Created by Ben Rock on 12/5/18.
//  Copyright © 2018 Due It. All rights reserved.
//

import Foundation
import UIKit

public class Singleton{
    private static var singleton:Singleton?
    public var coordinates:[(CGFloat, CGFloat)]?
    private init(){
        coordinates = Array()
    }
    
    public static func getSingleton() -> Singleton!{
        if singleton == nil{
            singleton = Singleton()
        }
        return singleton
    }
}
