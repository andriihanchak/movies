//
//  AppDelegate.swift
//  Movies
//
//  Created by Andrii Hanchak on 05.10.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var appContext: AppContext!
    private var appCoordinator: AppCoordinator!
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let window = window else { return true }
        
        appContext = AppContext(window: window)
        appContext.networkReachibilityService.startMonitoring()
        
        appCoordinator = AppCoordinator(appContext: appContext)
        _ = appCoordinator.start()
        
        appContext.snackbarController.initialize(with: window)
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        appContext.networkReachibilityService.startMonitoring()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        appContext.networkReachibilityService.stopMonitoring()
    }
}
