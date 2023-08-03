//
//  NetworkClientTests.swift
//  OmadaHealthAssessmentTests
//
//  Created by Suru Layé on 8/3/23.
//

import XCTest
@testable import OmadaHealthAssessment

final class NetworkClientTests: XCTestCase {

    func test_NetworkClient_Failing() async throws {
      //given
      let sut: NetworkClient = .failing
      let expected = NetworkClient.NetworkClientError.badRequest

      //when
      do {
        let _ = try await sut.request(MoviesRequest.list(query: ""))
        XCTFail()
      } catch {
        XCTAssertEqual(error as? NetworkClient.NetworkClientError, expected)
      }

    }

    func test_NetworkClient_Mock() async throws {
      //given
      let sut: NetworkClient = .mock

      //when
      do {
        let result = try await sut.request(MoviesRequest.list(query: ""))
        XCTAssertNotNil(result)
      } catch {
        XCTFail()
      }
    }
}
