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
    
    private let generator = UISelectionFeedbackGenerator()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
