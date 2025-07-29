//
//  ToastsManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/9/25.
//

import SwiftUI

@Observable
class ToastsManager {
    
    static let shared = ToastsManager()
    
    private init() {}
    
    var toasts: [Toast] = []
    
    func showToast(label: String, imageName: String, autoDismiss: Bool = true) {
        withAnimation(.bouncy) {
            let toast = Toast { id in
                self.ToastView(id, autoDismiss: autoDismiss, label: label, imageName: imageName)
            }
            
            toasts.append(toast)
        }
    }
    
    @ViewBuilder
    func ToastView(_ id: String, autoDismiss: Bool = true, label: String, imageName: String) -> some View {
        HStack(spacing: 12) {
            if autoDismiss {
                Spacer()
            }
            
            Image(systemName: imageName)
            
            Text(label)
                .font(.callout)
            
            Spacer(minLength: 0)
            
            if !autoDismiss {
                Button {
                    self.toasts.delete(id)
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                }
            }
        }
        .foregroundStyle(.white)
        .padding(.vertical, 12)
        .padding(.leading, 15)
        .padding(.trailing, 10)
        .background {
            Capsule()
                .fill(.mainPurple)
                .shadow(color: .black.opacity(0.06), radius: 3, x: -1, y: -3)
                .shadow(color: .black.opacity(0.06), radius: 2, x: 1, y: 3)
        }
        .padding(.horizontal, 15)
        .task {
            if autoDismiss {
                try? await Task.sleep(for: .seconds(1.5))
                self.toasts.delete(id)
            }
        }

    }
}
