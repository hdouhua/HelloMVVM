//
//  MovieViewViewModel.swift
//  MovieInfo
//
//  Created by Yilin on 2019/11/10.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation

struct MovieCellViewModel {
    private var movie: Movie

    private static let dateFormatter: DateFormatter = {
        $0.dateStyle = .medium
        $0.timeStyle = .none
        return $0
    }(DateFormatter())

    init(movie: Movie) {
        self.movie = movie
    }

    var title: String {
        return movie.title
    }

    var overview: String {
        return movie.overview
    }

    var posterURL: URL {
        return movie.posterURL
    }

    var releaseDate: String {
        return MovieCellViewModel.dateFormatter.string(from: movie.releaseDate)
    }

    var rating: String {
        let rating = Int(movie.voteAverage)
        let ratingText = (0 ..< rating).reduce("") { (acc, _) -> String in
            acc + "⭐️"
        }
        return ratingText
    }
}
