//
//  AppointmentListCell.swift
//  HiDoctor
//
//  Created by Ameen Ahmed on 20/11/2021.
//

import UIKit

class AppointmentListCell: UITableViewCell {
    
    typealias DoneButtonAction = () -> Void
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    
    var doneActionButton: DoneButtonAction?
    
    
    @IBAction func doneButtonTriggered(_ sender: UIButton) {
        doneActionButton?()
    }
}
