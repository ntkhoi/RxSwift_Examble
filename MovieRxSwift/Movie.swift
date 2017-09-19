//
//  Movie.swift
//  MovieRxSwift
//
//  Created by Khoi Nguyen on 9/17/17.
//  Copyright © 2017 Khoi Nguyen. All rights reserved.
//

import Foundation


import Foundation
import ObjectMapper

fileprivate let imageRootPath = "https://image.tmdb.org/t/p/w500"

class Movie: Mappable {

    var title: String = ""
    var overview: String = ""
    var posterUrl: URL?
    
    required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        title <- map["title"]
        overview <- map["overview"]
        posterUrl <- (map["poster_path"], PosterUrlTransform() )

    }
    
}

open class PosterUrlTransform: TransformType {
    public typealias Object = URL
    public typealias JSON = String
    private let shouldEncodeURLString: Bool
    private let allowedCharacterSet: CharacterSet
    public init(shouldEncodeURLString: Bool = true, allowedCharacterSet: CharacterSet = .urlQueryAllowed) {
        self.shouldEncodeURLString = shouldEncodeURLString
        self.allowedCharacterSet = allowedCharacterSet
    }
    
    open func transformFromJSON(_ value: Any?) -> URL? {
        guard var URLString = value as? String else { return nil }
        URLString = imageRootPath.appending(URLString)
        
        if !shouldEncodeURLString {
            return URL(string: URLString)
        }
        
        guard let escapedURLString = URLString.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) else {
            return nil
        }
        return URL(string: escapedURLString)
    }
    
    open func transformToJSON(_ value: URL?) -> String? {
        if let URL = value {
            return URL.absoluteString
        }
        return nil
    }
}
