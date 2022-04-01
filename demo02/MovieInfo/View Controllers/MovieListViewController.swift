//
//  MovieListViewController.swift
//  MovieInfo
//
//  Created by Alfian Losari on 10/03/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Kingfisher
import RxCocoa
import RxSwift
import UIKit

class MovieListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var segmentedControl: UISegmentedControl!

    var movieListViewModel: MovieListViewModel!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        movieListViewModel = MovieListViewModel(endpoint: segmentedControl.rx.selectedSegmentIndex
            .map { Endpoint(index: $0) ?? .nowPlaying }
            .asDriver(onErrorJustReturn: .nowPlaying),
                                                movieService: MovieStore.shared)

        movieListViewModel.movies
            .drive(onNext: { [unowned self] _ in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        movieListViewModel.isFetching
            .drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

        movieListViewModel.error
            .drive(onNext: { [unowned self] error in
                self.infoLabel.isHidden = !self.movieListViewModel.hasError
                self.infoLabel.text = error
            })
            .disposed(by: disposeBag)

        setupTableView()
    }

    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
    }
}

extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return movieListViewModel.numberOfMoviews
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell

        if let viewModel = movieListViewModel.viewModelForMovie(at: indexPath.row) {
            cell.configure(viewModel: viewModel)
        }

        return cell
    }
}
