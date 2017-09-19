//
//  Coodinator.swift
//  MovieRxSwift
//
//  Created by Khoi Nguyen on 9/17/17.
//  Copyright © 2017 Khoi Nguyen. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa

class Navigator {
    lazy private var defaultStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    // MARK: - segues list
    enum Segue {
        case listMovies()
    }
    
    // MARK: - invoke a single segue
    func show(segue: Segue, sender: UIViewController) {
        switch segue {
        case .listMovies:
            //show the combined Movie for the list
            let vm = MovieViewModel()
            show(target: MainViewController.createWith(navigator: self, storyboard: sender.storyboard ?? defaultStoryboard, viewModel: vm), sender: sender)
        }
    }
    
    private func show(target: UIViewController, sender: UIViewController) {
        if let nav = sender as? UINavigationController {
            nav.pushViewController(target, animated: false)
            return
        }
        if let nav = sender.navigationController {
            nav.pushViewController(target, animated: true)
        } else {
            sender.present(target, animated: true, completion: nil)
        }
    }

    
}
