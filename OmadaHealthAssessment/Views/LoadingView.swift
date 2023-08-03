//
//  LoadingView.swift
//  OmadaHealthAssessment
//
//  Created by Suru Layé on 8/1/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Text("Loading")
            ProgressView()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
