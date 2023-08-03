//
//  OmadaHealthAssessmentTests.swift
//  OmadaHealthAssessmentTests
//
//  Created by Suru Layé on 8/1/23.
//

import XCTest
@testable import OmadaHealthAssessment

final class OmadaHealthAssessmentTests: XCTestCase {

  func test_MovieService_Failing() async throws {
    //given
    let sut: MovieAPIService = .failing
    let expected = MovieAPIService.MovieAPIServiceError.invalidResponse

    //when
    do {
      let _ = try await sut.getMovieList("")
      XCTFail()
    } catch {
      XCTAssertEqual(error as? MovieAPIService.MovieAPIServiceError, expected)
    }

  }

  func test_MovieService_EmptyResponse() async throws {
    //given
    let sut: MovieAPIService = .empty

    //when
    do {
      let result = try await sut.getMovieList("")
      XCTAssertTrue(result.isEmpty)
    } catch {
      XCTFail()
    }

  }

  func test_MovieService_Mock() async throws {
    //given
    let sut: MovieAPIService = .mock
    let expected = MoviesResponse.mock

    //when
    do {
      let result = try await sut.getMovieList("")
      XCTAssertEqual(result, expected)
    } catch {
      XCTFail()
    }
  }

  func test_MovieService_Decoder_200() async {
    let response = """
    {
      "page": 1,
      "results": [
        {
          "adult": false,
          "backdrop_path": "/lkoI9rc3OhuSYSy7gK45a3Nk9HH.jpg",
          "genre_ids": [
            28,
            53,
            18
          ],
          "id": 1620,
          "original_language": "en",
          "original_title": "Hitman",
          "overview": "Overview",
          "popularity": 28.595,
          "poster_path": "/h69UJOOKlrHcvhl5H2LY74N61DQ.jpg",
          "release_date": "2007-11-21",
          "title": "Hitman",
          "video": false,
          "vote_average": 6.081,
          "vote_count": 2977
        }
      ],
      "total_pages": 6,
      "total_results": 103
    }
    """


    let expected = [
      Movie(
        id: 1620,
        originalTitle: "Hitman",
        overview: "Overview",
        posterPath: "/h69UJOOKlrHcvhl5H2LY74N61DQ.jpg",
        releaseDate: "2007-11-21",
        title: "Hitman",
        voteAverage: 6.081
      )
    ]

    //when
    do {
      guard let data = response.data(using: .utf8), let url = URL(string: "www.test.com"), let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else {
        XCTFail()
        return
      }

      let result = try await MovieAPIService.movieListResponseDecoder(data: data, response: httpResponse, decodeTo: MoviesResponse.self).results

      XCTAssertEqual(result, expected)
    } catch {
      XCTFail()
    }
  }

  func test_MovieService_Decoder_Non200() async {
    //given
    let response = """
    {
      "page": 1,
      "results": [
        {
          "adult": false,
          "backdrop_path": "/lkoI9rc3OhuSYSy7gK45a3Nk9HH.jpg",
          "genre_ids": [
            28,
            53,
            18
          ],
          "id": 1620,
          "original_language": "en",
          "original_title": "Hitman",
          "overview": "Overview",
          "popularity": 28.595,
          "poster_path": "/h69UJOOKlrHcvhl5H2LY74N61DQ.jpg",
          "release_date": "2007-11-21",
          "title": "Hitman",
          "video": false,
          "vote_average": 6.081,
          "vote_count": 2977
        }
      ],
      "total_pages": 6,
      "total_results": 103
    }
    """

    let expected = MovieAPIService.MovieAPIServiceError.invalidResponse

    //when
    do {
      guard let data = response.data(using: .utf8), let url = URL(string: "www.test.com"), let httpResponse = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil) else {
        XCTFail()
        return
      }

      let _ = try await MovieAPIService.movieListResponseDecoder(data: data, response: httpResponse, decodeTo: MoviesResponse.self).results
    } catch {
      XCTAssertEqual(error as? MovieAPIService.MovieAPIServiceError, expected)
    }
  }

}
