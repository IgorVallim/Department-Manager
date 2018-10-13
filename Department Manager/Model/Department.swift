//
//  Department.swift
//  Department Manager
//
//  Created by Igor Vallim on 12/10/2018.
//  Copyright © 2018 Igor Vallim. All rights reserved.
//

import UIKit
import os.log

class Department: NSObject, NSCoding{
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("departments")

    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let initials = "initials"
        static let id = "id"
    }
    
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
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(initials, forKey: PropertyKey.initials)
        aCoder.encode(id, forKey: PropertyKey.id)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Department object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let id = aDecoder.decodeInteger(forKey: PropertyKey.id)
        
        guard let initials = aDecoder.decodeObject(forKey: PropertyKey.initials) as? String else {
            os_log("Unable to decode the initials for a Department object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(name: name, id: id, initials: initials, photo: photo)
        
    }
    
}
