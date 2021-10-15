// MovieAPIService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol MovieAPIServiceProtocol {
    func fetchMovieList(urlString: String, completionHandler: @escaping (Result<Category, Error>) -> Void)
    func fetchDetails(movieID: Int, completionHandler: @escaping (Result<Films, Error>) -> ())
}

final class MovieAPIService: MovieAPIServiceProtocol {
    func fetchMovieList(urlString: String, completionHandler: @escaping (Result<Category, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movies = try decoder.decode(Category.self, from: data)
                completionHandler(.success(movies))
            } catch {
                completionHandler(.failure(error))
            }
        }.resume()
    }

    func fetchDetails(movieID: Int, completionHandler: @escaping (Result<Films, Error>) -> ()) {
        let movieURL =
            "https://api.themoviedb.org/3/movie/\(movieID)?api_key=d21445c991b862f2b5da36887c777ba4&language=ru-RU&page=1"
        guard let url = URL(string: movieURL) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movieDetails = try decoder.decode(Films.self, from: data)
                completionHandler(.success(movieDetails))
            } catch {
                completionHandler(.failure(error))
            }
        }.resume()
    }
}
