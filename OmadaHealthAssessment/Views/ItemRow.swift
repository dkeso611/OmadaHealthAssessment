//
//  ItemRow.swift
//  OmadaHealthAssessment
//
//  Created by Suru Layé on 8/1/23.
//

import SwiftUI

struct ItemRow: View {
  var title: String
  var subtitle: String
  var imageURL: String
  var shouldShimmer: Bool


  var body: some View {
    if !shouldShimmer {
      itemView
    } else {
      shimmerView
    }
  }

  var itemView: some View {
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

      VStack(alignment: .leading) {
        Text(title)
          .font(.headline)
          .frame(alignment: .leading)
        Text(subtitle)
          .font(.subheadline)
        Spacer()
      }
      .multilineTextAlignment(.leading)
      .foregroundColor(.black)
      .padding()
      Spacer()
    }
    .frame(height: 100)

    .contentShape(Rectangle())
  }

  var shimmerView: some View {
    HStack {
      Image(systemName: "person")
        .resizable()
        .aspectRatio(0.75, contentMode: .fit)

      VStack(alignment: .leading) {
        Text(String(repeating: "*", count: 20))
          .font(.headline)
          .frame(alignment: .leading)
        Text(String(repeating: "*", count: 10))
          .font(.subheadline)
        Spacer()
      }
      .multilineTextAlignment(.leading)
      .foregroundColor(.black)
      .padding()
      Spacer()
    }
    .redacted(reason: .placeholder)
    .frame(height: 100)
  }
}

extension ItemRow {
  init(item: TMDBItemViewModel, shouldShimmer: Bool) {
    title = item.title
    subtitle = item.releaseYear
    imageURL = item.imageURL
    self.shouldShimmer = shouldShimmer
  }
}


struct ItemRow_Previews: PreviewProvider {
    static var previews: some View {
      ItemRow(
        title: "Movie",
        subtitle: "Date",
        imageURL: "",
        shouldShimmer: false
      )

      ItemRow(
        title: "Movie",
        subtitle: "Date",
        imageURL: "",
        shouldShimmer: true
      )
    }
}
