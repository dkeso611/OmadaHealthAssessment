//
//  ItemViewModel.swift
//  OmadaHealthAssessment
//
//  Created by Suru Layé on 8/1/23.
//

import Foundation

struct TMDBItemViewModel: Identifiable, Equatable {
  let id: Int
  let imageURL: String
  let title: String
  let releaseDate: String
  let releaseYear: String
  let ratingValue: Double
  let rating: String
  let description: String
}

extension TMDBItemViewModel {
  init(movie: Movie) {
    var movieReleaseYear: String {
      movie.releaseDate.changeDateFormat(fromFormat: "yyyy-MM-dd", toFormat: "yyyy")
    }

    var movieReleaseDate: String {
      movie.releaseDate.changeDateFormat(fromFormat: "yyyy-MM-dd", toFormat: "MMMM d, yyyy")
    }

    var movieRatingValue: Double {
      return movie.voteAverage.roundedToTenths() / 10
    }

    var movieRating: String {
      "\(movie.voteAverage.roundedToTenths()) / 10"
    }

    id = movie.id
    imageURL = movie.imageURL ?? ""
    title = movie.title
    releaseDate = movieReleaseDate
    releaseYear = movieReleaseYear
    ratingValue = movieRatingValue
    rating = movieRating
    description = movie.overview
  }
}

extension TMDBItemViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
      hasher.combine(self.id)
      hasher.combine(self.title)
      hasher.combine(self.releaseDate)
      hasher.combine(self.ratingValue)
      hasher.combine(self.description)
    }
}
