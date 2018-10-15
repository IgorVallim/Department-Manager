//
//  EmployeeTableViewCell.swift
//  Department Manager
//
//  Created by Igor Vallim on 13/10/2018.
//  Copyright © 2018 Igor Vallim. All rights reserved.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    //Mark: Atributos do IB
    
    @IBOutlet weak var photo: UIImageView! //ImageView contendo a foto do funcionário
    @IBOutlet weak var name: UILabel! //Label contendo o nome do funcionario
    @IBOutlet weak var rg: UILabel! //Label contendo o RG do funcionario
    
    
    //Mark: Funcoes da classe
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
