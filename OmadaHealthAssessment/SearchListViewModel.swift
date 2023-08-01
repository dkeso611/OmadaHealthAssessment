//
//  SearchListViewModel.swift
//  OmadaHealthAssessment
//
//  Created by Suru Layé on 8/1/23.
//

import SwiftUI
import Combine


@MainActor public final class SearchListViewModel: ObservableObject {
  // States of the ListViewModel.
  enum State: Equatable {
    case loading
    case value(query: String, list: [TMDBItemViewModel])
    case error(title: String, cta: String?)
  }

  private var cancellables: Set<AnyCancellable> = .init()
  let service: MovieAPIService


  // Published property representing the current state of the ListViewModel.
  @Published private(set) var state: State = .loading
  @Published private(set) var query = ""


    init(service: MovieAPIService) {
      self.service = service
    }

  func load() async {
    await loadItems(with: query)
    subscribeToQueryPublisher()
  }

  func update(query: String) {
    self.query = query
  }

    // Asynchronously load items using the loadItems function from dependencies.
  private func loadItems(with query: String) async {
    do {
      // Fetch items using the provided getMovieList closure.
      let list = try await service.getMovieList(query).map { TMDBItemViewModel(movie: $0) }

      // Update the state to .value(list: [ItemViewModel]).
      state = .value(query: query, list: list)
    } catch {
      // If an error occurs during loading, update the state to .error.
      state = .error(title: "Oops, Something went wrong!", cta: "Tap to retry")
      cancellables.forEach { $0.cancel() }
    }
  }


  private func subscribeToQueryPublisher() {
    $query
      .dropFirst()
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .sink { value in
        Task { [weak self] in
          guard let self = self else { return }
          await self.loadItems(with: value)
        }
      }
      .store(in: &cancellables)
  }
}
