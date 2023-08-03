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

/// A client that handles network requests.
struct NetworkClient {
    /// Represents errors that may occur during network operations.
    enum NetworkClientError: Error {
        case invalidURL
        case decodingError
        case badRequest
    }

    /// A closure that performs an asynchronous network request and returns the response data and HTTPURLResponse.
    let request: (RequestProtocol) async throws -> (Data, HTTPURLResponse)
}

extension NetworkClient {
    /// Creates a live NetworkClient instance with the specified URLSession.
    /// - Parameter session: The URLSession to be used for network requests. Default is URLSession with default configuration.
    /// - Returns: A NetworkClient instance that performs live network requests.
    static func live(session: URLSession = .init(configuration: .default)) -> NetworkClient {
        NetworkClient(
            request: { request in
                // Build URL using request parameters
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

    /// A mock NetworkClient instance that returns an empty Data and HTTPURLResponse.
    static var mock: NetworkClient {
        NetworkClient { _ in
            return (Data(), .init())
        }
    }

    /// A failing NetworkClient instance that throws a badRequest error.
    static var failing: NetworkClient {
        NetworkClient { _ in
            throw NetworkClientError.badRequest
        }
    }
}
