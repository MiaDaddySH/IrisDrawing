//
//  ContainerView.swift
//  IrisDrawing
//
//  Created by Yuangang Sheng on 30.07.21.
//

import SwiftUI
struct ContainerView: View {
    // MARK: - External Dependencies

    @ObservedObject private var viewModel: ContainerViewModel

    // MARK: - Lifecycle

    init(viewModel: ContainerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                topBar
                drawingView
                underBar
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }

    // MARK: - Views

    private var drawingView: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                resizedImage(for: geo)
                DrawingView(
                    delegate: viewModel,
                    tool: $viewModel.tool,
                    strokeColor: $viewModel.strokeColor,
                    fillColor: $viewModel.fillColor,
                    strokeWidth: $viewModel.strokeWidth
                ).frame(height: geo.size.height)
            }
        }
    }

    private var topBar: some View {
        HStack {
            Button(
                action: { viewModel.delete() },
                label: {
                    Image(systemName: "trash.fill")
                }
            ).padding()
            Spacer()
            reviewButton
        }
    }

    private var underBar: some View {
        HStack {
            Button(
                action: { viewModel.undo() },
                label: {
                    Image(systemName: "arrow.uturn.backward.circle.fill")
                }
            ).padding()
            
            Button(
                action: { viewModel.redo() },
                label: {
                    Image(systemName: "arrow.uturn.forward.circle.fill")
                }
            ).padding()

            // stroke color
            ColorPicker("", selection: $viewModel.strokeColor)
                .padding()

            // fill color
            ColorPicker("", selection: $viewModel.fillColor)
                .padding()

            Picker(selection: $viewModel.strokeWidth, label: Image(systemName: "pencil.tip.crop.circle")) {
                ForEach(viewModel.strokeWidths, id: \.self) {
                    Text("\(Int($0))")
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            Picker(selection: $viewModel.selectedTool, label: Image(systemName: "scribble.variable")) {
                ForEach(viewModel.tools, id: \.self.name) {
                    Text($0.name)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
        }
    }

    private var reviewButton: some View {
        NavigationLink(
            destination: ReviewView(viewModel: viewModel.reviewViewModel),
            isActive: $viewModel.shouldPresentReview
        ) {
            Button(
                action: {
                    let screenshot = drawingView.takeScreenshot(origin: viewModel.drawingViewFrame!.origin, size: viewModel.drawingViewFrame!.size)
                    viewModel.showReview(with: screenshot)
                },
                label: {
                    Image(systemName: "doc.text.fill.viewfinder")
                }
            ).padding()
        }
    }

    // MARK: - Private Functions

    private func resizedImage(for metrics: GeometryProxy) -> some View {
        let image = Image(uiImage: viewModel.selectedImage!).resizable().aspectRatio(contentMode: .fit)
        let size = CGSize(width: metrics.size.width,
                          height: metrics.size.height)
        viewModel.drawingViewFrame = metrics.frame(in: .global)
        return image
            .frame(width: size.width, height: size.height)
    }
}

// MARK: - Preview

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView(viewModel: ContainerViewModel())
    }
}
