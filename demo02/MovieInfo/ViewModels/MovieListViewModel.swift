//
//  MovieListViewModel.swift
//  MovieInfo
//
//  Created by Yilin on 2019/11/10.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MovieListViewModel {
    private let movieService: MovieService

    // will be used to automatically manage the dellocation of observables subscription
    private let disposeBag = DisposeBag()

    // can be used to publish new value and also be observed
    private let _movies = BehaviorRelay<[Movie]>(value: [])
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<String?>(value: nil)

    // Driver is an observable, always scheduled to be run on UI Thread
    // These properties will be used by the View Controller to observe the value and bind the View to

    init(endpoint: Driver<Endpoint>, movieService: MovieService) {
        self.movieService = movieService

//        Observable<[Movie]>.create ({ subscribe in
//            self.movieService.fetchMovies(from: .nowPlaying, params: nil, successHandler: { response in
//                subscribe.onNext(response.results)
//                subscribe.onCompleted()
//            }, errorHandler: { error in
//
//            })
//            return Disposables.create()
//        })

        endpoint
            .drive(onNext: { [weak self] endpoint in
                self?.fetchMovies(endpoint: endpoint)
            }).disposed(by: disposeBag)
    }

    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }

    var movies: Driver<[Movie]> {
        return _movies.asDriver()
    }

    var error: Driver<String?> {
        return _error.asDriver()
    }

    var hasError: Bool {
        return _error.value != nil
    }

    var numberOfMoviews: Int {
        return _movies.value.count
    }

    func fetchMovies(endpoint: Endpoint) {
        _movies.accept([])
        _isFetching.accept(true)
        _error.accept(nil)

        movieService.fetchMovies(from: endpoint, params: nil, successHandler: { [weak self] response in
            self?._isFetching.accept(false)
            self?._movies.accept(response.results)
        }, errorHandler: { [weak self] error in
            self?._isFetching.accept(false)
            self?._error.accept(error.localizedDescription)
        })
    }

    func viewModelForMovie(at index: Int) -> MovieCellViewModel? {
        guard index < _movies.value.count else {
            return nil
        }
        return MovieCellViewModel(movie: _movies.value[index])
    }
}
