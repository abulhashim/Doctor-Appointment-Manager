//
//  AppointmentDetailViewController.swift
//  HiDoctor
//
//  Created by Ameen Ahmed on 20/11/2021.
//

import UIKit

class AppointmentDetailViewController: UITableViewController {
    
    private var appointment: Appointment?
    private var detailViewDataSource: AppointmentDetailViewDataSource?

    func configure(with appointment: Appointment) {
        self.appointment = appointment
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appointment = appointment else {
            fatalError("No reminder found for detail view")
        }
        detailViewDataSource = AppointmentDetailViewDataSource(appointment: appointment)
        tableView.dataSource = detailViewDataSource
    }
}




