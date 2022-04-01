//
//  MovieSearchViewModel.swift
//  MovieInfo
//
//  Created by Yilin on 2019/11/10.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MovieSearchViewModel {
    private let movieService: MovieService
    private let disposeBag = DisposeBag()

    private let _movies = BehaviorRelay<[Movie]>(value: [])
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _info = BehaviorRelay<String?>(value: nil)

    init(query: Driver<String>, movieService: MovieService) {
        self.movieService = movieService

        query
            .throttle(.microseconds(3000))
            .distinctUntilChanged()
            .drive(onNext: { [weak self] queryString in
                self?.searchMovies(query: queryString)
            })
            .disposed(by: disposeBag)
    }

    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }

    var movies: Driver<[Movie]> {
        return _movies.asDriver()
    }

    var info: Driver<String?> {
        return _info.asDriver()
    }

    var hasInfo: Bool {
        return _info.value != nil
    }

    var numberOfMoviews: Int {
        return _movies.value.count
    }

    private func searchMovies(query: String?) {
        guard let query = query, !query.isEmpty else {
            _movies.accept([])
            _info.accept("Start searching your favorite movies")

            return
        }

        _movies.accept([])
        _isFetching.accept(true)
        _info.accept(nil)

        movieService.searchMovie(query: query, params: nil, successHandler: { [weak self] response in
            self?._isFetching.accept(false)
            if response.totalResults == 0 {
                self?._info.accept("No result for \(query)")
            }
            self?._movies.accept(Array(response.results.prefix(5)))
        }, errorHandler: { error in
            self._isFetching.accept(false)
            self._info.accept(error.localizedDescription)
        })
    }

    func viewModelForMovie(at index: Int) -> MovieCellViewModel? {
        guard index < _movies.value.count else {
            return nil
        }
        return MovieCellViewModel(movie: _movies.value[index])
    }
}
