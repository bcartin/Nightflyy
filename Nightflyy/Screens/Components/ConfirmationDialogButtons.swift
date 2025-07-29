//
//  ConfirmationDialogButtons.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/18/25.
//

import SwiftUI

struct ConfirmationDialogButtons: View {
    
    //State values
    @State private var showButtonDialog = true
    
    //Body
    var body: some View {
        ZStack {
            VStack {
                Button("Open button dialog") {
                    showButtonDialog.toggle()
                }
            }
            .buttonStyle(.borderedProminent)
            .buttonDialog(
                isPresented: $showButtonDialog,
            ) {
                Button("Action 1") {}
                Button("Action 2") {}
                Button("Action 3") {}
            }
        }
        .tint(.green)
    }
}

extension View {
    func buttonDialog(
        
        title: String? = nil,
        isPresented: Binding<Bool>,
        
        labelColor: Color? = nil,
        buttonSpacing: CGFloat? = nil,
        buttonBackground: Color? = nil,
        buttonCornerRadius: CGFloat? = nil,
        
        @ViewBuilder buttons: @escaping () -> some View
        
    ) -> some View {
        self
            .modifier(
                ButtonDialogModifier(
                    title: title,
                    isPresented: isPresented,
                    
                    labelColor: labelColor,
                    buttonSpacing: buttonSpacing,
                    buttonBackground: buttonBackground,
                    buttonCornerRadius: buttonCornerRadius,
                    
                    buttons: buttons
                )
            )
    }
}

struct ButtonDialogModifier<Buttons: View>: ViewModifier {
    
    //Parameters
    var title: String?
    @Binding var isPresented: Bool
    
    var labelColor: Color
    var buttonSpacing: CGFloat
    var buttonBackground: Color
    var buttonCornerRadius: CGFloat
    var dialogCornerRadius: CGFloat
    
    @ViewBuilder let buttons: () -> Buttons
    
    //Default values
    private let defaultLabelColor: Color = .mainPurple
    private let defaultButtonBackground: Color = .backgroundBlackLight
    private let defaultCornerRadius: CGFloat = 12
    private var cancelButtonLabelColor: Color
    
    //Initializer
    init(
        title: String? = nil,
        isPresented: Binding<Bool>,
        
        labelColor: Color? = nil,
        buttonSpacing: CGFloat? = nil,
        buttonBackground: Color? = nil,
        buttonCornerRadius: CGFloat? = nil,
        dialogCornerRadius: CGFloat? = nil,
        
        buttons: @escaping () -> Buttons
    ) {
        //Initialize with default values
        self.title = title
        self._isPresented = isPresented
        
        self.labelColor = labelColor ?? defaultLabelColor
        self.buttonSpacing = buttonSpacing ?? 0
        self.buttonBackground = buttonBackground ?? defaultButtonBackground
        self.buttonCornerRadius = (buttonCornerRadius != nil ? buttonCornerRadius : self.buttonSpacing == 0 ? 0 : buttonCornerRadius) ?? defaultCornerRadius
        self.dialogCornerRadius = dialogCornerRadius ?? buttonCornerRadius ?? defaultCornerRadius
        
        self.buttons = buttons
        
        self.cancelButtonLabelColor = self.labelColor
    }
    
    //Body
    func body(content: Content) -> some View {
        
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                ZStack(alignment: .bottom) {
                    
                    if isPresented {
                        Color.black
                            .opacity(0.2)
                            .ignoresSafeArea()
                            .transition(.opacity)
                    }
                    
                    if isPresented {
                        
                        //Menu wrapper
                        VStack(spacing: 10) {
                            VStack(spacing: buttonSpacing) {
                                if let title {
                                    Text(title)
                                        .foregroundStyle(.secondary)
                                        .font(.subheadline)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding()
                                        .background(buttonBackground, in: RoundedRectangle(cornerRadius: buttonCornerRadius))
                                }
                                // Apply style for each button passed in content
                                buttons()
                                    .buttonStyle(FullWidthButtonStyle(labelColor: labelColor, buttonBackground: buttonBackground, buttonCornerRadius: buttonCornerRadius))
                            }
                            .font(.title3)
                            .clipShape(RoundedRectangle(cornerRadius: dialogCornerRadius))
                            
                            //Cancel button
                            Button {
                                isPresented.toggle()
                            } label: {
                                Text("Cancel")
                                    .fontWeight(.semibold)
                            }
                            .buttonStyle(FullWidthButtonStyle(labelColor: cancelButtonLabelColor, buttonBackground: buttonBackground, buttonCornerRadius: dialogCornerRadius))
                        }
                        .font(.title3)
                        .padding(10)
                        .transition(.move(edge: .bottom))
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: isPresented)
            }
    }
    
    //Custom full-width button style
    struct FullWidthButtonStyle: ButtonStyle {
        
        //Parameters
        var labelColor: Color
        var buttonBackground: Color = Color(UIColor.secondarySystemBackground)
        var buttonCornerRadius: CGFloat
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(maxWidth: .infinity) // Make the button full width
                .padding()
                .background(buttonBackground, in: RoundedRectangle(cornerRadius: buttonCornerRadius))
                .opacity(configuration.isPressed ? 0.8 : 1.0) // Add press feedback
                .foregroundStyle(labelColor)
                .overlay(Divider(), alignment: .top)
        }
    }
    
}


#Preview {
    ConfirmationDialogButtons()
        .preferredColorScheme(.dark)
}
