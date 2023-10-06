//
//  HelpView.swift
//  Racoon
//
//  Created by Filippo Vicini on 06/10/23.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Help Center")
                .font(.title)
                .bold()
                .foregroundColor(.main)
                .padding(.leading, 10)
                .padding(.top, 10)
            
            HelpItemView(iconName: "questionmark.circle", title: "FAQ") {
                // Show FAQ content
            }
            
            HelpItemView(iconName: "envelope.open", title: "Contact Support") {
                // Show contact support form or action
            }
            
            Spacer()
            
            Text("Racoon Help Version: 1.0, All rights reserved")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.leading, 10)
                .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 20)
    }
}

struct HelpItemView: View {
    var iconName: String
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack(spacing: 30) {
                Image(systemName: iconName)
                    .font(.system(size: 25))
                    .foregroundColor(.gray)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.light)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.leading, 25)
        }
    }
}
