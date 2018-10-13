//
//  EmployeeTableViewController.swift
//  Dapartment Manager
//
//  Created by Igor Vallim on 13/10/2018.
//  Copyright © 2018 Igor Vallim. All rights reserved.
//

import UIKit

class EmployeeTableViewController: UITableViewController {

    var employees = [Employee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSamples()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "EmployeeTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EmployeeTableViewCell  else {
            fatalError("The dequeued cell is not an instance of EmployeeTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let employee = employees[indexPath.row]
        
        cell.name.text = employee.name
        cell.photo.image = employee.photo
        cell.rg.text = String(employee.rg)
        
        return cell
    }
    
    @IBAction func unwindEmployeeList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? EmployeeViewController, let employee = sourceViewController.employee {
            employee.id = employees[employees.count-1].id+1
            //arrumar id do departamento e validar rg
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                employees[selectedIndexPath.row] = employee
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: employees.count, section: 0)
                
                employees.append(employee)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the meals.
            //saveDepartments()
        }
    }
    
    private func loadSamples() {
        
        let photo1 = UIImage(named: "emp1")
        let photo2 = UIImage(named: "emp2")
        let photo3 = UIImage(named: "emp3")
        
        let emp1  = Employee(name: "Robson", id: 1, depId: 1, rg: 123456789, photo: photo1)
        let emp2  = Employee(name: "Daniela", id: 2, depId: 1, rg: 987654321, photo: photo2)
        let emp3  = Employee(name: "Camila", id: 3, depId: 1, rg: 012345678, photo: photo3)
        
        employees += [emp1, emp2, emp3]
    }

}
