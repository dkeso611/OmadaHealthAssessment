//
//  MoviesResponse.swift
//  OmadaHealthAssessment
//
//  Created by Suru Layé on 8/1/23.
//

import Foundation

// MARK: - Movies
struct MoviesResponse: Codable {
  let page: Int
  let results: [Movie]
  let totalPages: Int
  let totalResults: Int

  enum CodingKeys: String, CodingKey {
    case page, results
    case totalPages
    case totalResults
  }
}

// MARK: - Movie
struct Movie: Codable {
  let id: Int
  let originalTitle: String
  let overview: String
  let posterPath: String?
  let releaseDate: String
  let title: String
  let voteAverage: Double

  enum CodingKeys: String, CodingKey {
    case id
    case originalTitle
    case overview
    case posterPath
    case releaseDate
    case title
    case voteAverage
  }
}

extension MoviesResponse {
  static var mock: [Movie] {
    [
      Movie(
        id: 1,
        originalTitle: "Joker",
        overview: "Some Overview",
        posterPath: "",
        releaseDate: "2020",
        title: "Joker",
        voteAverage: 5.6
      ),
      Movie(
        id: 2,
        originalTitle: "Batman",
        overview: "Some Overview",
        posterPath: "",
        releaseDate: "2020",
        title: "Batman",
        voteAverage: 5.9
      )
    ]
  }
}

extension Movie {
  var imageURL: String? {
    guard let path = posterPath else {
      return nil
    }
    
   return "https://image.tmdb.org/t/p/original/\(path)"
  }
}
