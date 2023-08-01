//
//  MoviesRequest.swift
//  OmadaHealthAssessment
//
//  Created by Suru Layé on 8/1/23.
//

import Foundation
//"https://api.themoviedb.org/3/movie/118408?language=en-US"

// https://api.themoviedb.org/3/search/movie?api_key=b11fc621b3f7f739cb79b50319915f1d&language=en-US&query=hitman&page=1&include_adult=false
enum MoviesRequest: RequestProtocol {
  case list(query: String)
  case details(id: Int)

  var hostURLString: String {
    return "https://api.themoviedb.org/"
  }

  var path: String {
    switch self {
      case .list:
        return "3/search/movie"
      case .details(let id):
        return "3/movie/\(id)"
    }
  }

  var method: HTTPMethod {
    return .GET
  }

  var queryItems: [URLQueryItem]? {
    switch self {
      case .list(let query):
        return [
          URLQueryItem(name: "query", value: query),
          URLQueryItem(name: "api_key", value: apiKey),
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "include_adult", value: "false"),
          URLQueryItem(name: "page", value: "1"),
        ]
      case .details:
        return [URLQueryItem(name: "api_key", value: apiKey)]
    }

  }

  var parameters: [String: String]? {
    return nil
  }

  private var apiKey: String {
    return "b11fc621b3f7f739cb79b50319915f1d"
  }
}
