//
//  AppointmentDetailViewController.swift
//  HiDoctor
//
//  Created by Ameen Ahmed on 20/11/2021.
//

import UIKit

class AppointmentDetailViewController: UITableViewController {
    typealias AppointmentChangeAction = (Appointment) -> Void
    
    private var appointment: Appointment?
    private var tempAppointment: Appointment?
    private var dataSource: UITableViewDataSource?
    private var appointmentChangeAction: AppointmentChangeAction?

    func configure(with appointment: Appointment, changeAction: @escaping AppointmentChangeAction) {
        self.appointment = appointment
        self.appointmentChangeAction = changeAction
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEditing(false, animated: false)
        navigationItem.setRightBarButton(editButtonItem, animated: false)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: AppointmentDetailEditDataSource.dateLabelCellIdentifier)

    }
    
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        guard let appointment = appointment else {
            fatalError("No Appointment found for detail view")
        }
        
        if editing {
            dataSource = AppointmentDetailEditDataSource(appointment: appointment) { appointment in
                self.tempAppointment = appointment
                self.editButtonItem.isEnabled = true
            }
            navigationItem.title = NSLocalizedString("Edit Appointment", comment: "Edit appointment nav title")
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTrigger))

          } else {
              if let tempAppointment = tempAppointment {
                  self.appointment = tempAppointment
                  self.tempAppointment = nil
                  appointmentChangeAction?(tempAppointment)
                  dataSource = AppointmentDetailViewDataSource(appointment: tempAppointment)
              } else {
                  dataSource = AppointmentDetailViewDataSource(appointment: appointment)
              }
              navigationItem.title = NSLocalizedString("View Appointment", comment: "View appointment nav title")
              navigationItem.leftBarButtonItem = nil
              editButtonItem.isEnabled = true
          }
          tableView.dataSource = dataSource
          tableView.reloadData()
    }
    
    @objc
    func cancelButtonTrigger() {
        setEditing(false, animated: true)
    }
}




