//
//  EmployeeTableViewController.swift
//  Dapartment Manager
//
//  Created by Igor Vallim on 13/10/2018.
//  Copyright © 2018 Igor Vallim. All rights reserved.
//

import UIKit
import os.log

class EmployeeTableViewController: UITableViewController {

    //Mark: Atributos do IB
    
    @IBOutlet weak var employeesBar: UINavigationItem! //Barra de navegacao da secao "Funcionarios"
    
    //Mark: Atributos
    
    var employees = [Employee]() //Lista de todos os funcionario
    var department: Department? //Departamento selecionado em "DepartmentTableViewController"
    var depEmployees = [Employee]() //Lista de funcionarios do departamento selecionado
    
    ////Mark: Funcoes de classe
    
    //Funcao que inicializa os vetores "employees" e "depEmployees"
    override func viewDidLoad() {
        super.viewDidLoad()
        employeesBar.leftBarButtonItem = editButtonItem
        navigationItem.title = department?.initials
        if let savedEmployees = loadEmployees() {
            employees += savedEmployees
        }
        else {
            loadSamples()
        }
        depEmployees = employees.filter{$0.depId==department!.id}
        depEmployees = depEmployees.sorted(by: {$0.name < $1.name})
    }
    
    //Funcao que habilita a exclusao de itens da tabela
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let tempId = depEmployees[indexPath.row].id
            depEmployees.remove(at: indexPath.row)
            for i in 0..<employees.count{
                if tempId==employees[i].id{
                    employees.remove(at: i)
                    break
                }
            }
            saveEmployees()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //Mark: Exibicao da tabela

    //Funcao que define o numero de segmentos a ser exibido por tela
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //Funcao que define quantas celulas um segmento deve conter
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return depEmployees.count
    }
    
    //Funcao que distribui as informacoes contidas nos objetos do vetor "depEmployees" em celulas da tabela
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "EmployeeTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EmployeeTableViewCell  else {
            fatalError("The dequeued cell is not an instance of EmployeeTableViewCell.")
        }
        
        let employee = depEmployees[indexPath.row]
        cell.name.text = employee.name
        cell.photo.image = employee.photo
        cell.rg.text = String(employee.rg)
        
        return cell
    }
    
    //Mark: Redirecionamento de ViewControllers
    
    //Funcao que atualiza a tabela e os vetores após o aplicativo retornar do EmployeeViewController atraves do botao "Save"
    @IBAction func unwindEmployeeList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? EmployeeViewController, let employee = sourceViewController.employee {
            employee.depId = department!.id
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                for i in 0..<employees.count{
                    if employee.id==employees[i].id{
                        employees[i] = employee
                    }
                }
                depEmployees[selectedIndexPath.row] = employee
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                let newIndexPath = IndexPath(row: depEmployees.count, section: 0)
                
                employees.append(employee)
                depEmployees.append(employee)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            tableView.reloadData()
            depEmployees = depEmployees.sorted(by: {$0.name < $1.name})
            saveEmployees()
        }
    }
    
    //Funcao que faz uma preparacao de acordo com o identificador da transicao ativada
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "addEmployee":
            os_log("Adding a new employee.", log: OSLog.default, type: .debug)
            
        case "showDetail":
            guard let employeeDetailViewController = segue.destination as? EmployeeViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedEmployeeCell = sender as? EmployeeTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedEmployeeCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedEmployee = depEmployees[indexPath.row]
            employeeDetailViewController.employee = selectedEmployee
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    //Mark: Salvamento e carregamento de objetos
    
    //Funcao que carrega funcionarios exemplo, caso nao exista nenhum
    private func loadSamples() {
        
        let photo1 = UIImage(named: "emp1")
        let photo2 = UIImage(named: "emp2")
        let photo3 = UIImage(named: "emp3")
        
        let emp1  = Employee(name: "Robson", depId: 1, rg: 123456789, photo: photo1)
        let emp2  = Employee(name: "Daniela", depId: 2, rg: 987654321, photo: photo2)
        let emp3  = Employee(name: "Camila", depId: 3, rg: 012345678, photo: photo3)
        
        employees += [emp1, emp2, emp3]
    }
    
    //Funcao que salva o conteudo do vetor "employees"
    private func saveEmployees() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(employees, toFile: Employee.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Employees successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save employees...", log: OSLog.default, type: .error)
        }
    }
    
    //Funcao que retorna um vetor de funcionarios encontrados nos arquivos do aplicativo
    private func loadEmployees() -> [Employee]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Employee.ArchiveURL.path) as? [Employee]
    }
    
  
    
   

}
