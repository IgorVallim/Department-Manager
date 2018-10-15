//
//  EmployeeViewController.swift
//  Department Manager
//
//  Created by Igor Vallim on 13/10/2018.
//  Copyright © 2018 Igor Vallim. All rights reserved.
//

import UIKit
import os.log

class EmployeeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //Mark: Atributos do IB
    
    @IBOutlet weak var name: UITextField! //Campo de texto que recebe o nome do funcionario
    @IBOutlet weak var rg: UITextField! //Campo de texto que recebe o RG do funcionario
    @IBOutlet weak var photo: UIImageView! //ImageView que recebe a foto do funcionario
    @IBOutlet weak var saveButton: UIBarButtonItem! //otao que salva as alteracoes/cria um novo funcionario
    
    //Mark: Atributos
    
    var employee: Employee? ///Armazena o funcionario a ser alterado, se existir um
    
    //Mark: Funcoes da classe
    
    //Funcao que preenche os elementos de interface, de acordo com a existencia ou nao do atributo "employee"
    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self
        rg.delegate = self
        if let employee = employee {
            navigationItem.title = employee.name
            name.text = employee.name
            photo.image = employee.photo
            rg.text = String(employee.rg)
        }else{
            navigationItem.title = "Novo funcionário"
            saveButton.isEnabled = false
        }
        updateSaveButtonState()
        
    }
    
    //Funcao que desabilita o botao de salvar enquanto o usuario estiver editando um campo de texto
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    //Funcao que esconde o teclado quando o usuario tecla "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Funcao que habilita o botao de salvar quando o usuario preenche um campo
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = name.text
    }
    
    //Funcao que desabilita o botao de salvar enquanto um dos campos de texto estiver vazio ou o RG for invalido
    private func updateSaveButtonState() {
        let text = name.text ?? ""
        if let _: Int = Int(rg.text ?? ""), !text.isEmpty, rg.text?.count == 9{
            saveButton.isEnabled = true
        }
        
    }
    
    //MARK: Selecao de imagenm
    
    //Funcao que fecha o selecionador de imagens se o cancelar
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Funcao que configura o ImageView de acordo com a imagem selecionada
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        photo.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    //Funcao que abre a galeria de imagens do celular
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {

        name.resignFirstResponder()
        rg.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //Mark: Redirecionamento de ViewController
    
    //Funcao que cancela a adicao/edicao de departamentos, retornando para a tela inicial
    @IBAction func cancel(_ sender: UIBarButtonItem) {
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
    
    //Funcao que salva o departamento, retornando ele para o ViewController inicial
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let nameEmp = name.text ?? ""
        let photoEmp = photo.image
        let rgEmp = Int(rg.text!)
            if let id: Int = employee?.id{
                employee  = Employee(name: nameEmp, id: id, depId: 0, rg: rgEmp!, photo: photoEmp)
            }else{
                employee  = Employee(name: nameEmp, depId: 0, rg: rgEmp!, photo: photoEmp)
            }
        
    }
    
    
    

}
