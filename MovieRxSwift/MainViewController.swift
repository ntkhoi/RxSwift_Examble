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
    
    
    private var movies = Variable<[Movie]>([])
    private var fetchedMovies: [Movie]  = []
    
    @IBOutlet weak var searchBar: UISearchBar!
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
        super.viewDidLoad()
        self.navigationItem.title = "Home Scene"
        
        viewModel
            .fetchMovies().debug()
            .map { (result) -> [Movie] in
                switch result {
                case .success(let movies):
                    print("case .success(let movies):")
                    self.fetchedMovies = movies
                    self.movies.value = movies
                    return movies
                case .failure(let error):
                    print("Fetch Movie error : \(error.localizedDescription)")
                    return []
                }
            }.asObservable()
            .subscribe()
            .addDisposableTo(disposeBag)
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
