//
//  Employee.swift
//  Dapartment Manager
//
//  Created by Igor Vallim on 13/10/2018.
//  Copyright © 2018 Igor Vallim. All rights reserved.
//

import UIKit
import os.log

class Employee: NSObject, NSCoding{
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("employees")
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let depId = "depId"
        static let id = "id"
        static let rg = "rg"
    }
    
    var name: String
    var id: Int
    var depId: Int
    var rg: Int
    var photo: UIImage?
    private static var identifierFactory: Int{
        get{
            return UserDefaults.standard.integer(forKey: "idF")
        }
        set{
            UserDefaults.standard.set(newValue,forKey: "idF")
        }
    }
    
    private static func getUniqueIdentifier() -> Int{
        identifierFactory+=1
        return identifierFactory
    }
    
    init(name: String, id: Int, depId: Int, rg: Int, photo: UIImage?){
        self.name = name
        self.depId = depId
        self.id = id
        self.photo = photo
        self.rg = rg
    }
    
    init(name: String, depId: Int, rg: Int, photo: UIImage?){
        self.name = name
        self.depId = depId
        self.id = Employee.getUniqueIdentifier()
        self.photo = photo
        self.rg = rg
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(depId, forKey: PropertyKey.depId)
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(rg, forKey: PropertyKey.rg)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Employee object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let id = aDecoder.decodeInteger(forKey: PropertyKey.id)
        let depId = aDecoder.decodeInteger(forKey: PropertyKey.depId)
        let rg = aDecoder.decodeInteger(forKey: PropertyKey.rg)
       
        
        // Must call designated initializer.
        self.init(name: name, id: id, depId: depId, rg: rg, photo: photo)
        
    }
    
}
