//
//  Coordinator.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import UIKit

class Coordinator {

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = CharacterListViewModel(
            contentService: AppAssembly.shared.marvelContentService,
            flow: self
        )
        let viewController = CharacterListViewController(
            viewModel: viewModel,
            imageService: AppAssembly.shared.imageService
        )
        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension Coordinator: CharacterListFlow {

    func presentCharacter(character: Character) {
        let viewModel = CharacterDetailViewModel(character: character)
        let viewController = CharacterDetailViewController(
            viewModel: viewModel,
            imageService: AppAssembly.shared.imageService
        )
        navigationController.pushViewController(viewController, animated: true)
    }
}
