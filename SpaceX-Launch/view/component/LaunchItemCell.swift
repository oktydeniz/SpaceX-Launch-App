//
//  LaunchItemCell.swift
//  spacex-launches
//
//  Created by oktay on 15.12.2024.
//

import Foundation
import SwiftUI

struct LaunchItemCell: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(LocalizedStringKey(label))
                .font(.subheadline)
                .foregroundColor(Color.appPurple)
            Text(LocalizedStringKey(value))
                .font(.footnote)
                .bold()
                .foregroundColor(Color.appBlack)
        }
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .topLeading)
        .padding(.leading, 12)
        .padding(.top, 12)
        .background(Color.clear)
        .overlay(
            Rectangle()
                .stroke(Color.borderGray, lineWidth: 1)
        )
    }
}
