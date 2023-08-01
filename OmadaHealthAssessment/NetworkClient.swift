//
//  NetworkClient.swift
//  OmadaHealthAssessment
//
//  Created by Suru Layé on 8/1/23.
//


import Foundation


protocol RequestProtocol {
  var hostURLString: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var parameters: [String: String]? { get }
  var queryItems: [URLQueryItem]? { get }
}

enum HTTPMethod: String {
  case GET = "GET"
  case POST = "POST"
  case PUT = "PUT"
  case DELETE = "DELETE"
}

 struct NetworkClient {
  enum NetworkClientError: Error {
    case invalidURL
    case decodingError
    case badRequest
  }

  let request: (RequestProtocol) async throws -> (Data, HTTPURLResponse)
}

extension NetworkClient {
  static func live(session: URLSession = .init(configuration: .default)) -> NetworkClient {
    NetworkClient(
      request: { request in

        guard var hostURL = URL(string: request.hostURLString) else {
          throw NetworkClientError.invalidURL
        }


        hostURL.append(path: request.path)

        guard var components = URLComponents(url: hostURL, resolvingAgainstBaseURL: false) else {
          throw NetworkClientError.invalidURL
        }

        // Attach params to components
        components.queryItems = request.queryItems

        guard let endpoint = components.url else {
          throw NetworkClientError.invalidURL
        }

        var urlRequest = URLRequest(url: endpoint)

        // Add Headers
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

        // Select Method
        urlRequest.httpMethod = request.method.rawValue

        if let params = request.parameters {
          let jsonEncoder = JSONEncoder()

          urlRequest.httpBody = try jsonEncoder.encode(params)
        }

        let (data, urlResponse) = try await session.data(for: urlRequest)

        guard let httpResponse = urlResponse as? HTTPURLResponse else {
          throw NetworkClientError.badRequest
        }

        return (data, httpResponse)

      }
    )
  }

  static var mock: NetworkClient {
    NetworkClient { _ in
      return (Data(), .init())
    }
  }

  static var failing: NetworkClient {
    NetworkClient { _ in
      throw NetworkClientError.badRequest
    }
  }
}

