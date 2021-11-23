//
//  ViewController.swift
//  HiDoctor
//
//  Created by Ameen Ahmed on 19/11/2021.
//

import UIKit
import UserNotifications

class AppointmentListViewController: UITableViewController {
    
    @IBOutlet var filterSegmentedControl: UISegmentedControl!
    
    private var appointmentListDataSource: AppointmentListDataSource?
    static let showDetailSegueIdentifier = "ShowAppointmentDetailSegue"
    static let mainStoryboardName = "Main"
    static let detailViewControllerIdentifier = "AppointmentDetailViewController"
    private var filter: AppointmentListDataSource.Filter {
        return AppointmentListDataSource.Filter(rawValue: filterSegmentedControl.selectedSegmentIndex) ?? .today
    }
    
    var appointmentWith: String = ""
    var date: Date = Date()
    var id: String = ""
    
    
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
                self.tableView.reloadData()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNotifications()
        appointmentListDataSource = AppointmentListDataSource(appointmentCompletedAction: { appointmentIndex in
            self.tableView.reloadRows(at: [IndexPath(row: appointmentIndex, section: 0)], with: .automatic)
        })
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
    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        appointmentListDataSource?.filter = filter
        tableView.reloadData()
    }
    
    
     func addAppointment() {
        let storyboard = UIStoryboard(name: Self.mainStoryboardName, bundle: nil)
        let detailViewController: AppointmentDetailViewController = storyboard.instantiateViewController(identifier: Self.detailViewControllerIdentifier)
        let appointment = Appointment(id: UUID().uuidString, title: "New Appointment", dueDate: Date())
        detailViewController.configure(with: appointment, isNew: true, addAction: { appointment in
            if let index = self.appointmentListDataSource?.add(appointment) {
                self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        })
        let navigationController = UINavigationController(rootViewController: detailViewController)
        present(navigationController, animated: true, completion: nil)
        
         appointmentWith = appointment.title
         date = appointment.dueDate
         id = appointment.id
    }
    
    func getNotifications() {
        
        let notificationCentre = UNUserNotificationCenter.current()
        notificationCentre.requestAuthorization(options: [.alert, .sound]) { (accessGranted, error) in
            
        }

        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Appointment"
        notificationContent.body = "You have an Appointment with this \(appointmentWith) person"
        
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .month, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        
        let request = UNNotificationRequest(identifier: id, content: notificationContent, trigger: trigger)
        
        notificationCentre.add(request) { (error) in
           
        }
    }
}


// Resources:
// developer.apple.com/documentation
// codewithchris
