//
//  ReviewView.swift
//  IrisDrawing
//
//  Created by Yuangang Sheng on 02.08.21.
//

import Mantis
import SwiftUI

struct ReviewView: View {
    @State private var showingCropper = false
    @State private var cropShapeType: Mantis.CropShapeType = .rect
    @State private var presetFixedRatioType: Mantis.PresetFixedRatioType = .canUseMultiplePresetFixedRatio()

    // MARK: - External Dependencies

    @ObservedObject private var viewModel: ReviewViewModel

    // MARK: - Lifecycle

    init(viewModel: ReviewViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
        VStack {
            Spacer()
            Image(uiImage: viewModel.image)
                .resizable().aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
            Spacer()
            Button("Normal") {
                reset()
                showingCropper = true
            }.font(.title)
            Button("Circle Crop") {
                reset()
                cropShapeType = .circle()
                showingCropper = true
            }.font(.title)
            Button("Keep 1:1 ratio") {
                reset()
                presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 1)
                showingCropper = true
            }.font(.title)
            Spacer()
        }.fullScreenCover(isPresented: $showingCropper, content: {
            ImageCropper(image: $viewModel.image,
                         cropShapeType: $cropShapeType,
                         presetFixedRatioType: $presetFixedRatioType)
                .ignoresSafeArea()
        })
    }

    func reset() {
        viewModel.image = viewModel.image
        cropShapeType = .rect
        presetFixedRatioType = .canUseMultiplePresetFixedRatio()
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(viewModel: ReviewViewModel(UIImage(named: "Goldeck")!))
    }
}
