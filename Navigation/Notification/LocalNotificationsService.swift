//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Роман Лешин on 26.11.2024.
//

import UIKit
import UserNotifications

class LocalNotificationService: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "Прочитать" {
            print("Пользователь выбрал действие: Отметить как прочитанное")
        }
        
        completionHandler()
    }
    
    func registerUpdatesCategory() {
        let center = UNUserNotificationCenter.current()
        
        let markAsReadAction = UNNotificationAction(
            identifier: "Прочитать",
            title: "Отметить как прочитанное",
            options: []
        )
        
        let updatesCategory = UNNotificationCategory(
            identifier: "updates",
            actions: [markAsReadAction],
            intentIdentifiers: [],
            options: []
        )
        
        center.setNotificationCategories([updatesCategory])
    }
    
    func registeForLatestUpdatesIfPossible() {
        registerUpdatesCategory()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Ошибка при запросе разрешения на уведомления: \(error.localizedDescription)")
                return
            }
            if granted {
                let content = UNMutableNotificationContent()
                
                content.title = "Добрый вечер!"
                content.body = "Посмотрите последние обновления"
                content.sound = .default
                content.categoryIdentifier = "updates"
                
                var dateComponents = DateComponents()
                dateComponents.hour = 19
                dateComponents.minute = 0
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request)
            }
            else {
                print("Доступ не получен")
            }
        }
        
    }
}
