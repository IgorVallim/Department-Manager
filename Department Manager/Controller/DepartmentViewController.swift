//
//  DepartmentViewController.swift
//  Department Manager
//
//  Created by Igor Vallim on 12/10/2018.
//  Copyright © 2018 Igor Vallim. All rights reserved.
//

import os.log
import UIKit

class DepartmentViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    //Mark: Atributos do IB
    
    @IBOutlet weak var name: UITextField! //Campo de texto que recebe o nome do departamento
    @IBOutlet weak var photo: UIImageView! //ImageView que recebe a foto do departamento
    @IBOutlet weak var initials: UITextField! //Campo de texto que recebe a sigla do departamento
    @IBOutlet weak var saveButton: UIBarButtonItem! //Botao que salva as alteracoes/cria um novo departamento
    
    //Mark: Atributos
    
    var department: Department? //Armazena o departamento a ser alterado, se existir um
    
    //Mark: Funcoes da classe
    
    //Funcao que preenche os elementos de interface, de acordo com a existencia ou nao do atributo "department"
    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self
        initials.delegate = self
        if let department = department {
            navigationItem.title = department.name
            name.text = department.name
            photo.image = department.photo
            initials.text = department.initials
        }else{
            navigationItem.title = "Novo departamento"
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
    
    //Funcao que desabilita o botao de salvar enquanto um dos campos de texto estiver vazio
    private func updateSaveButtonState() {
        let text = name.text ?? ""
        let text2 = initials.text ?? ""
        saveButton.isEnabled = !text.isEmpty && !text2.isEmpty
    }
    
    //MARK: Selecao de imagem
    
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
        initials.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //Mark: Redirecionamento de ViewController
    
    //Funcao que cancela a adicao/edicao de departamentos, retornando para a tela inicial
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddDepartmentMode = presentingViewController is UINavigationController
        
        if isPresentingInAddDepartmentMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The DepartmentViewController is not inside a navigation controller.")
        }
    }
    
    //Funcao que salva o departamento, retornando ele para o ViewController inicial
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let nameDepart = name.text ?? ""
        let photoDepart = photo.image
        let initialsDepart = initials.text ?? ""
        if let _ = department {
            department = Department(name: nameDepart, id: (department?.id)!, initials: initialsDepart, photo: photoDepart)
        }else{
             department = Department(name: nameDepart, initials: initialsDepart, photo: photoDepart)
        }
       
    }

}
