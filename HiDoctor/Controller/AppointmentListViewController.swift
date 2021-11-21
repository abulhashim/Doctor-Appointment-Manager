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
    static let mainStoryboardName = "Main"
    static let detailViewControllerIdentifier = "AppointmentDetailViewController"
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Self.showDetailSegueIdentifier,
           let destination = segue.destination as? AppointmentDetailViewController,
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            let rowIndex = indexPath.row
             guard let appointment = appointmentListDataSource?.appointment(at: rowIndex) else {
                 fatalError("Couldn't find data source for appointment list.")
             }

            destination.configure(with: appointment, editAction: { appointment in
                self.appointmentListDataSource?.update(appointment, at: rowIndex)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appointmentListDataSource = AppointmentListDataSource()
        tableView.dataSource = appointmentListDataSource
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navigationController = navigationController,
           navigationController.isToolbarHidden {
            navigationController.setToolbarHidden(false, animated: animated)
        }
    }
    
    @IBAction func addButtonTriggered(_ sender: UIBarButtonItem) {
        addAppointment()
    }
    
    private func addAppointment() {
        let storyboard = UIStoryboard(name: Self.mainStoryboardName, bundle: nil)
        let detailViewController: AppointmentDetailViewController = storyboard.instantiateViewController(identifier: Self.detailViewControllerIdentifier)
        let appointment = Appointment(title: "New Appointment", dueDate: Date())
        detailViewController.configure(with: appointment, isNew: true, addAction: { appointment in
            self.appointmentListDataSource?.add(appointment)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)

        })
        let navigationController = UINavigationController(rootViewController: detailViewController)
        present(navigationController, animated: true, completion: nil)
    }
}


