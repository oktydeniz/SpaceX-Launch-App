//
//  LinkRow.swift
//  spacex-launches
//
//  Created by oktay on 15.12.2024.
//

import Foundation
import SwiftUI

struct LinkRow: View {
    let logo: String
    let title: String
    let url: String
    
    var body: some View {
        Button(action: {
            print("Action: \(url)")
        }) {
            HStack {
                Image(logo)
                    .frame(width: 32, height: 32)
                    .padding(.leading, 8)
                
                Text(LocalizedStringKey(title))
                    .font(.body)
                    .foregroundColor(Color.appBlack)
                    .padding(.leading, 5)
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.appPurple)
                    .padding(.trailing, 8)
            }
            .frame(maxWidth: .infinity, minHeight: 45)
            .padding(8)
            .background(Color.clear)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.borderGray, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

