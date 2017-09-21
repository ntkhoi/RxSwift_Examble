//
//  MovieInfoViewcontroller.swift
//  MovieRxSwift
//
//  Created by Khoi Nguyen on 9/21/17.
//  Copyright © 2017 Khoi Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class MovieInfoViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var viewModel: MovieInfoViewModelType!
    fileprivate var navigator: Navigator!
    
    
    // Duplicate in each VC 
    // TODO : Create generic method to new ViewController
    static func createWith(navigator: Navigator, storyboard: UIStoryboard, viewModel: MovieInfoViewModelType) -> MovieInfoViewController {
        let vc = storyboard.instantiateViewController(ofType: MovieInfoViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO:
        // Change to binding UI to view model .
        
        viewModel.title
            .bind(to: titleLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.overview.debug()
            .bind(to: overviewLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.poster.asObserver()
            .subscribe(onNext: { [weak self] (url) in
                self?.posterImageView.sd_setImage(with: url)
            })
            .addDisposableTo(disposeBag)
    }
}
