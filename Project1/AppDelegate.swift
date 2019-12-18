//
//  AppDelegate.swift
//  Project1
//
//  Created by Yujin Robot on 02/05/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var nvc = UINavigationController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        // Override point for customization after application launch.
        //        self.window = UIWindow(frame: UIScreen.main.bounds)
        //
        //        // 스토리보드 인스턴스
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        // 뷰 컨트롤러 인스턴스
        //        let viewController = storyboard.instantiateViewController(withIdentifier: "LogInView")
        //        // 윈도우의 루트 뷰 컨트롤러 설정
        //        self.window?.rootViewController = viewController
        //        // 이제 화면에 보여주자.
        //        self.window?.makeKeyAndVisible()
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func changeRootVCToSWRevealVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomVC = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
        nvc = UINavigationController(rootViewController: welcomVC)
        nvc.setNavigationBarHidden(true, animated: false)
        self.window?.rootViewController = nvc
        window?.makeKeyAndVisible()
    }
    
    func backToRootLoginVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LogInView")
        nvc = UINavigationController(rootViewController: vc)
        nvc.setNavigationBarHidden(true, animated: false)
        self.window?.rootViewController = nvc
        window?.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        
    }
    
    
    internal func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping
        ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        if userActivity.activityType == "com.yujin.scout.siriStart" {
            print("⭕️")
        } else if userActivity.activityType == "SiriStartIntent" {
            print("✅")
        } else if userActivity.activityType == "com.yujin.scout.ent.SiriShortcutExtension" {
            print("🛑")
        }
        return true
    }
    
}

