//
//  YouTubePlayerView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/9/26.
//

import SwiftUI
import WebKit

struct YouTubePlayerViewRepresentable: UIViewRepresentable {
    let videoID: String
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        // Allow the video to play inside the app instead of forcing fullscreen
//        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.isScrollEnabled = false
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Construct the embed URL with parameters
        let embedURLString = "https://www.youtube.com/embed/\(videoID)?playsinline=1"
        
        guard let url = URL(string: embedURLString) else { return }
        var request = URLRequest(url: url)
        request.setValue("https://nightflyy.com", forHTTPHeaderField: "Referer")
        request.setValue("https://nightflyy.com", forHTTPHeaderField: "Origin")
        uiView.load(request)
    }
}

// https://www.youtube.com/embed/0bGwcFEffBE?playsinline=1

struct YouTubePlayerView: View {
    let videoID: String
    
    var body: some View {
        VStack {
            YouTubePlayerViewRepresentable(videoID: videoID)
                .frame(height: 250)
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding()
        }
    }
}
