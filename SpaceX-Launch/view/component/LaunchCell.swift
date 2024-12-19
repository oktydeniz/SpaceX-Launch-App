//
//  LaunchCell.swift
//  spacex-launches
//
//  Created by oktay on 14.12.2024.
//

import Foundation
import SwiftUI

struct LaunchCell: View {
    let launch: Launchs
    
    var body: some View {
        HStack(alignment: .center, spacing:15) {
            AsyncImage(url: URL(string: launch.links?.patch?.small ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image("placeholder")
                    .resizable()
                    .scaledToFill()
            }
            .frame(width: 44, height: 44)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.borderGray, lineWidth: 1))
            VStack(alignment: .leading, spacing:3) {
                Text(launch.name)
                    .font(.title3)
                    .lineLimit(1)
                    .foregroundColor(Color.appBlack)
                    .truncationMode(.tail)
                
                if let dateString = launch.dateLocal, let date = Date.fromISO8601String(dateString) {
                    let formattedDate = date.formattedLocalDate()
                    Text(formattedDate)
                        .font(.subheadline)
                        .foregroundColor(Color.appPurple)
                } else {
                    Text("-")
                        .font(.subheadline)
                        .foregroundColor(Color.appPurple)
                }
            }
        }.frame(height: 60)
            .cornerRadius(6)
    }
}

#Preview {
    VStack {
        let data = [
            Launchs(
                links: nil,
                flightNumber: 101,
                name: "Falcon 1",
                dateLocal: "2024-12-21T14:00:00Z",
                id: "1"
            ),
            Launchs(
                links: nil,
                flightNumber: 102,
                name: "Falcon 9",
                dateLocal: "2024-11-15T12:00:00Z",
                id: "2"
            ),
            Launchs(
                links: nil,
                flightNumber: 103,
                name: "Starship Test Flight",
                dateLocal: "2023-10-10T10:00:00Z",
                id: "3"
            ),
            Launchs(
                links: nil,
                flightNumber: 104,
                name: "Crew Dragon Launch",
                dateLocal: "2024-01-01T09:00:00Z",
                id: "4"
            ),
            Launchs(
                links: nil,
                flightNumber: 105,
                name: "Satellite Deployment",
                dateLocal: "2023-09-20T08:30:00Z",
                id: "5"
            )
        ]
        
        NavigationView {
            VStack {
                List(data) { item in
                    NavigationLink(destination: LaunchDetailView(launch: item.id, launchType: LaunchType.upcoming)) {
                        LaunchCell(launch: item)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.white)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.borderGray, lineWidth: 1)
                    }
                }
                .scrollContentBackground(.hidden)
                .listRowInsets(EdgeInsets())
                .listSectionSpacing(0)
                .padding(0)
                .listStyle(PlainListStyle())
                .refreshable {
                    
                }
            }
            .navigationTitle("launches")
            .font(.subheadline)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            
        }
    }
}
