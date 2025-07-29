//
//  WebView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/14/25.
//

import Foundation
import SwiftUI
import WebKit

struct WebViewRepresentable: UIViewRepresentable {
    let url: URL
    
    init(_ url: String) {
        self.url = URL(string: url)!
    }
    
    func makeUIView(context: Context) -> some UIView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}


struct WebView: View {
    @Environment(\.dismiss) var dismiss
    var url: String
    var title: String
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                WebViewRepresentable(url)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.backgroundBlack)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .foregroundStyle(.white)
                }
            }
        }
        .tint(.white)
    }
}

