// MainViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
/// LIstViewController
final class MainViewController: UIViewController {
    // MARK: - Public Properties

    var viewModel: MainViewModelProtocol? {
        didSet {
            viewModel?.updateViewData = { [weak self] featchData in
                self?.category = featchData?.movies
                DispatchQueue.main.async {
                    self?.movieTableView.reloadData()
                }
            }
        }
    }

    // MARK: - Private Properties

    private var movieTableView = UITableView()
    private var genresSegmentControl = UISegmentedControl()
    private let identifire = "MyCell"
    private var genresArray = ["Popular", "Top Rated", "Up Coming"]
    private var jsonUrlString = Constants.popular
    private var category: Category?
    private var genresPath = [Constants.popular, Constants.topRated, Constants.upComing]

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Popular"
        navigationController?.navigationBar.tintColor = .white

        createSegmentControl()
        createTable()
    }

    // MARK: - Private Methods

    private func createTable() {
        movieTableView.register(MainTableViewCell.self, forCellReuseIdentifier: identifire)
        movieTableView.separatorStyle = .none
        movieTableView.estimatedRowHeight = 200
        movieTableView.rowHeight = UITableView.automaticDimension
        view.addSubview(movieTableView)

        let safeArea = view.safeAreaLayoutGuide
        movieTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
            movieTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
            movieTableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            movieTableView.bottomAnchor.constraint(equalTo: genresSegmentControl.topAnchor, constant: -5)
        ])

        movieTableView.delegate = self
        movieTableView.dataSource = self
    }

    private func createSegmentControl() {
        genresSegmentControl = UISegmentedControl(items: genresArray)
        genresSegmentControl.isMomentary = true
        genresSegmentControl.backgroundColor = .systemGray2
        genresSegmentControl.addTarget(self, action: #selector(selectGendersSegmentControl), for: .valueChanged)
        view.addSubview(genresSegmentControl)

        let safeArea = view.safeAreaLayoutGuide
        genresSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genresSegmentControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 50),
            genresSegmentControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -50),
            genresSegmentControl.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -5),
            genresSegmentControl.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func selectGendersSegmentControl() {
        let index = genresSegmentControl.selectedSegmentIndex
        viewModel?.loadMoviesList(urlString: genresPath[index])
        navigationItem.title = genresArray[index]
    }

    private func configureCell(cell: MainTableViewCell, for indexPath: IndexPath) {
        guard let result = category?.results[indexPath.row] else { return }
        let filmImage = result.posterPath

        DispatchQueue.global().async {
            let const = "https://image.tmdb.org/t/p/w500"
            guard let urlImage = URL(string: "\(const)\(filmImage ?? "")") else { return }
            guard let imageData = try? Data(contentsOf: urlImage) else { return }

            DispatchQueue.main.async {
                guard let image = UIImage(data: imageData) else { return }
                cell.configCell(films: result, image: image)
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: identifire, for: indexPath) as? MainTableViewCell
        else { return UITableViewCell() }
        configureCell(cell: cell, for: indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let countRow = category?.results.count else { return Int() }
        return countRow
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let category = category?.results[indexPath.row] else { return }

        let previewVC = DetailsViewController()
        let detialViewModel = DetailViewModel(movieId: category.id, movieAPIService: MovieAPIService())
        previewVC.detailViewModel = detialViewModel
        navigationController?.pushViewController(previewVC, animated: true)
    }
}
