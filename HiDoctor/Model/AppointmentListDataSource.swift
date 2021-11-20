//
//  AppointmentListDataSource.swift
//  HiDoctor
//
//  Created by Ameen Ahmed on 20/11/2021.
//

import UIKit

class AppointmentListDataSource: NSObject {
    private lazy var dateFormatter = RelativeDateTimeFormatter()
}



extension AppointmentListDataSource: UITableViewDataSource {
    static let appointmentListCellIdentifier = "AppointmentListCell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Appointment.testData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.appointmentListCellIdentifier, for: indexPath) as? AppointmentListCell else {
            fatalError("Unable to dequeue ReminderCell")
        }
        let appointment = Appointment.testData[indexPath.row]
        let dateText = dateFormatter.localizedString(for: appointment.dueDate, relativeTo: Date())
        cell.configure(title: appointment.title, dateText: dateText, isDone: appointment.isComplete) {

            Appointment.testData[indexPath.row].isComplete.toggle()
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        return cell
    }
}
