//
//  TMDBItemServiceTests.swift
//  OmadaHealthAssessmentTests
//
//  Created by Suru Layé on 8/3/23.
//

import XCTest
@testable import OmadaHealthAssessment

final class TMDBItemServiceTests: XCTestCase {

  func test_MovieItemServiceAdapter_Failing() async throws {
    //given
    let sut: TMDBItemService = MovieItemServiceAdapter.adapt(from: .failing)
    let expected = MovieAPIService.MovieAPIServiceError.invalidResponse

    //when
    do {
      let _ = try await sut.getItems("")
      XCTFail()
    } catch {
      XCTAssertEqual(error as? MovieAPIService.MovieAPIServiceError, expected)
    }

  }

  func test_MovieItemService_EmptyResponse() async throws {
    //given
    let sut: TMDBItemService = MovieItemServiceAdapter.adapt(from: .empty)

    //when
    do {
      let result = try await sut.getItems("")
      XCTAssertTrue(result.isEmpty)
    } catch {
      XCTFail()
    }

  }

  func test_MovieItemService_Mock() async throws {
    //given
    let sut: TMDBItemService = MovieItemServiceAdapter.adapt(from: .mock)
    let expected = MoviesResponse.mock.map { TMDBItemViewModel(movie: $0) }

    //when
    do {
      let result = try await sut.getItems("")
      XCTAssertEqual(result, expected)
    } catch {
      XCTFail()
    }
  }
}
