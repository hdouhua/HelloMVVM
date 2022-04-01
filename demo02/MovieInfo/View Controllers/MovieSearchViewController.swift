//
//  MovieSearchViewController.swift
//  MovieInfo
//
//  Created by Alfian Losari on 10/03/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class MovieSearchViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!

    var viewModel: MovieSearchViewModel!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()

        let searchBar = navigationItem.searchController!.searchBar

        viewModel = MovieSearchViewModel(query: searchBar.rx.text.orEmpty.asDriver(), movieService: MovieStore.shared)

        viewModel.movies
            .drive(onNext: { [unowned self] _ in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.isFetching
            .drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.info
            .drive(onNext: { [unowned self] info in
                self.infoLabel.isHidden = !self.viewModel.hasInfo
                self.infoLabel.text = info
            })
            .disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned searchBar] in
                searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        searchBar.rx.cancelButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned searchBar] in
                searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)

        setupTableView()
    }

    private func setupNavigationBar() {
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        definesPresentationContext = true
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false

        navigationItem.searchController?.searchBar.sizeToFit()
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
    }
}

extension MovieSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.numberOfMoviews
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell

        if let vm = self.viewModel.viewModelForMovie(at: indexPath.row) {
            cell.configure(viewModel: vm)
        }

        return cell
    }
}
