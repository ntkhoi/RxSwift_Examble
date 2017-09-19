//
//  ViewController.swift
//  MovieRxSwift
//
//  Created by Khoi Nguyen on 9/17/17.
//  Copyright © 2017 Khoi Nguyen. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController, UITableViewDelegate {

    fileprivate var navigator: Navigator!
    fileprivate var viewModel: MovieViewModelType!
    fileprivate let disposeBag = DisposeBag()

    
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.estimatedRowHeight = 141
            tableView.rowHeight = UITableViewAutomaticDimension
            
        }
    }
    
    static func createWith(navigator: Navigator, storyboard: UIStoryboard, viewModel: MovieViewModelType) -> MainViewController {
        let vc = storyboard.instantiateViewController(ofType: MainViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = "Top Rated"
        super.viewDidLoad()
        viewModel
          .fetchMovies().debug()
          .map { (result) -> [Movie] in
            switch result {
            case .success(let movies):
                return movies
            case .failure(let error):
                print("Fetch Movie error : \(error.localizedDescription)")
                return []
            }
        }
      .drive(tableView.rx.items(cellIdentifier: String(describing: MovieCell.self), cellType: MovieCell.self)){ row, movie, cell in
            cell.movie = movie
        }
        .addDisposableTo(disposeBag)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
