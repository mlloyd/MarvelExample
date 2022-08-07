//
//  CharacterDetailViewController.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import UIKit
import Combine

final class CharacterDetailViewController: UIViewController {

    private let viewModel: CharacterDetailViewModel
    private let imageService: ImageServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: CharacterDetailViewModel,
         imageService: ImageServiceProtocol) {
        self.viewModel = viewModel
        self.imageService = imageService
        super.init(nibName: nil, bundle: nil)
        self.title = "CharacterDetail"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.accessibilityIdentifier = CharacterDetailPageObject.characterDetailPage
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return scrollView
     }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.spacing = 24.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        let insets = UIEdgeInsets(top: 32.0, left: 16.0, bottom: 16.0, right: 24.0)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: insets.left + insets.right),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: insets.left),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: insets.right),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: insets.bottom)
        ])
        return stackView
    }()

    private lazy var imageView = UIImageView(frame: .zero)

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        stackView.addArrangedSubview(label)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .body)
        stackView.addArrangedSubview(label)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)

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
                    break
                case .error:
                    // Show error screen
                    break
                case .success(let character):
                    self.updateDisplay(viewState: character)
                }
        }.store(in: &cancellables)
    }

    private func updateDisplay(viewState: CharacterDetailViewModel.ViewState) {
        titleLabel.text = viewState.title
        descriptionLabel.text = viewState.description

        if let imageURL = viewState.imageURL {
            imageService.fetchImage(imageURL: imageURL) { [weak self] result in
                self?.imageView.image = try? result.get().image
            }
        }
    }
}
