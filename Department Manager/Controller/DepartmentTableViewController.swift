//
//  DepartmentTableViewController.swift
//  Dapartment Manager
//
//  Created by Igor Vallim on 12/10/2018.
//  Copyright © 2018 Igor Vallim. All rights reserved.
//

import UIKit
import os.log

class DepartmentTableViewController: UITableViewController {

    //Mark: atributos
    
    var departments = [Department]() //Lista de departamentos a ser exibida
    
    //Mark: Funcoes de classe
    
    //Funcao que inicializa o vetor "departments"
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        if let savedDepartments = loadDepartments() {
            departments += savedDepartments
        }
        else {
            loadSamples()
        }
        departments = departments.sorted(by: {$0.name < $1.name})
    }
    
    //Funcao que habilita a exclusao de itens da tabela
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            departments.remove(at: indexPath.row)
            saveDepartments()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: Exibicao da tabela

    //Funcao que define o numero de segmentos a ser exibido por tela
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Funcao que define quantas celulas um segmento deve conter
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departments.count
    }

    //Funcao que distribui as informacoes contidas nos objetos do vetor "departments" em celulas da tabela
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cellIdentifier = "DepartmentTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DepartmentTableViewCell  else {
            fatalError("The dequeued cell is not an instance of DepartmentTableViewCell.")
        }
        
        let department = departments[indexPath.row]
        cell.name.text = department.name
        cell.photo.image = department.photo 
        cell.initials.text = department.initials
        
        return cell
    }
    
    // Funcao que retorna se um item pode ser editado ou nao
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Mark: Redirecionamento de ViewControllers
    
    //Funcao que atualiza a tabela e o vetor após o aplicativo retornar do DepartmentViewController atraves do botao "Save"
    @IBAction func unwindToDepartmentList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DepartmentViewController, let department = sourceViewController.department {
            department.initials = department.initials.uppercased()
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                departments[selectedIndexPath.row] = department
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                let newIndexPath = IndexPath(row: departments.count, section: 0)
                departments.append(department)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            departments = departments.sorted(by: {$0.name < $1.name})
            tableView.reloadData()
            saveDepartments()
        }
    }
    
    //Funcao que faz uma preparacao de acordo com o identificador da transicao ativada
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "addDepartment":
            os_log("Adding a new department.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let departmentDetailViewController = segue.destination as? DepartmentViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedDepartmentCell = sender as? DepartmentTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedDepartmentCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedDepartment = departments[indexPath.row]
            departmentDetailViewController.department = selectedDepartment
            
        case "showEmployees":
            guard let employeeListViewController = segue.destination as? EmployeeTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedDepartmentCell = sender as? DepartmentTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedDepartmentCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedDepartment = departments[indexPath.row]
            employeeListViewController.department = selectedDepartment
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    //Mark: Salvamento e carregamento de objetos
    
    //Funcao que carrega departamentos exemplo, caso nao exista nenhum
    private func loadSamples() {
        
        let photo1 = UIImage(named: "dep1")
        let photo2 = UIImage(named: "dep2")
        let photo3 = UIImage(named: "dep3")
        
        let dep1 = Department(name: "Tecnologia da informação", initials: "TI", photo: photo1)
        let dep2 = Department(name: "Finanças", initials: "F", photo: photo2)
        let dep3 = Department(name: "Publicidade e Propaganda", initials: "PP", photo: photo3)
        
        departments += [dep1, dep2, dep3]
    }
    
    //Funcao que salva o conteudo do vetor "departments"
    private func saveDepartments() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(departments, toFile: Department.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Departments successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save departments...", log: OSLog.default, type: .error)
        }
    }
    
    //Funcao que retorna um vetor de departamentos encontrados nos arquivos do aplicativo
    private func loadDepartments() -> [Department]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Department.ArchiveURL.path) as? [Department]
    }
    

    
    
    
}

