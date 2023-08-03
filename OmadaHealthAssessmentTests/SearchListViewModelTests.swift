//
//  SearchListViewModelTests.swift
//  OmadaHealthAssessmentTests
//
//  Created by Suru Layé on 8/3/23.
//

import XCTest
@testable import OmadaHealthAssessment

final class SearchListViewModelTests: XCTestCase {

  func test_ListViewModelState_Loading() async {
    // given
    let sut = await SearchListViewModel(service: .mock)


    //when
    let _ = await sut.$state.sink(
      receiveValue: { value in
        switch value {
          case  .loading:
           XCTAssert(true)
          default:
            XCTFail()
        }
      }
    )
  }

  func test_ListViewModelState_Error() async {
    // given
    let sut = await SearchListViewModel(service: .failing)

    //when
    await sut.load()
    let _ = await sut.$state.sink(
      receiveValue: { value in
        switch value {
          case  .error(let title, let cta):
            XCTAssertNotNil(title)
            XCTAssertNotNil(cta)
          default:
            XCTFail()
        }
      }
    )
  }

  func test_ListViewModelState_Value() async throws {
    // given
    let sut = await SearchListViewModel(service: .empty)

    //when
    await sut.load()
    let _ = await sut.$state.sink(
      receiveValue: { value in
        switch value {
          case .value(let query, let list):
            XCTAssertNotNil(query)
            XCTAssertNotNil(list)
          default:
            XCTFail()
        }
      }
    )
  }
}
