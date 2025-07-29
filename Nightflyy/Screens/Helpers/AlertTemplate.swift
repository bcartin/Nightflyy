//
//  AlertTemplate.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/8/25.
//

import SwiftUI

struct AlertTemplate: View {
    
    @State private var showAlert = true
    
    var body: some View {
        ScrollView {
            Button("Show Alert") {
                showAlert.toggle()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.backgroundBlack)
        .alert(isPresented: $showAlert) {
            CustomDialog(title: "Unfollow NinjaTacos", content: nil,  button1: .init(content: "Unfollow", tint: .mainPurple, foreground: .white, action: { folder in
                print(folder)
                showAlert = false
            }), button2: .init(content: "Cancel", tint: .white.opacity(0.5), foreground: .white, action: { _ in
                showAlert = false
            }), addsTextField: false, textFieldHint: "personal documents")
            .transition(.blurReplace.combined(with: .push(from: .bottom)))
        } background: {
            Rectangle()
                .fill(.primary.opacity(0.35))
        }
        
        
    }
}

#Preview {
    AlertTemplate()
//        .preferredColorScheme(.dark)
}

struct CustomDialog: View {
    var title: String
    var content: String? 
    var image: Config = .init(content: "folder.fill.badge.plus", tint: .mainPurple, foreground: .backgroundBlackLight)
    var button1: Config
    var button2: Config?
    var addsTextField: Bool = false
    var textFieldHint: String = ""
    
    @State private var text: String = ""
    
    var body: some View {
        VStack(spacing: 15) {
            Image("ic_hub")
                .resizable()
                .font(.title)
                .foregroundStyle(image.foreground)
                .frame(width: 65, height: 65)
                .background(image.tint.gradient, in: .circle)
                .background {
                    Circle()
                        .stroke(.clear, lineWidth: 4)
                }
            
            Text(title)
                .font(.title3.bold())
                .foregroundStyle(.white)
                .padding(.top, 8)
            
            if let content {
                Text(content)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .foregroundStyle(.gray)
            }
            
            if addsTextField {
                TextField(textFieldHint, text: $text)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray.opacity(0.2))
                    )
                    .padding(.bottom, 5)
            }
            
            ButtonView(button1)
                .padding(.top, 8)
            
            if let button2 {
                ButtonView(button2)
                    .padding(.top, -5)
            }
        }
        .padding([.horizontal, .bottom], 15)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.backgroundBlackLight)
                .stroke(.black, lineWidth: 2)
                .padding(.top, 30)
        }
        .frame(maxWidth: 310)
        .compositingGroup()
    }
    
    @ViewBuilder
    private func ButtonView(_ config: Config) -> some View {
        Button {
            config.action(addsTextField ? text : "")
        } label: {
            Text(config.content)
                .fontWeight(.bold)
                .foregroundStyle(config.foreground)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(config.tint.gradient, in: .rect(cornerRadius: 10))
                
        }

    }
    
    struct Config {
        var content: String
        var tint: Color
        var foreground: Color
        var action: (String) -> () = { _ in }
    }
}
