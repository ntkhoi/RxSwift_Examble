//
//  MovieInfoViewModel.swift
//  MovieRxSwift
//
//  Created by Khoi Nguyen on 9/21/17.
//  Copyright © 2017 Khoi Nguyen. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


protocol MovieInfoViewModelType {
    
    var poster: BehaviorSubject<URL?> {get}
    var title: BehaviorSubject<String> {get}
    var overview: BehaviorSubject<String> {get}
}

class MovieInfoViewModel: MovieInfoViewModelType {
    
    var poster = BehaviorSubject<URL?>(value: nil)
    var title = BehaviorSubject<String>(value: "")
    var overview = BehaviorSubject<String>(value: "")
    
    init(movie: Movie) {
        poster.onNext(movie.posterUrl)
        title.onNext(movie.title)
        overview.onNext(movie.overview)
    }
}
