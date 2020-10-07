//
//  AppDelegate.swift
//  Movies
//
//  Created by Andrii Hanchak on 05.10.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let appContext: AppContext = AppContext()
    private var coordinator: CoordinatorType?
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        appContext.networkReachibilityService.startMonitoring()
        
        coordinator = MoviesViewCoordinator(window: window, appContext: appContext)
        coordinator?.start()
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        appContext.networkReachibilityService.startMonitoring()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        appContext.networkReachibilityService.stopMonitoring()
    }
}
