//
//  OmadaHealthAssessmentApp.swift
//  OmadaHealthAssessment
//
//  Created by Suru Layé on 8/1/23.
//

import SwiftUI

@main
struct OmadaHealthAssessmentApp: App {

  let dependencyContainer = DependencyContainer()

  var body: some Scene {
    WindowGroup {
      makeSearchListViewContainer()
        .onAppear {
          Task {
            let response = try await dependencyContainer.networkClient.request(MoviesRequest.details(id: 118408))
            let result =  try JSONSerialization.jsonObject(with: response.0)
            print(result)
          }
        }
    }
  }

  @MainActor private func makeSearchListViewContainer() -> ListViewContainer {
    let viewModel = SearchListViewModel(service: dependencyContainer.moviesService)
    let container = ListViewContainer(viewModel: viewModel)
    return container
  }
}
