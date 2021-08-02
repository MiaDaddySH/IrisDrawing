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
        VStack(spacing: 0) {
            HStack {
                Button(
                    action: { viewModel.showTools() },
                    label: {
                        Image(systemName: "trash.fill")
                    }
                ).padding()
                Spacer()
                Button(
                    action: { viewModel.showTools() },
                    label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                ).padding()
            }

            DrawingView(
                tool: $viewModel.tool,
                strokeColor: $viewModel.strokeColor,
                fillColor: $viewModel.fillColor,
                strokeWidth: $viewModel.strokeWidth
            ).background(Color.green)

            HStack {
                Button(
                    action: { viewModel.undo()},
                    label: {
                        Image(systemName: "arrow.uturn.backward.circle.fill")
                    }
                ).padding()
                Button(
                    action: { viewModel.showTools() },
                    label: {
                        Image(systemName: "arrow.uturn.forward.circle.fill")
                    }
                ).padding()
                
                Spacer()
                
                //stroke color
                ColorPicker("s", selection: $viewModel.strokeColor)
                
                //fill color
                ColorPicker("f", selection: $viewModel.fillColor)
                
                Spacer()
                Button(
                    action: { viewModel.showTools() },
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
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button(action: {}) {
                        Label("Create a file", systemImage: "doc")
                    }

                    Button(action: {}) {
                        Label("Create a folder", systemImage: "folder")
                    }
                }
                label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView(viewModel: ContainerViewModel())
    }
}
