//
//  CharacterListViewModel.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import Combine
import Foundation

final class CharacterListViewModel: ObservableObject {

    struct ListItem: Hashable {
        let name: String
        let imageURL: URL?
    }

    @Published private(set) var viewState: AsyncResult<[ListItem]> = .loading

    private let contentService: MarvelContentServiceProtocol
    private let flow: CharacterListFlow
    private var cache = [String: Character]()

    init(contentService: MarvelContentServiceProtocol,
         flow: CharacterListFlow) {
        self.contentService = contentService
        self.flow = flow
    }

    func setup() {
        contentService.fetchCharacters(info: MarvelCharacterFetchInfo()) { [weak self] result in
            guard let self = self else { return }

            do {
                let characters = try result.get()

                var cache = [String: Character]()
                for character in characters {
                    cache[character.name] = character
                }

                self.cache = cache

                let items = characters.map {
                    ListItem(name: $0.name, imageURL: $0.thumbnail.imageURL)
                }
                self.viewState = AsyncResult.success(items)
            } catch {
                self.viewState = AsyncResult.error(error)
            }
        }
    }

    func actionCharacter(character: ListItem) {
        guard let selectedCharacter = cache[character.name] else { return }
        flow.presentCharacter(character: selectedCharacter)
    }
}
