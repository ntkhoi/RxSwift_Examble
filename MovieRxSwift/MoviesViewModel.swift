
//
//  MoviesViewModel.swift
//  MovieRxSwift
//
//  Created by Khoi Nguyen on 9/17/17.
//  Copyright © 2017 Khoi Nguyen. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

//this protocol represents a repository view model then anyone can implement this and perform the fetch.
protocol MovieViewModelType {
    func fetchMovies() -> Driver<Result<[Movie]>>
}

struct MovieViewModel : MovieViewModelType {

    func fetchMovies() -> Driver<Result<[Movie]>> {
        return NetworkingLayer.fetchRepositories()
    }
}
