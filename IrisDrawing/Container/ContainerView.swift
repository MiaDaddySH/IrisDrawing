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
                DrawingView(
                    delegate: viewModel,
                    tool: $viewModel.tool,
                    strokeColor: $viewModel.strokeColor,
                    fillColor: $viewModel.fillColor,
                    strokeWidth: $viewModel.strokeWidth
                ).background(Image("Goldeck").resizable().aspectRatio(contentMode: .fill))
                underBar
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }

    // MARK: - Views

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

            Spacer()

            // stroke color
            ColorPicker("s", selection: $viewModel.strokeColor)

            // fill color
            ColorPicker("f", selection: $viewModel.fillColor)

            Spacer()
            Button(
                action: { viewModel.showReview() },
                label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                }
            ).padding()

            Picker(selection: $viewModel.strokeWidth, label: Image(systemName: "pencil.tip.crop.circle")) {
                ForEach(viewModel.strokeWidths, id: \.self) {
                    Text("\(Int($0))")
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            Picker("Tools", selection: $viewModel.selectedTool) {
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
            destination: ReviewView(),
            isActive: $viewModel.shouldPresentReview
        ) {
            Button(
                action: { viewModel.showReview() },
                label: {
                    Image(systemName: "doc.text.fill.viewfinder")
                }
            ).padding()
        }
    }

//    private var reviewView: AnyView? {
//        guard let settingViewModel = viewModel.createSettingsViewModel() else { return nil }
//        return SettingsView(viewModel: settingViewModel)
//            .asAnyView()
//    }
}

// MARK: - Preview

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView(viewModel: ContainerViewModel())
    }
}
