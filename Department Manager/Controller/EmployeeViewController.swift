//
//  EmployeeViewController.swift
//  Dapartment Manager
//
//  Created by Igor Vallim on 13/10/2018.
//  Copyright © 2018 Igor Vallim. All rights reserved.
//

import UIKit
import os.log

class EmployeeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var rg: UITextField!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var employee: Employee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.delegate = self
        
        // Set up views if editing an existing Meal.
        if let employee = employee {
            navigationItem.title = employee.name
            name.text = employee.name
            photo.image = employee.photo
            rg.text = String(employee.rg)
        }else{
            navigationItem.title = "Novo funcionário"
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photo.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddEmployeeMode = presentingViewController is UINavigationController
        
        if isPresentingInAddEmployeeMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The EmployeeViewController is not inside a navigation controller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let nameEmp = name.text ?? ""
        let photoEmp = photo.image
        if let rgEmp: Int = Int(rg.text ?? "0"){
            if let id: Int = employee?.id{
                employee  = Employee(name: nameEmp, id: id, depId: 0, rg: rgEmp, photo: photoEmp)
            }else{
                employee  = Employee(name: nameEmp, depId: 0, rg: rgEmp, photo: photoEmp)
            }
        }else{
            let rgEmp = 0
            if let id: Int = employee?.id{
                employee  = Employee(name: nameEmp, id: id, depId: 0, rg: rgEmp, photo: photoEmp)
            }else{
                employee  = Employee(name: nameEmp, depId: 0, rg: rgEmp, photo: photoEmp)
            }
        }
        
        
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        
        
        
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        name.resignFirstResponder()
        rg.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = name.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

}
