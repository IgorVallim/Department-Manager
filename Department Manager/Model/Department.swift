//
//  Department.swift
//  Department Manager
//
//  Created by Igor Vallim on 12/10/2018.
//  Copyright © 2018 Igor Vallim. All rights reserved.
//

import UIKit

class Department{
    
    var name: String
    var id: Int
    var initials: String
    var photo: UIImage?
    
    init(name: String, id: Int, initials: String, photo: UIImage?){
        self.name = name
        self.initials = initials
        self.id = id
        self.photo = photo
    }
}
