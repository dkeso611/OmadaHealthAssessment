//
//  DependencyContainer.swift
//  OmadaHealthAssessment
//
//  Created by Suru Layé on 8/1/23.
//

import Foundation

//Encapsulates higher level dependencies that may be used throughout the app

class DependencyContainer {
  let networkClient = NetworkClient.live()
  lazy var moviesService: MovieAPIService = .live(networkClient: networkClient)
}
