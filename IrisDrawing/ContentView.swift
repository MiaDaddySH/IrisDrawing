//
//  ContentView.swift
//  IrisDrawing
//
//  Created by Yuangang Sheng on 29.07.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ContainerView(viewModel: ContainerViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
