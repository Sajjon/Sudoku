//
//  GradientButton.swift
//  FrontendSources
//
//  Created by Alexander Cyon on 2021-01-17.
//

import SwiftUI

struct GradientButton: View {
    let title: String
    let colors: [Color]
    let action: () -> Void
    
    init(
        _ title: String,
        colors: [Color] = [.darkGreen, .lightGreen],
        action: @escaping () -> Void
    ) {
        self.title = title
        self.colors = colors
        self.action = action
    }
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: action) {
                HStack {
                    Text("\(title)")
                        .fontWeight(.semibold)
                        .font(.title)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(
                    LinearGradient(
                        gradient: .init(colors: colors),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(geometry.size.height / 2)
            }
        }
    }
}
