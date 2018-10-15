//
//  DepartmentTableViewCell.swift
//  Department Manager
//
//  Created by Igor Vallim on 12/10/2018.
//  Copyright © 2018 Igor Vallim. All rights reserved.
//

import UIKit

class DepartmentTableViewCell: UITableViewCell {

    //Mark: Atributos do IB
    
    @IBOutlet weak var photo: UIImageView! //ImageView contendo a imagem do departamento
    @IBOutlet weak var name: UILabel! //Campo de texto contendo o nome do departamento
    @IBOutlet weak var initials: UILabel! //Campo de texto contendo a sigla do departamento
    
    //Mark: Funcoes da classe
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
