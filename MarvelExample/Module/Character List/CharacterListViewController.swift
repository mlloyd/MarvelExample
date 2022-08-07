//
//  CharacterListViewController.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import UIKit
import Combine

final class CharacterListViewController: UIViewController {

    private let viewModel: CharacterListViewModel
    private let imageService: ImageServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: CharacterListViewModel,
         imageService: ImageServiceProtocol) {
        self.viewModel = viewModel
        self.imageService = imageService
        super.init(nibName: nil, bundle: nil)
        self.title = "Marvel"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private enum Section: CaseIterable {
        case main
    }

    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, CharacterListViewModel.ListItem> = {
        let cellRegistration =
        UICollectionView.CellRegistration<CharacterCollectionViewCell, CharacterListViewModel.ListItem>(
            cellNib: UINib(nibName: "CharacterCollectionViewCell", bundle: nil)) { cell, _, item in
                cell.configure(name: item.name)
                cell.accessibilityIdentifier = CharacterListPageObject.characterListCell
        }

        return UICollectionViewDiffableDataSource<Section, CharacterListViewModel.ListItem>(
            collectionView: collectionView) { (collectionView, indexPath, item)
            -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIComponents.buildLoadingIndicator()
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return loadingIndicator
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UIComponents.buildCollectionView()
        collectionView.delegate = self
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.topAnchor.constraint(equalTo: collectionView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        collectionView.dataSource = dataSource
        loadingIndicator.startAnimating()

        addBindings()
        viewModel.setup()
    }

    // MARK: - Private

    private func addBindings() {
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewState in
                guard let self = self else { return }

                switch viewState {
                case.loading:
                    self.loadingIndicator.startAnimating()
                    self.collectionView.isHidden = true
                case .error:
                    // Show error screen
                    break
                case .success(let items):
                    self.loadingIndicator.stopAnimating()
                    self.collectionView.isHidden = false
                    self.applySnapshot(items: items)
                }
        }.store(in: &cancellables)
    }

    private func applySnapshot(items: [CharacterListViewModel.ListItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CharacterListViewModel.ListItem>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension CharacterListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        if let item = dataSource.itemIdentifier(for: indexPath) {
            viewModel.actionCharacter(character: item)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let imageURL = dataSource.itemIdentifier(for: indexPath)?.imageURL else { return }

        imageService.fetchImage(imageURL: imageURL) { [weak cell] result in
            switch result {
            case let .success(model):
                (cell as? CharacterCollectionViewCell)?.setProfileImage(image: model.image)
            default: break
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let imageURL = dataSource.itemIdentifier(for: indexPath)?.imageURL else { return }

        imageService.cancelImage(imageURL: imageURL)
    }
}
