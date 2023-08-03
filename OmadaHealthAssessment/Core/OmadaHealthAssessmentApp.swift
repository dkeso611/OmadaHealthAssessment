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
    }
  }

  @MainActor private func makeSearchListViewContainer() -> ListViewContainer {
    let itemService = MovieItemServiceAdapter.adapt(from: dependencyContainer.moviesService)
    let viewModel = SearchListViewModel(service: itemService)
    let container = ListViewContainer(viewModel: viewModel)
    return container
  }
}
