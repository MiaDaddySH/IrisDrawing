//
//  ReviewViewModel.swift
//  IrisDrawing
//
//  Created by Yuangang Sheng on 02.08.21.
//

import SwiftUI

/// ViewModel for Review scene.
final class ReviewViewModel: ObservableObject {

    // MARK: - Public Properties

    @Published var image: UIImage

    // MARK: - External Dependencies

    // MARK: - Private Properties

    private var drawingOperationStack: DrawingOperationStack?
    private var selectedShape: ShapeSelectable?

    // MARK: - Lifecycle

    init(_ image: UIImage) {
        self.image = image
    }

    // MARK: - Public Functions

    func onAppear() {}
}
