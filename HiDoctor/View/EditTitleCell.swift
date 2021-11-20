//
//  EditTitleCell.swift
//  HiDoctor
//
//  Created by Ameen Ahmed on 20/11/2021.
//

import UIKit

class EditTitleCell: UITableViewCell {
    @IBOutlet var titleTextField: UITextField!

    func configure(title: String) {
        titleTextField.text = title
    }

}
