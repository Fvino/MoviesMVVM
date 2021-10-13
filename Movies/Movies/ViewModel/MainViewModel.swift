// MainViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol MainViewModelProtocol: AnyObject {
    var movies: Category? { get set }
    var updateViewData: ((MainViewModelProtocol?) -> ())? { get set }

    func startFetch(urlString: String)
}

final class MVVMViewModel: MainViewModelProtocol {
    var movies: Category? {
        didSet {
            updateViewData?(self)
        }
    }

    var updateViewData: ((MainViewModelProtocol?) -> ())?

    func startFetch(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self else { return }
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.movies = try decoder.decode(Category.self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
