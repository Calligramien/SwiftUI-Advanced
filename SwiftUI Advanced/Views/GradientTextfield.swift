//
//  GradientTextfield.swift
//  SwiftUI Advanced
//
//  Created by Damien Gautier on 30/03/2023.
//

import SwiftUI

struct GradientTextfield: View {
    
    @Binding var editingTextfield: Bool
    @Binding var textfieldString: String
    @Binding var iconBounce: Bool
    var textfieldPlaceholder: String
    var textfieldIconString: String
    private let generator = UISelectionFeedbackGenerator()
    
    var body: some View {
        HStack(spacing: 12) {
            TextfieldIcon(iconName: textfieldIconString, currentlyEditing: $editingTextfield)
                .scaleEffect(iconBounce ? 1.2 : 1.0)
            
            TextField(textfieldPlaceholder, text: $textfieldString) { isEditing in
                editingTextfield = isEditing
                generator.selectionChanged()
                if isEditing {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                        iconBounce.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                            iconBounce.toggle()
                        }
                    }
                }
                
            }
            .preferredColorScheme(.dark)
            .foregroundColor(.white.opacity(0.7))
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white, lineWidth: 1)
                .blendMode(.overlay)
        )
        .background(
            Color(red: 26/255, green: 20/255, blue: 51/255)
                .cornerRadius(16.0)
        )
    }
}

struct GradientTextfield_Previews: PreviewProvider {
    static var previews: some View {
        GradientTextfield(editingTextfield: .constant(true), textfieldString: .constant("Some string here"), iconBounce: .constant(false), textfieldPlaceholder: "Test Textfield", textfieldIconString: "textformat.alt")
    }
}
