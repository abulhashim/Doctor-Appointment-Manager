//
//  AppointmentDetailViewController.swift
//  HiDoctor
//
//  Created by Ameen Ahmed on 20/11/2021.
//

import UIKit
import UserNotifications

class AppointmentDetailViewController: UITableViewController {
    
    typealias AppointmentChangeAction = (Appointment) -> Void
    
    private var appointment: Appointment?
    private var tempAppointment: Appointment?
    private var dataSource: UITableViewDataSource?
    private var appointmentEditAction: AppointmentChangeAction?
    private var appointmentAddAction: AppointmentChangeAction?
    private var isNew = false

    func configure(with appointment: Appointment, isNew: Bool = false, addAction: AppointmentChangeAction? = nil, editAction: AppointmentChangeAction? = nil) {
        self.appointment = appointment
        self.isNew = isNew
        self.appointmentAddAction = addAction
        self.appointmentEditAction = editAction
        if isViewLoaded {
            setEditing(isNew, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNotifications()
        setEditing(isNew, animated: false)
        navigationItem.setRightBarButton(editButtonItem, animated: false)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: AppointmentDetailEditDataSource.dateLabelCellIdentifier)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navigationController = navigationController,
           !navigationController.isToolbarHidden {
            navigationController.setToolbarHidden(true, animated: animated)
        }
    }
    
    
    
    fileprivate func transitionToViewMode(_ appointment: Appointment) {
        if isNew {
            let addAppointment = tempAppointment ?? appointment
            dismiss(animated: true) {
                self.appointmentAddAction?(addAppointment)
            }
            return
        }
        if let tempAppointment = tempAppointment {
            self.appointment = tempAppointment
            self.tempAppointment = nil
            appointmentEditAction?(tempAppointment)
            dataSource = AppointmentDetailViewDataSource(appointment: tempAppointment)
        } else {
            dataSource = AppointmentDetailViewDataSource(appointment: appointment)
        }
        navigationItem.title = NSLocalizedString("View Appointment", comment: "View appointment nav title")
        navigationItem.leftBarButtonItem = nil
        editButtonItem.isEnabled = true
    }
    
    fileprivate func transitionToEditMode(_ appointment: Appointment) {
        dataSource = AppointmentDetailEditDataSource(appointment: appointment) { appointment in
            self.tempAppointment = appointment
            self.editButtonItem.isEnabled = true
        }
        navigationItem.title = isNew ? NSLocalizedString("Add Appointment", comment: "add appointment nav title") :
        NSLocalizedString("Edit Appointment", comment: "edit appointment nav title")
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTrigger))
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        guard let appointment = appointment else {
            fatalError("No Appointment found for detail view")
        }
        if editing {
            transitionToEditMode(appointment)
          } else {
              transitionToViewMode(appointment)
          }
          tableView.dataSource = dataSource
          tableView.reloadData()
    }
    
    @objc
    func cancelButtonTrigger() {
        if isNew {
            dismiss(animated: true, completion: nil)
        } else {
            tempAppointment = nil
            setEditing(false, animated: true)
        }
    }
}

extension AppointmentDetailViewController {
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isEditing {
            guard let editSection = AppointmentDetailEditDataSource.AppointmentSection(rawValue: indexPath.section) else {
                return
            }
            if editSection == .dueDate, indexPath.row == 0 {
                cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            }
        } else {
            cell.backgroundColor = .systemBackground
            guard let viewRow = AppointmentDetailViewDataSource.AppointmentRow(rawValue: indexPath.row) else {
                return
            }
            if viewRow == .title {
                cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
            } else {
                cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            }
        }
    }
    
    func getNotifications() {
        
        // Ask for Permission:
        
        let notificationCentre = UNUserNotificationCenter.current()
        notificationCentre.requestAuthorization(options: [.alert, .sound]) { (accessGranted, error) in
            // Later
        }
        
        // Create a notification content:
        
        let appointmentWith = "Zaid"
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Appointment"
        notificationContent.body = "You have an Appointment with this \(appointmentWith) person after 2 minutes"
        
        // Trigger:
        
        let date = Date().addingTimeInterval(5)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .month, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        
        // Create Request:
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: notificationContent, trigger: trigger)
        
        // Register with NotificationCentre:
        notificationCentre.add(request) { (error) in
            // Later
        }
    }

}


