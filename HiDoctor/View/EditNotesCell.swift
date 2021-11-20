//
//  EditNotesCell.swift
//  HiDoctor
//
//  Created by Ameen Ahmed on 20/11/2021.
//

import UIKit

class EditNotesCell: UITableViewCell {
    
    @IBOutlet var notesTextView: UITextField!
    

    func configure(notes: String?) {
        notesTextView.text = notes
    }
}
