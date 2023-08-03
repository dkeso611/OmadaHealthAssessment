//
//  TDMBItemService.swift
//  OmadaHealthAssessment
//
//  Created by Suru Layé on 8/3/23.
//

import Foundation

// TMDBItemService represents a service for fetching TMDBItemViewModel data.
struct TMDBItemService {
    /// An asynchronous function that throws an error.
    /// Retrieves a list of TMDBItemViewModel objects for a given query string.
    let getItems: (String) async throws -> [TMDBItemViewModel]
}

extension TMDBItemService {
    /// A mock implementation of TMDBItemService that returns mock data.
    static var mock: TMDBItemService {
        TMDBItemService(
            getItems: { _ in
                // Map mock data from MoviesResponse to TMDBItemViewModel.
                MoviesResponse.mock.map { TMDBItemViewModel(movie: $0) }
            }
        )
    }

    /// A TMDBItemService implementation that returns an empty list of items.
    static var empty: TMDBItemService {
        TMDBItemService(
            getItems: { _ in
                []
            }
        )
    }

    /// A failing TMDBItemService implementation that throws an invalidResponse error.
    static var failing: TMDBItemService {
        TMDBItemService(
            getItems: { _ in
                // Throws an invalidResponse error to simulate a failed API response.
                throw MovieAPIService.MovieAPIServiceError.invalidResponse
            }
        )
    }
}

// MovieItemServiceAdapter adapts MovieAPIService to TMDBItemService protocol.
struct MovieItemServiceAdapter {
    /// Adapts the MovieAPIService to the TMDBItemService protocol.
    /// - Parameter service: The MovieAPIService to be adapted.
    /// - Returns: A TMDBItemService instance that conforms to the TMDBItemService protocol.
    static func adapt(from service: MovieAPIService) -> TMDBItemService {
        TMDBItemService(
            getItems: { query in
                // Asynchronously fetches data from MovieAPIService and maps it to TMDBItemViewModel objects.
                // Any errors that occur during the mapping process are propagated as throws.
                try await service.getMovieList(query).map { TMDBItemViewModel(movie: $0) }
            }
        )
    }
}

