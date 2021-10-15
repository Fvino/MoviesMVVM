// DetaiViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

// MARK: - Protocol

protocol DetailViewModelProtocol {
    var movieDetails: Films? { get set }
    var updateDetails: ((DetailViewModelProtocol) -> ())? { get set }
    var movieAPIService: MovieAPIServiceProtocol? { get set }
    func loadMovieDetails(movieID: Int)
}

final class DetailViewModel: DetailViewModelProtocol {
    // MARK: - Public Properties

    var movieAPIService: MovieAPIServiceProtocol?
    var updateDetails: ((DetailViewModelProtocol) -> ())?
    var movieDetails: Films? {
        didSet {
            updateDetails?(self)
        }
    }

    // MARK: - Init

    init(movieId: Int, movieAPIService: MovieAPIServiceProtocol) {
        self.movieAPIService = movieAPIService
        loadMovieDetails(movieID: movieId)
    }

    // MARK: - Public Methods

    func loadMovieDetails(movieID: Int) {
        movieAPIService?.fetchDetails(movieID: movieID, completionHandler: { [weak self] result in
            switch result {
            case let .success(movieDetails):
                self?.movieDetails = movieDetails
            case let .failure(error):
                print(error.localizedDescription)
            }
        })
    }
}
