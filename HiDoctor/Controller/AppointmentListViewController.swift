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
            let rowIndex = indexPath.row
             guard let appointment = appointmentListDataSource?.appointment(at: rowIndex) else {
                 fatalError("Couldn't find data source for appointment list.")
             }
            destination.configure(with: appointment) { appointment in
                self.appointmentListDataSource?.update(appointment, at: rowIndex)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appointmentListDataSource = AppointmentListDataSource()
        tableView.dataSource = appointmentListDataSource
    }
}


