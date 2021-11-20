//
//  ViewController.swift
//  HiDoctor
//
//  Created by Ameen Ahmed on 19/11/2021.
//

import UIKit

class AppointmentListViewController: UITableViewController {
    
    private var appointmentListDataSource: AppointmentListDataSource?
    static let showDetailSegueIdentifier = "ShowAppointmentDetailSegue"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Self.showDetailSegueIdentifier,
           let destination = segue.destination as? AppointmentDetailViewController,
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            let appointment = Appointment.testData[indexPath.row]
            destination.configure(with: appointment)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appointmentListDataSource = AppointmentListDataSource()
        tableView.dataSource = appointmentListDataSource
    }
}


