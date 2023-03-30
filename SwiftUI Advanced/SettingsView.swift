//
//  SettingsView.swift
//  SwiftUI Advanced
//
//  Created by Damien Gautier on 30/03/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var editingNameTextfield = false
    @State private var editingTwitterTextfield = false
    @State private var editingWebsiteTextfield = false
    @State private var editingBioTextfield = false
    
    @State private var nameIconBounce = false
    @State private var twitterIconBounce = false
    @State private var websiteIconBounce = false
    @State private var bioIconBounce = false
    
    @State private var name = ""
    @State private var twitter = ""
    @State private var website = ""
    @State private var bio = ""
    
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    
    private let generator = UISelectionFeedbackGenerator()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Settings")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Text("Manage your Design+Code profile and account")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.callout)
                
                //Pick Photo from Gallery
                Button {
                    self.showImagePicker = true
                } label: {
                    HStack(spacing: 12) {
                        TextfieldIcon(iconName: "person.crop.circle", currentlyEditing: .constant(false), passedImage: $inputImage)
                        
                        GradientText(text: "Choose photo")
                        
                        Spacer()
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.1), lineWidth: 1)
                    )
                    .background(
                        Color.init(red: 26/255, green: 20/255, blue: 51/255)
                            .cornerRadius(16)
                    )
                }
                
                // Name Textfield
                GradientTextfield(
                    editingTextfield: $editingNameTextfield,
                    textfieldString: $name,
                    iconBounce: $nameIconBounce,
                    textfieldPlaceholder: "Name",
                    textfieldIconString: "textformat.alt"
                )
                .textInputAutocapitalization(.words)
                .textContentType(.name)
                .autocorrectionDisabled(true)
                
                // Twitter Handle Textfield
                GradientTextfield(
                    editingTextfield: $editingTwitterTextfield,
                    textfieldString: $twitter,
                    iconBounce: $twitterIconBounce,
                    textfieldPlaceholder: "Twitter Handle",
                    textfieldIconString: "at"
                )
                .textInputAutocapitalization(.none)
                .keyboardType(.twitter)
                .autocorrectionDisabled(true)
                
                // Website Textfield
                GradientTextfield(
                    editingTextfield: $editingWebsiteTextfield,
                    textfieldString: $website,
                    iconBounce: $websiteIconBounce,
                    textfieldPlaceholder: "Website",
                    textfieldIconString: "link"
                )
                .textInputAutocapitalization(.none)
                .keyboardType(.webSearch)
                .autocorrectionDisabled(true)
                
                // Bio Textfield
                GradientTextfield(
                    editingTextfield: $editingBioTextfield,
                    textfieldString: $bio,
                    iconBounce: $bioIconBounce,
                    textfieldPlaceholder: "Bio",
                    textfieldIconString: "text.justifyleft"
                )
                .textInputAutocapitalization(.sentences)
                .keyboardType(.default)
                
                GradientButton(buttonTitle: "Save settings") {
                    //Save changes to Core Data
                    generator.selectionChanged()
                }
                
                Spacer()
            }
            .padding()
            
            Spacer()
        }
        .background(Color("settingsBackground").ignoresSafeArea())
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: self.$inputImage)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
