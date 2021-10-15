// MainViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

// MARK: - Protocol

protocol MainViewModelProtocol: AnyObject {
    var movies: Category? { get set }
    var imageData: Data? { get set }
    var updateViewData: ((MainViewModelProtocol?) -> ())? { get set }
    var movieAPIService: MovieAPIServiceProtocol? { get set }
    func loadMoviesList(urlString: String)
}

final class MainViewModel: MainViewModelProtocol {
    // MARK: - Public Properties

    var imageData: Data?
    var movieAPIService: MovieAPIServiceProtocol?
    var movies: Category? {
        didSet {
            updateViewData?(self)
        }
    }

    var updateViewData: ((MainViewModelProtocol?) -> ())?

    // MARK: - Init

    init(movieAPIService: MovieAPIServiceProtocol) {
        self.movieAPIService = movieAPIService
        loadMoviesList(urlString: Constants.popular)
    }

    // MARK: - Public Methods

    func loadMoviesList(urlString: String) {
        movieAPIService?.fetchMovieList(urlString: urlString, completionHandler: { [weak self] result in
            switch result {
            case let .success(category):
                self?.movies = category

            case let .failure(error):
                print(error.localizedDescription)
            }
        })
    }
}
