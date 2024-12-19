//
//  LaunchDetailView.swift
//  spacex-launches
//
//  Created by oktay on 14.12.2024.
//

import Foundation
import SwiftUI

struct LaunchDetailView: View {
    
    let launch: String
    let launchType: LaunchType
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = LaunchViewModel()
    @State private var showAlert: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("loading")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    Text("\(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                        .font(.callout)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear {
                            self.errorMessage = errorMessage
                            self.showAlert = true
                        }
                } else if let item = viewModel.launch {
                    DetailHeaderView(launch: item)
                    DetailLaunchDate(launch: item, type: launchType)
                    DetailGridView(launch: item)
                    DetailLinksView(launch: item)
                    Spacer()
                }
            }.onAppear {
                viewModel.fetchLaunch(id: launch)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("error"),
                    message: Text(errorMessage),
                    primaryButton: .cancel {
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .default(Text("try_again")) {
                        viewModel.fetchLaunch(id: launch)
                    }
                )
            }
        }.navigationBarBackButtonHidden(true)
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(Color.appBlack)
                        }
                        .padding(.leading, 0)
                        Spacer()
                        
                        Text(launchType == .upcoming ? "upcoming_launch" : "last_launch")
                            .font(.headline)
                            .foregroundColor(Color.appBlack)
                        
                        Spacer()
                        
                    }
                    .frame(maxWidth: .infinity)
                }
            }
    }
}

struct DetailLaunchDate: View {
    let launch: Launch
    let type: LaunchType
    
    var body: some View {
        VStack(spacing:0) {
            let formattedDate = launch.dateLocal
                .flatMap { Date.fromISO8601String($0) }
                .map { $0.formattedLocalDate(format: "yyyy.MM.dd") }
            
            if type == .upcoming {
                if let dateString = launch.dateLocal, let date = Date.fromISO8601String(dateString) {
                    let currentDate = Date()
                    let validDate = date < currentDate ? "2024-12-21T14:00:00Z" : dateString
                    CountDownView(date: validDate)
                }
            } else {
                HStack(alignment:.center, spacing: 0) {
                    Text(LocalizedStringKey("launch_date_past"))
                        .font(.subheadline)
                        .padding(EdgeInsets())
                        .foregroundColor(Color.appPurple)
                    Text(formattedDate ?? "-")
                        .font(.subheadline)
                        .foregroundColor(Color.appPurple)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity,alignment:.leading)
                    
                }.padding(.leading, 16)
                
            }
        }
        .padding(.bottom, 10)
    }
}


struct DetailHeaderView : View {
    let launch: Launch
    
    var body: some View {
        HStack(alignment:.center) {
            AsyncImage(url: URL(string: launch.links?.patch?.small ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image("placeholder")
                    .resizable()
                    .scaledToFill()
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.borderGray, lineWidth: 1))
            .padding(.leading, 8)
            
            Text(launch.name)
                .font(.headline)
                .foregroundColor(Color.appBlack)
                .padding(.leading, 1)
        }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 10, leading: 8, bottom: 5, trailing: 8))
    }
}

struct DetailGridView: View {
    let launch: Launch
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0)
            ], spacing: 0) {
                
                LaunchItemCell(label: "landing_attempt", value: (launch.cores.first?.landingAttempt == true ? "true" : "false"))
                LaunchItemCell(label: "landing_success", value: (launch.cores.first?.landingSuccess == true ? "true" : (launch.cores.first?.landingSuccess == false ? "false" : "-")))
                
                LaunchItemCell(label: "landing_type", value: launch.cores.first?.landingType ?? "-")
                LaunchItemCell(label: "flight_number", value: launch.flightNumber.map { "\($0)" } ?? "-")
                
                LaunchItemCell(label: "upcoming", value: launch.upcoming ?? false ? "true" : "false")
                LaunchItemCell(label: "date_precision", value: (launch.datePrecision?.capitalized ?? "-"))
                
            }
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.borderGray, lineWidth: 1)
            ).padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
    }
}


struct DetailLinksView: View {
    let launch: Launch
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let youtubeLink = launch.links?.webcast ?? (launch.links?.youtubeId.map { "https://www.youtube.com/watch?v=\($0)" }) {
                LinkRow(logo: "youtube",title: "youTube", url: youtubeLink)
            }
            
            if let presskitLink = launch.links?.presskit {
                LinkRow(logo: "presskit",title: "presskit", url: presskitLink)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VStack {
        let data = Launch(
            links: Links(
                patch: nil,
                reddit: nil,
                presskit: "https://www.spacex.com/presskit",
                webcast: "https://www.youtube.com/watch?v=1MkcWK2PnsU",
                youtubeId: "1MkcWK2PnsU"
            ),
            flightNumber: 42,
            name: "Falcon 9",
            dateLocal: "2024-12-21T14:00:00Z",
            datePrecision: "hour",
            upcoming: true,
            cores: [Core(landingAttempt: true, landingSuccess: true, landingType: "RTLS")],
            id: "12345"
        )
        
        DetailHeaderView(launch:data)
        DetailLaunchDate(launch: data, type: .upcoming)
        DetailGridView(launch:data)
        DetailLinksView(launch:data)
        Spacer()
    }
}
