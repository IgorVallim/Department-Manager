//
//  Employee.swift
//  Department Manager
//
//  Created by Igor Vallim on 13/10/2018.
//  Copyright © 2018 Igor Vallim. All rights reserved.
//

import UIKit
import os.log

class Employee: NSObject, NSCoding{
    
    //Mark: Atributos
    
    var name: String //Nome do funcionario
    var id: Int //ID do funcionario
    var depId: Int //ID do departamento ao qual o funcionario pertence
    var rg: Int //RG do funcionario
    var photo: UIImage? //Foto do funcionario
    private static var identifierFactory: Int{ //Ultimo id criado
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
    init(name: String, id: Int, depId: Int, rg: Int, photo: UIImage?){
        self.name = name
        self.depId = depId
        self.id = id
        self.photo = photo
        self.rg = rg
    }
    
    //Construtor usado para recriar uma instancia da classe
    init(name: String, depId: Int, rg: Int, photo: UIImage?){
        self.name = name
        self.depId = depId
        self.id = Employee.getUniqueIdentifier()
        self.photo = photo
        self.rg = rg
    }
    
    //Mark: Persistencia de dados
    
    //Struct que armazena valores chave para salvar e recuperar dados
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let depId = "depId"
        static let id = "id"
        static let rg = "rg"
    }
    
    //Caminho onde serao salvos as instancias da classe
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("employees")
    
    //Funcao que decodifica os atributos e instancia classe
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Employee object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let id = aDecoder.decodeInteger(forKey: PropertyKey.id)
        let depId = aDecoder.decodeInteger(forKey: PropertyKey.depId)
        let rg = aDecoder.decodeInteger(forKey: PropertyKey.rg)
       
        self.init(name: name, id: id, depId: depId, rg: rg, photo: photo)
        
    }
    
    //Funcao que codifica os atributos
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(depId, forKey: PropertyKey.depId)
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(rg, forKey: PropertyKey.rg)
    }
    
}
