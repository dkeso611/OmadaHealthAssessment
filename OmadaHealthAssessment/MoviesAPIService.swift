//
//  MoviesAPIService.swift
//  OmadaHealthAssessment
//
//  Created by Suru Layé on 8/1/23.
//

import Foundation

// Implementation of the Movie API service as a protocol witness.
struct MovieAPIService {
  // Error enum for MovieAPIService.
  enum MovieAPIServiceError: Error {
    case decodingError
    case invalidResponse
  }

  let getMovieList: (String) async throws -> [Movie]
}

// Extension to provide additional functionality for the MovieAPIService.
extension MovieAPIService {
  
  // Factory method to create a live movie API service using a network client.
  static func live(networkClient: NetworkClient) -> MovieAPIService {
    MovieAPIService(
      getMovieList: { query in
        // Make a network request to get the list of movies.
        let (data, response) = try await networkClient.request(MoviesRequest.list(query: query))

        // Decode the response using the movieListResponseDecoder function.
        let moviesResponse = try await movieListResponseDecoder(data: data, response: response, decodeTo: MoviesResponse.self)
//        print(moviesResponse.results)

        // Return the list of movies from the response.
        return moviesResponse.results
      }
    )
  }

  // Factory method to create a mock movies API service for testing.
  static var mock: MovieAPIService {
    MovieAPIService(
      getMovieList: { _ in
        return MoviesResponse.mock
      }
    )
  }

  // Factory method to create an empty movie API service for testing error handling.
  static var empty: MovieAPIService {
    MovieAPIService(
      getMovieList: { _ in
        return [] // Return an empty list to simulate an empty response.
      }
    )
  }

  // Factory method to create a failing Movie API service for testing error handling.
  static var failing: MovieAPIService {
    MovieAPIService(
      getMovieList: { _ in
        throw MovieAPIServiceError.invalidResponse // Throw an error to simulate a failed response.
      }
    )
  }

  // Function to decode the response data based on the response status code.
  // Encapsulates backend contract logic. Potential changes in decoding strategy based on response received/ diff api, diff response formats
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
          print(error)
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
