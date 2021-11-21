//
//  AppointmentDetailEditDataSource.swift
//  HiDoctor
//
//  Created by Ameen Ahmed on 20/11/2021.
//

import UIKit

class AppointmentDetailEditDataSource: NSObject {
    typealias AppointmentChangeAction = (Appointment) -> Void
    
    enum AppointmentSection: Int, CaseIterable {
        case title
        case dueDate
        case notes
        
        var displayText: String {
            switch self {
            case .title:
                return "Title"
            case .dueDate:
                return "Date"
            case .notes:
                return "Notes"
            }
        }
        
        
        var numRows: Int {
            switch self {
            case .title, .notes: return 1
            case .dueDate: return 2
            }
        }
        
        
        
        func cellIdentifier(for row: Int) -> String {
            switch self {
            case .title:
                return "EditTitleCell"
            case .dueDate:
                return row == 0 ? "EditDateLabelCell" : "EditDateCell"
            case .notes:
                return "EditNotesCell"
            }
        }
    }
    
    
    
    static var dateLabelCellIdentifier: String {
        return AppointmentSection.dueDate.cellIdentifier(for: 0)
    }
    
    
    var appointment: Appointment
    private var appointmentChangeAction: AppointmentChangeAction?
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }()
    
    init(appointment: Appointment, changeAction: @escaping AppointmentChangeAction) {
        self.appointment = appointment
        self.appointmentChangeAction = changeAction
    }
    
    
    private func dequeueAndConfigureCell(for indexPath: IndexPath, from tableView: UITableView) -> UITableViewCell {
        guard let section = AppointmentSection(rawValue: indexPath.section) else {
            fatalError("Section index out of range")
        }
        let identifier = section.cellIdentifier(for: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        switch section {
        case .title:
            if let titleCell = cell as? EditTitleCell {
                titleCell.configure(title: appointment.title) { title in
                    self.appointment.title = title
                    self.appointmentChangeAction?(self.appointment)
                }
            }
        case .dueDate:
            if indexPath.row == 0 {
                cell.textLabel?.text = formatter.string(from: appointment.dueDate)
            } else {
                if let dueDateCell = cell as? EditDateCell {
                    dueDateCell.configure(date: appointment.dueDate) { date in
                        self.appointment.dueDate = date
                        self.appointmentChangeAction?(self.appointment)
                        let indexPath = IndexPath(row: 0, section: section.rawValue)
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        case .notes:
            if let notesCell = cell as? EditNotesCell {
                notesCell.configure(notes: appointment.notes) { notes in
                    self.appointment.notes = notes
                    self.appointmentChangeAction?(self.appointment)
                }
            }
        }
        return cell
    }
}



extension AppointmentDetailEditDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return AppointmentSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppointmentSection(rawValue: section)?.numRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dequeueAndConfigureCell(for: indexPath, from: tableView)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = AppointmentSection(rawValue: section) else {
            fatalError("Section index out of range")
        }
        return section.displayText
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
