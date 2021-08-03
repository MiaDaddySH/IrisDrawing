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
    @Published var strokeColor = Color.red
    @Published var fillColor = Color.green
    @Published var strokeWidth: CGFloat = 3
    @Published var shouldPresentReview = false
    var drawingViewFrame: CGRect?

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

    // MARK: - Private Properties

    private var drawingOperationStack: DrawingOperationStack?
    private var selectedShape: ShapeSelectable?
    private var drawingView: DrawsanaView?
    var selectedImage: UIImage?

    var reviewViewModel = ReviewViewModel(UIImage(named: "Goldeck", in: .irisDrawing, with: nil)!)

    // MARK: - Lifecycle

    init() {
        selectedImage = UIImage(named: "Goldeck", in: .irisDrawing, with: nil)
    }

    // MARK: - Public Functions

    func showReview(with image: UIImage?) {
        guard let image = image else { return }
        viewFinalImage(with: image)
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

    var savedImageURL: URL {
        return FileManager.default.temporaryDirectory.appendingPathComponent("drawing_demo").appendingPathExtension("jpg")
    }

    /// Show rendered image in a separate view
    @objc private func viewFinalImage(with image: UIImage) {
        // Dump JSON to console just to demonstrate
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let jsonData = try! jsonEncoder.encode(drawingView?.drawing)
        print(String(data: jsonData, encoding: .utf8)!)

        // Decode as a sanity check in lieu of unit tests
        let jsonDecoder = JSONDecoder()
        _ = try! jsonDecoder.decode(Drawing.self, from: jsonData)

        guard
            let image = render(over: image),
            let data = image.jpegData(compressionQuality: 0.75),
            (try? data.write(to: savedImageURL)) != nil
        else {
            assert(false, "Can't create or save image")
            return
        }

        reviewViewModel = ReviewViewModel(UIImage(data: data)!)
    }

    public func render(over image: UIImage?, scale: CGFloat = 0.0) -> UIImage? {
        guard let drawing = drawingView?.drawing else { return nil }
        let size = image?.size ?? drawing.size
        let shapesImage = render(size: size, scale: scale)
        return DrawsanaUtilities.renderImage(size: size, scale: scale) { (_: CGContext) -> Void in
            image?.draw(at: .zero)
            shapesImage?.draw(at: .zero)
        }
    }

    /// Render the drawing. If you pass a size, shapes are re-scaled to be full
    /// resolution at that size, otherwise the view size is used.
    public func render(size: CGSize? = nil, scale: CGFloat = 0.0) -> UIImage? {
        guard let drawing = drawingView?.drawing else { return nil }
        let size = size ?? drawing.size
        return DrawsanaUtilities.renderImage(size: size, scale: scale) { (context: CGContext) -> Void in
            context.saveGState()
            context.scaleBy(
                x: size.width / drawing.size.width,
                y: size.height / drawing.size.height
            )
            for shape in drawing.shapes {
                shape.render(in: context)
            }
            context.restoreGState()
        }
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
            control.view.transform = CGAffineTransform(scaleX: 1 / transform.scale, y: 1 / transform.scale)
        }
    }

    // MARK: - Private Functions

    private func getRightTool() -> DrawingTool? {
        return tools.first(where: { $0.name == selectedTool })
    }

    // MARK: - TextToolDelegate Conformance

    func selectionToolDidTapOnAlreadySelectedShape(_ shape: ShapeSelectable) {
        print("The selected shape:\(shape)")
        selectedShape = shape
    }

    // MARK: - DrawingViewDelegate Conformance

    func drawingView(didInit drawingOperationStack: DrawingOperationStack, drawing: DrawsanaView) {
        self.drawingOperationStack = drawingOperationStack
        drawingView = drawing
    }

    func drawingView(didSelected selectedShape: ShapeSelectable?) {}

    func drawingView(didSwitchTo tool: DrawingTool) {}

    func drawingView(didStartDragWith tool: DrawingTool) {}

    func drawingView(didEndDragWith tool: DrawingTool) {}

    func drawingView(didChangeStrokeColor strokeColor: UIColor?) {}

    func drawingView(didChangeFillColor fillColor: UIColor?) {}

    func drawingView(didChangeStrokeWidth strokeWidth: CGFloat) {}

    func drawingView(didChangeFontName fontName: String) {}

    func drawingView(didChangeFontSize fontSize: CGFloat) {}
}
