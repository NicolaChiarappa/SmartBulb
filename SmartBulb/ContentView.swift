//
//  ContentView.swift
//  SmartBulb
//
//  Created by Nicola Chiarappa on 21/11/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "lightbulb.circle.fill")
                .font(.system(size: 75))
                .foregroundStyle(.tint)
            Text("Hello, I'm SmartBulb")
                .foregroundStyle(.tint)
                .font(.system(size: 35, weight: .bold, design: .rounded))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
