//
//  HomeView.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 29/09/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    var body: some View {
        
        Text("Transcribed Text: \(viewModel.transcribedText)")
            .onTapGesture {
                viewModel.startRecording()
            }
        
        Text("Start Recording")
            .onTapGesture {
                viewModel.startRecording()
            }
        
        Text("Stop Recoding")
            .onTapGesture {
                viewModel.stopRecording()
            }
    }
}

#Preview {
    HomeView()
}
