//
//  ListView.swift
//  OmadaHealthAssessment
//
//  Created by Suru Layé on 8/1/23.
//


import SwiftUI

struct ListViewContainer: View {
  @ObservedObject var viewModel: SearchListViewModel

  var body: some View {
    NavigationStack {
      switch viewModel.state {
        case .loading:
          LoadingView()
        case .error(let title, let cta):
          ErrorView(
            title: title,
            cta: cta,
            retry: {
              Task {
                await viewModel.load()
              }
            }
          )
        case .value(let query, let list):
          ListView(
            viewState: .init(query: query, list: list),
            onQueryUpdate: { query in
              viewModel.update(query: query)
            }
          )
      }
    }
    .task {
      await viewModel.load()
    }
  }
}

struct ListView: View {
  struct ViewState: Equatable {
      var query: String
      var list: [TMDBItemViewModel]
  }

  let viewState: ViewState
  var onQueryUpdate: ((String) -> ())?

  @State private(set) var queryString: String = ""
  @State private(set) var shouldShimmer = false


  var body: some View {
    listView(list: viewState.list)
      .padding(.horizontal)
      .onAppear {
        queryString = viewState.query
      }
      .searchable(text: $queryString)
      .onChange(
          of: queryString,
          perform: { query in
              shouldShimmer = true
              onQueryUpdate?(query)
          }
      )
      .onChange(
          of: viewState,
          perform: { state in
              shouldShimmer = false
          }
      )
      .navigationTitle("Movie Search")
  }

 @ViewBuilder private func listView(list: [TMDBItemViewModel]) -> some View {
   if list.isEmpty {
     noResultsView()
   } else {
     ScrollView(showsIndicators: false) {
       VStack {
         ForEach(list) { item in
           NavigationLink(value: item) {
             VStack {
               ItemRow(item: item, shouldShimmer: shouldShimmer)
               Divider()
             }
           }
         }
       }
     }
     .navigationDestination(
      for: TMDBItemViewModel.self,
      destination: { item in
        DetailView(item: item)
          .navigationBarTitleDisplayMode(.inline)
      }
     )
   }
 }

  private func noResultsView() -> some View {
    VStack {
      Text("No results")
    }
  }

}


struct ListView_Previews: PreviewProvider {
  static let items =  MoviesResponse.mock.map { TMDBItemViewModel(movie: $0) }
  static let mockViewModel: SearchListViewModel = .init(service: MovieItemServiceAdapter.adapt(from: .mock))
  static let failingViewModel: SearchListViewModel = .init(service: MovieItemServiceAdapter.adapt(from: .failing))

  static let liveViewModel: SearchListViewModel = .init(service: MovieItemServiceAdapter.adapt(from: .live(networkClient: NetworkClient.live())))

  static var previews: some View {
    ListView(viewState: .init(query: "Power", list: items))
    ListView(viewState: .init(query: "", list: []))
    ListViewContainer(viewModel: mockViewModel)
    ListViewContainer(viewModel: failingViewModel)
    ListViewContainer(viewModel: liveViewModel)
  }
}

