//
//  MoviesAPIService.swift
//  OmadaHealthAssessment
//
//  Created by Suru Layé on 8/1/23.
//

import Foundation

/// A protocol witness for the Movie API service.
struct MovieAPIService {
    /// Error enum for MovieAPIService.
    enum MovieAPIServiceError: Error {
        case decodingError
        case invalidResponse
    }

    /// A closure that retrieves a list of movies based on the given query.
    let getMovieList: (String) async throws -> [Movie]
}

extension MovieAPIService {
    /// Creates a live Movie API service using the provided network client.
    /// - Parameter networkClient: The network client used to make network requests.
    /// - Returns: A MovieAPIService instance that performs live network requests.
    static func live(networkClient: NetworkClient) -> MovieAPIService {
        MovieAPIService(
            getMovieList: { query in
                // Make a network request to get the list of movies.
                let (data, response) = try await networkClient.request(MoviesRequest.list(query: query))

                // Decode the response using the movieListResponseDecoder function.
                let moviesResponse = try await movieListResponseDecoder(data: data, response: response, decodeTo: MoviesResponse.self)

                // Return the list of movies from the response.
                return moviesResponse.results
            }
        )
    }

    /// A mock Movie API service for testing purposes.
    static var mock: MovieAPIService {
        MovieAPIService(
            getMovieList: { _ in
                return MoviesResponse.mock
            }
        )
    }

    /// An empty Movie API service for testing error handling.
    static var empty: MovieAPIService {
        MovieAPIService(
            getMovieList: { _ in
                return [] // Return an empty list to simulate an empty response.
            }
        )
    }

    /// A failing Movie API service for testing error handling.
    static var failing: MovieAPIService {
        MovieAPIService(
            getMovieList: { _ in
                throw MovieAPIServiceError.invalidResponse // Throw an error to simulate a failed response.
            }
        )
    }

    /// Decodes the response data based on the response status code.
    /// - Parameters:
    ///   - data: The response data to be decoded.
    ///   - response: The HTTPURLResponse containing the response status code.
    ///   - decodeTo: The type to which the data should be decoded.
    /// - Returns: The decoded data of the specified type.
    /// - Throws: A MovieAPIServiceError if there is a decoding error or the response status code is invalid.
    static func movieListResponseDecoder<D: Decodable>(data: Data, response: HTTPURLResponse, decodeTo: D.Type) async throws -> D {
        // Check the response status code to determine the decoding strategy.
        switch response.statusCode {
        case 200..<300: // If the status code is 200 (OK), proceed with decoding.
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

            let result: D

            do {
                result = try jsonDecoder.decode(D.self, from: data) // Decode the data using the JSONDecoder.
            } catch {
                // Throws an error indicating decoding failure.
                throw MovieAPIServiceError.decodingError
            }

            // Return the decoded result.
            return result
        default:
            // Throw an error for an invalid response status code.
            throw MovieAPIServiceError.invalidResponse
        }
    }
}
