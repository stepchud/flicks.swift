//
//  Movie.swift
//  Flicks
//
//  Created by Stephen Chudleigh on 10/17/16.
//  Copyright © 2016 Stephen Chudleigh. All rights reserved.
//

import Foundation

class Movie {
    let dateInput = DateFormatter()
    let basePath = "https://image.tmdb.org/t/p/w500/"
    var title: String
    var overview: String
    var popularityRating: Double
    var releaseDate: String = "Unknown"
    var poster: URL?
    
    init(movie: NSDictionary) {
        self.dateInput.dateFormat = "yyyy-MM-dd"
        self.title = movie["title"] as! String
        self.overview = movie["overview"] as! String
        self.popularityRating = movie["popularity"] as! Double
        
        if let released = dateInput.date(from: movie["release_date"] as! String) {
            self.releaseDate = DateFormatter.localizedString(from: released, dateStyle: .long, timeStyle: .none)
        }
        if let path = movie["poster_path"] as? String {
            self.poster = URL(string:  basePath + path)
        }
    }
}
