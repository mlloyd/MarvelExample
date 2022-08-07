//
//  CharacterDetailViewModel.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import Combine
import Foundation

final class CharacterDetailViewModel: ObservableObject {

    struct ViewState: Equatable {
        let title: String
        let description: String?
        let imageURL: URL?
    }

    @Published private(set) var viewState: AsyncResult<ViewState> = .loading

    private let character: Character

    init(character: Character) {
        self.character = character
    }

    func setup() {
        let detail = ViewState(
            title: character.name,
            description: character.description,
            imageURL: character.thumbnail.imageURL
        )
        viewState = AsyncResult.success(detail)
    }
}
