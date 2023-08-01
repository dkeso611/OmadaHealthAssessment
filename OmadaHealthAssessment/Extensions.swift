//
//  Extensions.swift
//  OmadaHealthAssessment
//
//  Created by Suru Layé on 8/1/23.
//

import Foundation

extension String {
  func changeDateFormat(fromFormat: String, toFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = fromFormat
    let date = dateFormatter.date(from: self)

    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = toFormat

    guard let unwrappedDate = date else {
      return self
    }

    return outputFormatter.string(from: unwrappedDate)
  }
}

extension Double {
  func roundedToTenths() -> Double {
    let product = self * 10
    let rounded = product.rounded()
    return  rounded / 10
  }
}
