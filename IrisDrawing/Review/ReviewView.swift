//
//  ReviewView.swift
//  IrisDrawing
//
//  Created by Yuangang Sheng on 02.08.21.
//

import SwiftUI

struct ReviewView: View {
    // MARK: - External Dependencies

    @ObservedObject private var viewModel: ReviewViewModel

    // MARK: - Lifecycle

    init(viewModel: ReviewViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
        return GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Image(uiImage: viewModel.image!).resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: geo.size.height)
            }
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(viewModel: ReviewViewModel(nil))
    }
}
