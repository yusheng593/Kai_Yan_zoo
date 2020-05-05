//
//  AppDelegate.swift
//  Kai Yan Zoo
//
//  Created by yusheng Lu on 2020/3/10.
//  Copyright © 2020 YushengLu. All rights reserved.
//

import UIKit
import UserNotifications//通知套件

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // 在程式一啟動即詢問使用者是否接受圖文(alert)、聲音(sound)、數字(badge)三種類型的通知
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                //self.sendNotificatin()
                DispatchQueue.main.async {
                    let VC = ViewController()
                    VC.sendNotificatin()
                }
                print("允許推播")
            } else {
                print("未允許推播")
            }
        }
        //設定 AppDelegate 去代理 UNUserNotificationCenterDelegate。
        //才能在前景接受通知
        center.delegate = self
        return true
    }
    //在應用程式將要進入前臺時
    func applicationWillEnterForeground(_ application: UIApplication) {
        //將小點數字清除
        application.applicationIconBadgeNumber = 0
    }
    //應用程式將要由活動狀態切換到非活動狀態時
    func applicationWillResignActive(_ application: UIApplication) {
        //將小點數字清除
        application.applicationIconBadgeNumber = 0
    }
    // 點擊通知觸發的事件
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let content: UNNotificationContent = response.notification.request.content
        completionHandler()
        // 取出userInfo的link並開啟
        let requestUrl = URL(string: content.userInfo["link"] as! String)
        UIApplication.shared.open(requestUrl!, options: [:], completionHandler: nil)
    }
    // 在前景收到通知時所觸發的 function
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .alert])
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

