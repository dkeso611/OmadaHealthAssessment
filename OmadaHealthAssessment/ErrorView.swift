//
//  ErrorView.swift
//  OmadaHealthAssessment
//
//  Created by Suru Layé on 8/1/23.
//

import SwiftUI

struct ErrorView: View {
  var title: String
  var cta: String?
  var retry: (() -> ())?

  var body: some View {
    VStack {
      Text(title)

      if let cta = cta, !cta.isEmpty {
        Button {
          retry?()
        } label: {
          Text(cta)
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8.0)
        }
      }
    }
  }
}

struct ErrorView_Previews: PreviewProvider {
  static var previews: some View {
    ErrorView(title: "ERROR: Please try again", cta: "Tap to retry")
    ErrorView(title: "ERROR: Please try again", cta: nil)

  }
}
