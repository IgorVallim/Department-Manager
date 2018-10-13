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

    var departments = [Department]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem

        if let savedDepartments = loadDepartments() {
            departments += savedDepartments
        }
        else {
            // Load the sample data.
            loadSamples()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "DepartmentTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DepartmentTableViewCell  else {
            fatalError("The dequeued cell is not an instance of DepartmentTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let department = departments[indexPath.row]
        
        cell.name.text = department.name
        cell.photo.image = department.photo 
        cell.initials.text = department.initials
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            departments.remove(at: indexPath.row)
            //saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    @IBAction func unwindToDepartmentList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DepartmentViewController, let department = sourceViewController.department {
            department.id = departments[departments.count-1].id+1
            department.initials = department.initials.uppercased()
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                departments[selectedIndexPath.row] = department
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: departments.count, section: 0)
                
                departments.append(department)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the meals.
            saveDepartments()
        }
    }
    
    private func loadSamples() {
        
        let photo1 = UIImage(named: "dep1")
        let photo2 = UIImage(named: "dep2")
        let photo3 = UIImage(named: "dep3")
        
        let dep1 = Department(name: "Tecnologia da informação", id: 1, initials: "TI", photo: photo1)
        let dep2 = Department(name: "Finanças", id: 2, initials: "F", photo: photo2)
        let dep3 = Department(name: "Publicidade e Propaganda", id: 3, initials: "PP", photo: photo3)
        
        departments += [dep1, dep2, dep3]
    }
    
    private func saveDepartments() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(departments, toFile: Department.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Departments successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save departments...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadDepartments() -> [Department]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Department.ArchiveURL.path) as? [Department]
    }
    
    @IBAction func redirectToEmployee(_ sender: UIButton) {
            let storyboard = UIStoryboard(name: "Employee", bundle: nil)
            
            guard let employeeController = storyboard.instantiateInitialViewController() as? EmployeeTableViewController else {
                fatalError("Unable to get Employee as EmployeeTableViewController") }
            
        navigationController?.pushViewController(employeeController, animated: true)
    }
    
}

