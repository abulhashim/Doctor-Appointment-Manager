//
//  AppointmentReminder.swift
//  HiDoctor
//
//  Created by Ameen Ahmed on 20/11/2021.
//

import Foundation

struct Appointment {
    var id: String
    var title: String
    var dueDate: Date
    var notes: String? = nil
    var isComplete: Bool = false
}

extension Appointment {
    static var testData = [
        Appointment(id: UUID().uuidString, title: "Mr. Zaid", dueDate: Date().addingTimeInterval(800.0), notes: ""),
        Appointment(id: UUID().uuidString, title: "Mr. Amar", dueDate: Date().addingTimeInterval(14000.0), notes: "", isComplete: true),
        Appointment(id: UUID().uuidString, title: "Mr. Ubaid", dueDate: Date().addingTimeInterval(24000.0), notes: ""),
        Appointment(id: UUID().uuidString, title: "Mr. Khalid", dueDate: Date().addingTimeInterval(3200.0), notes: "", isComplete: true),
        Appointment(id: UUID().uuidString, title: "Mr. Hamza", dueDate: Date().addingTimeInterval(60000.0), notes: ""),
        Appointment(id: UUID().uuidString, title: "Mr. Kashif", dueDate: Date().addingTimeInterval(72000.0), notes: ""),
        Appointment(id: UUID().uuidString, title: "Mr. Bilal", dueDate: Date().addingTimeInterval(83000.0), notes: ""),
        Appointment(id: UUID().uuidString, title: "Mr. Zain", dueDate: Date().addingTimeInterval(92500.0), notes: ""),
        Appointment(id: UUID().uuidString, title: "Mr. Faiz", dueDate: Date().addingTimeInterval(101000.0),  notes: "")
    ]
}
