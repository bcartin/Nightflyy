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
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Step 1 - Tap the “Use Your Perk” tab at the bottom of the home screen.")
                
                Text("Step 2 - Tap the glowing Nightflyy Plus button.")
                
                Text("Step 3 - Show the empty 4-digit code screen to your server, bartender, or door attendant.")
                
                Text("Step 4 - Your server will type in a code then tap redeem.")
                
                Text("Step 5 - Your perk will be provided and it should be reflected on your bill.")
                
                Text("*Afterwards, your Nightflyy Plus screen will lock until the following Monday morning.")
            }
            .foregroundStyle(.white)
            .font(.system(size: 14))
            .padding(.horizontal)
        }
    }
}
