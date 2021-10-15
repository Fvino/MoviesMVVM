// DetailsViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
/// InformationFilmViewController
final class DetailsViewController: UIViewController {
    // MARK: - Public Properties

    var idFilm = Int()
    var infoCategory: Films?

    var detailViewModel: DetailViewModelProtocol? {
        didSet {
            detailViewModel?.updateDetails = { [weak self] fetchData in
                self?.infoCategory = fetchData.movieDetails
                DispatchQueue.main.async {
                    self?.infoTableView.reloadData()
                }
            }
        }
    }

    // MARK: - Private Properties

    private var infoTableView = UITableView()
    private let identifire = "MyCell"
    private var infoImage = UIImageView()
    private var infoLable = UILabel()

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = infoCategory?.title

        createTable()
    }

    // MARK: - Private Methods

    private func createTable() {
        infoTableView.register(DetailTableViewCell.self, forCellReuseIdentifier: identifire)
        infoTableView.separatorStyle = .none
        infoTableView.estimatedRowHeight = 700
        infoTableView.rowHeight = UITableView.automaticDimension
        view.addSubview(infoTableView)

        let safeArea = view.safeAreaLayoutGuide
        infoTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
            infoTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
            infoTableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            infoTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0)
        ])

        infoTableView.delegate = self
        infoTableView.dataSource = self
    }

    private func configureCell(cell: DetailTableViewCell, for indexPath: IndexPath) {
        guard let result = infoCategory, let filmImage = infoCategory?.posterPath else { return }
        DispatchQueue.global().async {
            let const = "https://image.tmdb.org/t/p/w500"
            guard let urlImage = URL(string: "\(const)\(filmImage)") else { return }
            guard let imageData = try? Data(contentsOf: urlImage) else { return }

            DispatchQueue.main.async {
                guard let image = UIImage(data: imageData) else { return }
                cell.configCell(films: result, image: image)
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension DetailsViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: identifire, for: indexPath) as? DetailTableViewCell
        else { return UITableViewCell() }
        configureCell(cell: cell, for: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
}
