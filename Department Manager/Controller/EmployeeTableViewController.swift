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

    var employees = [Employee]()
    var department: Department?
    var depEmployees = [Employee]()
    @IBOutlet weak var employeesBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        employeesBar.leftBarButtonItem = editButtonItem
        navigationItem.title = department?.initials
        if let savedEmployees = loadEmployees() {
            employees += savedEmployees
        }
        else {
            // Load the sample data.
            loadSamples()
        }
        depEmployees = employees.filter{$0.depId==department!.id}
        depEmployees = depEmployees.sorted(by: {$0.name < $1.name})
        
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return depEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "EmployeeTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EmployeeTableViewCell  else {
            fatalError("The dequeued cell is not an instance of EmployeeTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.

        
        let employee = depEmployees[indexPath.row]
        
        
        cell.name.text = employee.name
        cell.photo.image = employee.photo
        cell.rg.text = String(employee.rg)
        
        return cell
    }
    
    @IBAction func unwindEmployeeList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? EmployeeViewController, let employee = sourceViewController.employee {
            //TODO: arrumar o rg
            employee.depId = department!.id
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                for i in 0..<employees.count{
                    if employee.id==employees[i].id{
                        print(employees[i].name)
                        employees[i] = employee
                        print(employees[i].name)
                    }
                }
                depEmployees[selectedIndexPath.row] = employee
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: depEmployees.count, section: 0)
                
                employees.append(employee)
                depEmployees.append(employee)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            tableView.reloadData()
            depEmployees = depEmployees.sorted(by: {$0.name < $1.name})
            // Save the meals.
            saveEmployees()
        }
    }
    
    private func loadSamples() {
        
        let photo1 = UIImage(named: "emp1")
        let photo2 = UIImage(named: "emp2")
        let photo3 = UIImage(named: "emp3")
        
        let emp1  = Employee(name: "Robson", depId: 1, rg: 123456789, photo: photo1)
        let emp2  = Employee(name: "Daniela", depId: 2, rg: 987654321, photo: photo2)
        let emp3  = Employee(name: "Camila", depId: 3, rg: 012345678, photo: photo3)
        
        employees += [emp1, emp2, emp3]
    }
    
    private func saveEmployees() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(employees, toFile: Employee.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Employees successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save employees...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadEmployees() -> [Employee]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Employee.ArchiveURL.path) as? [Employee]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "addEmployee":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "showDetail":
            guard let mealDetailViewController = segue.destination as? EmployeeViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? EmployeeTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = depEmployees[indexPath.row]
            mealDetailViewController.employee = selectedMeal
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

}
