//
//  DetailView.swift
//  OmadaHealthAssessment
//
//  Created by Suru Layé on 8/1/23.
//

import SwiftUI

struct DetailView: View {
  var imageURL: String
  var title: String
  var subtitle: String
  var ratingTitle: String
  var rating: Double
  var description: String

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading) {
        detailStackView
        Divider()
        overviewStackView
        Divider()
        Spacer()
      }
    }
    .padding(.horizontal)
  }

  var detailStackView: some View {
    HStack {
      AsyncImage(
        url: URL(string: imageURL),
        content: { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
        },
        placeholder: {
          Image(systemName: "person")
            .resizable()
            .aspectRatio(0.75, contentMode: .fit)
            .redacted(reason: .placeholder)
        }
      )
      .frame(height: 100)
      
      VStack(alignment: .leading) {
        Text(title)
          .font(.headline)
          .fixedSize(horizontal: false, vertical: true)
        Text(subtitle)
          .font(.footnote)
          .padding(.bottom, 4)

        ratingView
      }
      .padding()
    }
  }

  var ratingView: some View {
    ProgressView(value: rating) {
      Text("Viewer Rating")
        .font(.footnote)
      Text(ratingTitle)
        .font(.headline)
    }
    .tint(.red)
  }

  var overviewStackView: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("OVERVIEW")
        .font(.headline)
      Text(description)
        .multilineTextAlignment(.leading)
    }
  }
}

extension DetailView {
  init(item: TMDBItemViewModel) {
    imageURL = item.imageURL
    title = item.title
    subtitle = item.releaseDate
    ratingTitle = item.rating
    rating = item.ratingValue
    description = item.description
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
      DetailView(
        imageURL: "www.try.com" ,
        title: "Avengers",
        subtitle: "Jan 24, 2019",
        ratingTitle: "8.3 / 10",
        rating: 0.83,
        description: "Overview text"
      )
  }
}
