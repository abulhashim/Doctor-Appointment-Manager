//
//  AppointmentDetailViewDataSource.swift
//  HiDoctor
//
//  Created by Ameen Ahmed on 20/11/2021.
//

import UIKit

class AppointmentDetailViewDataSource: NSObject {
    enum AppointmentRow: Int, CaseIterable {
        case title
        case date
        case time
        case notes
        
        
        static let timeFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            return formatter
        }()
        
        static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .long
            return formatter
        }()
        
        
        
        
        func displayText(for appointment: Appointment?) -> String? {
            switch self {
            case .title:
                return appointment?.title
            case .date:
                guard let date = appointment?.dueDate else { return nil }
                if Locale.current.calendar.isDateInToday(date) {
                    return NSLocalizedString("Today", comment: "Today for date description")
                }
                return Self.dateFormatter.string(from: date)
            case .time:
                guard let date = appointment?.dueDate else { return nil }
                return Self.timeFormatter.string(from: date)
            case .notes:
                return appointment?.notes
            }
        }
        
        var cellImage: UIImage? {
            switch self {
            case .title:
                return nil
            case .date:
                return UIImage(systemName: "calendar.circle")
            case .time:
                return UIImage(systemName: "clock")
            case .notes:
                return UIImage(systemName: "square.and.pencil")
            }
        }
    }
    
    private var appointment: Appointment

    init(appointment: Appointment) {
        self.appointment = appointment
        super.init()
    }
}



extension AppointmentDetailViewDataSource: UITableViewDataSource {
    static let appointmentDetailCellIdentifier = "AppointmentDetailCell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppointmentRow.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.appointmentDetailCellIdentifier, for: indexPath)
        let row = AppointmentRow(rawValue: indexPath.row)
        cell.textLabel?.text = row?.displayText(for: appointment)
        cell.imageView?.image = row?.cellImage
        return cell
    }
}
