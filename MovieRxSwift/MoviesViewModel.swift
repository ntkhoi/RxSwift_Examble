
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
    func fetchMovies() -> Observable<[Movie]>
}

struct MovieViewModel : MovieViewModelType {

    func fetchMovies() -> Observable<[Movie]> {
        return fetchMovies()
            .map { (result) -> [Movie] in
                switch result {
                case .success(let movies):
                    return movies
                case .failure(let error):
                    print("Fetch Movie error : \(error.localizedDescription)")
                    return []
                }
            }.asObservable()
    }
    
    fileprivate func fetchMovies() -> Driver<Result<[Movie]>> {
        return NetworkingLayer.fetchRepositories()
    }
}
