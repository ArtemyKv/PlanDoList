//
//  NotificationManager.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 04.04.2023.
//

import Foundation
import UserNotifications

protocol NotificationManagerProtocol: AnyObject {
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func scheduleNotification(name: String, remindDate: Date, id: String)
    func removeScheduledNotification(id: String)
}

class NotificationManager: NotificationManagerProtocol {
    let notificationCenter = UNUserNotificationCenter.current()
    
    init() {
        //TODO: Move request to start onboarding screen
        requestAuthorization()
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void = { _ in }) {
        notificationCenter.requestAuthorization(options: [.sound, .badge, .alert]) { granted, _ in
            completion(granted)
        }
    }
    
    func scheduleNotification(name: String, remindDate: Date, id: String) {
        let content = UNMutableNotificationContent()
        content.title = "PlanDo List"
        content.body = "Reminder: \(name)"
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: remindDate), repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            guard let error else { return }
            print("Scheduling error: \(error), \(error.localizedDescription)")
        }
    }
    
    func removeScheduledNotification(id: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    
}
