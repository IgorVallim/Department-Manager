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
    
    //Mark: Atributos
    
    var name: String //Nome do departamento
    var id: Int //ID do departamento
    var initials: String //Sigla do departamento
    var photo: UIImage? //Imagem representando o departamento
    private static var identifierFactory: Int{ ///Ultimo id criado
        get{
            return UserDefaults.standard.integer(forKey: "idF")
        }
        set{
            UserDefaults.standard.set(newValue,forKey: "idF")
        }
    }
    
    //Mark: Funcoes da classe
    
    //Funcao que gera um id unico
    private static func getUniqueIdentifier() -> Int{
        identifierFactory+=1
        return identifierFactory
    }
    
    //Mark: Inits
    
    //Construtor que cria nova instancia (novo id)
    init(name: String, initials: String, photo: UIImage?){
        self.name = name
        self.initials = initials
        self.id = Department.getUniqueIdentifier()
        self.photo = photo
    }
    
    //Construtor usado para recriar uma instancia da classe
    init(name: String, id: Int, initials: String, photo: UIImage?){
        self.name = name
        self.initials = initials
        self.id = id
        self.photo = photo
    }
    
    //Mark: Persistencia de dados
    
    //Struct que armazena valores chave para salvar e recuperar dados
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let initials = "initials"
        static let id = "id"
    }
    
    //Caminho onde serao salvos as instancias da classe
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("departments")
    
    //Funcao que decodifica os atributos e instancia classe
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Department object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let id = aDecoder.decodeInteger(forKey: PropertyKey.id)
        
        guard let initials = aDecoder.decodeObject(forKey: PropertyKey.initials) as? String else {
            os_log("Unable to decode the initials for a Department object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(name: name, id: id, initials: initials, photo: photo)
        
    }
    
    //Funcao que codifica os atributos
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(initials, forKey: PropertyKey.initials)
        aCoder.encode(id, forKey: PropertyKey.id)
    }
    
}
