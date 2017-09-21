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
    
    // TODO : Movie search logic to viewmodel
    fileprivate var movies = Variable<[Movie]>([])
    fileprivate var fetchedMovies: [Movie]  = []
    
    var refeshControl: UIRefreshControl?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.estimatedRowHeight = 141
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    // Duplicate in each VC
    // TODO : Create generic method to new ViewController
    static func createWith(navigator: Navigator, storyboard: UIStoryboard, viewModel: MovieViewModelType) -> MainViewController {
        let vc = storyboard.instantiateViewController(ofType: MainViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Home Scene"
        refeshControl = UIRefreshControl()
        tableView.insertSubview(refeshControl!, at: 0)
        
        refeshControl?.rx.controlEvent(.valueChanged)
            .flatMapLatest{ [unowned self] _ in
                return self.viewModel.fetchMovies()
            }.subscribe(onNext: {[unowned self] (movies) in
                self.movies.value = movies
                self.fetchedMovies = movies
                // Cheat code . Should use rxcoacoa binding to end refeshing
                self.refeshControl?.endRefreshing()
            }).addDisposableTo(disposeBag)
        

        viewModel.fetchMovies()
        .subscribe(onNext: {[unowned self] (movies) in
            self.movies.value = movies
            self.fetchedMovies = movies
        }).addDisposableTo(disposeBag)
        
        movies.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: MovieCell.self), cellType: MovieCell.self)) {
                row, movie, cell in
                cell.movie = movie
            }.addDisposableTo(disposeBag)
        
        
        searchBar.rx.text.orEmpty
            .debounce(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] (query) in
                if query == "" {
                    self.movies.value = self.fetchedMovies
                } else {
                    self.movies.value = self.fetchedMovies.filter{ $0.title.lowercased().contains(query.lowercased()) }
                }
            }).addDisposableTo(disposeBag)
        
        // TODO : Move this.navigator to viewmodels
        tableView
            .rx
            .modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] (movie) in
                guard let this = self else { return }
                this.navigator.show(segue: .movieInfo(movie: movie), sender: this)
            })
            .addDisposableTo(disposeBag)
    }
}
    
