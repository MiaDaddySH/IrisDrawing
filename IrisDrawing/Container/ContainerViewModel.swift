//
//  ContainerViewModel.swift
//  IrisDrawing
//
//  Created by Yuangang Sheng on 30.07.21.
//

import SwiftUI

/// ViewModel for Container scene.
final class ContainerViewModel: ObservableObject, TextToolDelegate, SelectionToolDelegate, DrawingViewDelegate {

    // MARK: - Public Properties

    @Published var selectedTool: String = "Pen" {
        didSet {
            tool = getRightTool()
        }
    }

    @Published var tool: DrawingTool?
    @Published var strokeColor = Color.black
    @Published var fillColor = Color.white
    @Published var strokeWidth: CGFloat = 5
    @Published var shouldPresentReview = false

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
    let colors: [UIColor] = [.black, .white, .red, .orange, .yellow, .green, .blue, .purple, .brown, .gray]

    // MARK: - External Dependencies

    // MARK: - Private Properties

    private var drawingOperationStack: DrawingOperationStack?
    private var selectedShape: ShapeSelectable?

    // MARK: - Lifecycle

    init(
    ) {}

    // MARK: - Public Functions

    func onAppear() {}
    func showReview() {
        shouldPresentReview = true
    }

    func undo() {
        guard let operationStack = drawingOperationStack, operationStack.canUndo else { return }
        operationStack.undo()
    }

    func redo() {
        guard let operationStack = drawingOperationStack, operationStack.canRedo else { return }
        operationStack.redo()
    }

    func delete() {
        guard let operationStack = drawingOperationStack, let selectedShape = selectedShape else { return }
        operationStack.apply(operation: RemoveShapeOperation(shape: selectedShape))
    }

//    @objc private func viewFinalImage(_ sender: Any?) {
//      // Dump JSON to console just to demonstrate
//      let jsonEncoder = JSONEncoder()
//      jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
//      let jsonData = try! jsonEncoder.encode(drawingView.drawing)
//      print(String(data: jsonData, encoding: .utf8)!)
//
//      // Decode as a sanity check in lieu of unit tests
//      let jsonDecoder = JSONDecoder()
//      let _ = try! jsonDecoder.decode(Drawing.self, from: jsonData)
//
//      guard
//        let image = drawingView.render(over: imageView.image),
//        let data = image.jpegData(compressionQuality: 0.75),
//        (try? data.write(to: savedImageURL)) != nil else
//      {
//        assert(false, "Can't create or save image")
//        return
//      }
//      let vc = QLPreviewController(nibName: nil, bundle: nil)
//      vc.dataSource = self
//      present(vc, animated: true, completion: nil)
//    }

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

    // MARK: - Private Functions

    private func getRightTool() -> DrawingTool? {
        return tools.first(where: { $0.name == selectedTool })
    }

    // MARK: - TextToolDelegate Conformance

    func selectionToolDidTapOnAlreadySelectedShape(_ shape: ShapeSelectable) {
        print("The selected shape:\(shape)")
        self.selectedShape = shape
    }

    // MARK: - DrawingViewDelegate Conformance

    func drawingView(didInit drawingOperationStack: DrawingOperationStack) {
        self.drawingOperationStack = drawingOperationStack
    }

    func drawingView(didSelected selectedShape: ShapeSelectable?) {
        
    }

    func drawingView(didSwitchTo tool: DrawingTool) {}

    func drawingView(didStartDragWith tool: DrawingTool) {}

    func drawingView(didEndDragWith tool: DrawingTool) {}

    func drawingView(didChangeStrokeColor strokeColor: UIColor?) {}

    func drawingView(didChangeFillColor fillColor: UIColor?) {}

    func drawingView(didChangeStrokeWidth strokeWidth: CGFloat) {}

    func drawingView(didChangeFontName fontName: String) {}

    func drawingView(didChangeFontSize fontSize: CGFloat) {}
}
