//
//  ContainerViewModel.swift
//  IrisDrawing
//
//  Created by Yuangang Sheng on 30.07.21.
//

import SwiftUI

/// ViewModel for Container scene.
final class ContainerViewModel: ObservableObject, TextToolDelegate, SelectionToolDelegate {

    // MARK: - Public Properties

    @Published var shouldPresentToolsSelection = false

    @Published var toolIndex: Int = 0
    @Published var colorIndex: Int = 0
    @Published var selectedTool: String = "" {
        didSet {
            tool = getRightTool()
        }
    }

    @Published var tool: DrawingTool?
    @Published var strokeColor: UIColor = UIColor.black
    @Published var fillColor: UIColor = UIColor.white
    @Published var strokeWidth: CGFloat = 0

    /// Instance of `TextTool` for which we are the delegate, so we can respond
    /// to relevant UI events
    lazy var textTool = { TextTool(delegate: self) }()

    /// Instance of `SelectionTool` for which we are the delegate, so we can
    /// respond to relevant UI events
    lazy var selectionTool = { SelectionTool(delegate: self) }()

    lazy var tools: [DrawingTool] = { [
        PenTool(),
        textTool,
        selectionTool,
        EllipseTool(),
        EraserTool(),
        LineTool(),
        ArrowTool(),
        RectTool(),
        StarTool(),
        TriangleTool(),
        PentagonTool(),
        AngleTool(),
    ] }()

    let strokeWidths: [CGFloat] = [1, 3, 5, 8, 10, 16, 20]

    // MARK: - External Dependencies

    // MARK: - Lifecycle

    init(
    ) {}

    // MARK: - Public Functions

    func onAppear() {}

    func showTools() {
        shouldPresentToolsSelection = true
    }

    // MARK: - TextToolDelegate Conformance

    func textToolPointForNewText(tappedPoint: CGPoint) -> CGPoint {
        return tappedPoint
    }

    func textToolDidTapAway(tappedPoint: CGPoint) {
//        drawingView.set(tool: self.selectionTool)
    }

    func textToolWillUseEditingView(_ editingView: TextShapeEditingView) {}

    func textToolDidUpdateEditingViewTransform(_ editingView: TextShapeEditingView, transform: ShapeTransform) {
        for control in editingView.controls {
            control.view.transform = CGAffineTransform(scaleX: 1/transform.scale, y: 1/transform.scale)
        }
    }

    // MARK: - TextToolDelegate Conformance

    func selectionToolDidTapOnAlreadySelectedShape(_ shape: ShapeSelectable) {
//        if shape as? TextShape != nil {
//          drawingView.set(tool: textTool, shape: shape)
//        } else {
//          drawingView.toolSettings.selectedShape = nil
//        }
    }

    private func getRightTool() -> DrawingTool? {
        return tools.first(where: { $0.name == selectedTool })
    }
}
