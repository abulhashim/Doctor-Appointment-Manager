//
//  AppointmentListDataSource.swift
//  HiDoctor
//
//  Created by Ameen Ahmed on 20/11/2021.
//

import UIKit

class AppointmentListDataSource: NSObject {
    private lazy var dateFormatter = RelativeDateTimeFormatter()
    
    enum Filter: Int {
        case today
        case future
        case all
    
        func shouldInclude(date: Date) -> Bool {
            let isInToday = Locale.current.calendar.isDateInToday(date)
            switch self {
            case .today:
                return isInToday
            case .future:
                return (date > Date()) && !isInToday
            case .all:
                return true
            }
        }
    }
    
    var filter: Filter = .today
    
    var filteredAppointments: [Appointment] {
        return Appointment.testData.filter { filter.shouldInclude(date: $0.dueDate) }.sorted { $0.dueDate < $1.dueDate }
     }
    
    
    func update(_ appointment: Appointment, at row: Int) {
        Appointment.testData[row] = appointment
    }

    
    func appointment(at row: Int) -> Appointment {
        return filteredAppointments[row]
    }
    
    
    func add(_ appointment: Appointment) {
        Appointment.testData.insert(appointment, at: 0)
    }
}



extension AppointmentListDataSource: UITableViewDataSource {
    static let appointmentListCellIdentifier = "AppointmentListCell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAppointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.appointmentListCellIdentifier, for: indexPath) as? AppointmentListCell else {
            fatalError("Unable to dequeue ReminderCell")
        }
        let currentAppointment = Appointment.testData[indexPath.row]
        let dateText = currentAppointment.dueDateTimeText(for: filter)
        cell.configure(title: currentAppointment.title, dateText: dateText, isDone: currentAppointment.isComplete) {

            Appointment.testData[indexPath.row].isComplete.toggle()
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        return cell
    }
}



extension Appointment {
    
    static let timeFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        return timeFormatter
    }()
    
    static let futureDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    static let todayDateFormatter: DateFormatter = {
         let format = NSLocalizedString("'Today at '%@", comment: "format string for dates occurring today")
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = String(format: format, "hh:mm a")
         return dateFormatter
     }()
    
    func dueDateTimeText(for filter: AppointmentListDataSource.Filter) -> String {
        let isInToday = Locale.current.calendar.isDateInToday(dueDate)
        switch filter {
        case .today:
            return Self.timeFormatter.string(from: dueDate)
        case .future:
            return Self.futureDateFormatter.string(from: dueDate)
        case .all:
            if isInToday {
                return Self.todayDateFormatter.string(from: dueDate)
            } else {
                return Self.futureDateFormatter.string(from: dueDate)
            }
        }
    }
    
}
