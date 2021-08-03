//
//  DrawingView.swift
//  IrisDrawing
//
//  Created by Yuangang Sheng on 29.07.21.
//

import SwiftUI
import UIKit

protocol DrawingViewDelegate: AnyObject {
    func drawingView(didInit drawingOperationStack: DrawingOperationStack, drawing: DrawsanaView)

    func drawingView(didSwitchTo tool: DrawingTool)
    func drawingView(didStartDragWith tool: DrawingTool)
    func drawingView(didEndDragWith tool: DrawingTool)
    func drawingView(didChangeStrokeColor strokeColor: UIColor?)
    func drawingView(didChangeFillColor fillColor: UIColor?)
    func drawingView(didChangeStrokeWidth strokeWidth: CGFloat)
    func drawingView(didChangeFontName fontName: String)
    func drawingView(didChangeFontSize fontSize: CGFloat)
}

struct DrawingView: UIViewRepresentable {
    // MARK: - External Dependencies

    private weak var delegate: DrawingViewDelegate?

    @Binding var tool: DrawingTool?
    @Binding var strokeColor: Color
    @Binding var fillColor: Color
    @Binding var strokeWidth: CGFloat

    private var undo: (() -> Void)?
    private var redo: (() -> Void)?
    private var delete: (() -> Void)?

    // MARK: - Lifecycle

    init(
        delegate: DrawingViewDelegate? = nil,
        tool: Binding<DrawingTool?>,
        strokeColor: Binding<Color>,
        fillColor: Binding<Color>,
        strokeWidth: Binding<CGFloat>,
        undo: (() -> Void)? = nil,
        redo: (() -> Void)? = nil,
        delete: (() -> Void)? = nil
    ) {
        self.delegate = delegate
        _tool = tool
        _strokeColor = strokeColor
        _fillColor = fillColor
        _strokeWidth = strokeWidth
        self.undo = undo
        self.redo = redo
        self.delegate = delegate
    }

    // MARK: - Public Functions

    func makeUIView(context: Context) -> DrawsanaView {
        let drawingView = DrawsanaView()
        drawingView.set(tool: tool ?? PenTool())
        drawingView.userSettings.strokeColor = UIColor(strokeColor)
        drawingView.userSettings.fillColor = UIColor(fillColor)
        drawingView.userSettings.strokeWidth = strokeWidth
        drawingView.userSettings.fontName = "Marker Felt"
        drawingView.delegate = context.coordinator
        drawingView.operationStack.delegate = context.coordinator
        return drawingView
    }

    func updateUIView(_ uiView: DrawsanaView, context: Context) {
        uiView.set(tool: tool ?? PenTool())
        uiView.userSettings.strokeColor = UIColor(strokeColor)
        uiView.userSettings.fillColor = UIColor(fillColor)
        uiView.userSettings.strokeWidth = strokeWidth
    }

    func makeCoordinator() -> DrawingView.Coordinator {
        Coordinator(delegate: delegate)
    }

    class Coordinator: NSObject, DrawsanaViewDelegate, DrawingOperationStackDelegate {

        // MARK: - External Dependencies

        private weak var delegate: DrawingViewDelegate?
        private var undo: (() -> Void)?
        private var redo: (() -> Void)?
        private var delete: (() -> Void)?

        // MARK: - Lifecycle

        init(
            delegate: DrawingViewDelegate? = nil,
            undo: (() -> Void)? = nil,
            redo: (() -> Void)? = nil,
            delete: (() -> Void)? = nil
        ) {
            self.delegate = delegate
            self.undo = undo
            self.redo = redo
            self.delete = delete
        }

        // MARK: - DrawsanaViewDelegate Conformance

        func drawsanaView(_ drawsanaView: DrawsanaView, didSwitchTo tool: DrawingTool) {
//            toolButton.setTitle(drawingView.tool?.name ?? "", for: .normal)
            let drawingOperationStack = drawsanaView.operationStack
            let drawing = drawsanaView
            delegate?.drawingView(didInit: drawingOperationStack, drawing: drawing)
            delegate?.drawingView(didSwitchTo: tool)
        }

        func drawsanaView(_ drawsanaView: DrawsanaView, didChangeStrokeColor strokeColor: UIColor?) {
//            strokeColorButton.backgroundColor = drawingView.userSettings.strokeColor
//            strokeColorButton.setTitle(drawingView.userSettings.strokeColor == nil ? "x" : "", for: .normal)
            delegate?.drawingView(didChangeStrokeColor: strokeColor)
        }

        func drawsanaView(_ drawsanaView: DrawsanaView, didChangeFillColor fillColor: UIColor?) {
//            fillColorButton.backgroundColor = drawingView.userSettings.fillColor
//            fillColorButton.setTitle(drawingView.userSettings.fillColor == nil ? "x" : "", for: .normal)
            delegate?.drawingView(didChangeFillColor: fillColor)
        }

        func drawsanaView(_ drawsanaView: DrawsanaView, didChangeStrokeWidth strokeWidth: CGFloat) {
//            strokeWidthIndex = strokeWidths.firstIndex(of: drawingView.userSettings.strokeWidth) ?? 0
//            strokeWidthButton.setTitle("\(Int(strokeWidths[strokeWidthIndex]))", for: .normal)
            delegate?.drawingView(didChangeStrokeWidth: strokeWidth)
        }

        func drawsanaView(_ drawsanaView: DrawsanaView, didChangeFontName fontName: String) {}

        func drawsanaView(_ drawsanaView: DrawsanaView, didChangeFontSize fontSize: CGFloat) {}

        func drawsanaView(_ drawsanaView: DrawsanaView, didStartDragWith tool: DrawingTool) {}

        func drawsanaView(_ drawsanaView: DrawsanaView, didEndDragWith tool: DrawingTool) {}

        // MARK: - DrawingOperationStackDelegate Conformance

        func drawingOperationStackDidUndo(_ operationStack: DrawingOperationStack, operation: DrawingOperation) {
//            applyUndoViewState()
        }

        func drawingOperationStackDidRedo(_ operationStack: DrawingOperationStack, operation: DrawingOperation) {
//            applyUndoViewState()
        }

        func drawingOperationStackDidApply(_ operationStack: DrawingOperationStack, operation: DrawingOperation) {
//            applyUndoViewState()
        }
    }
}
