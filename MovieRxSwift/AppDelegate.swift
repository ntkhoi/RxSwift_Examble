//
//  AppDelegate.swift
//  MovieRxSwift
//
//  Created by Khoi Nguyen on 9/17/17.
//  Copyright © 2017 Khoi Nguyen. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let navigator = Navigator()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        let moviesNavigation = window!.rootViewController! as! UINavigationController
        navigator.show(segue: .listMovies(), sender: moviesNavigation)        
        return true
    }
}

