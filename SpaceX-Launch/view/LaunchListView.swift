//
//  LaunchListView.swift
//  spacex-launches
//
//  Created by oktay on 14.12.2024.
//

import Foundation
import SwiftUI

struct LaunchListView: View {
    
    @StateObject private var viewModel = LaunchListViewModel()
    @State private var selectedSegment: LaunchType = .upcoming
    @State private var showAlert: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("launch_type", selection: $selectedSegment) {
                    Text("upcoming").tag(LaunchType.upcoming)
                    Text("past").tag(LaunchType.past)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
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
                } else {
                    List(viewModel.launches) { item in
                        NavigationLink(destination: LaunchDetailView(launch: item.id, launchType: selectedSegment)) {
                            LaunchCell(launch: item)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.borderGray, lineWidth: 1)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listRowInsets(EdgeInsets())
                    .listSectionSpacing(0)
                    .padding(.vertical, 0)
                    .listStyle(PlainListStyle())
                    .refreshable {
                        viewModel.fetchLaunches(type: selectedSegment)
                    }
                }
            }
            .navigationTitle("launches")
            .font(.subheadline)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                if viewModel.launches.isEmpty {
                    viewModel.fetchLaunches(type: selectedSegment)
                }
            }
            .onChange(of: selectedSegment) { oldValue, newValue in
                viewModel.fetchLaunches(type: newValue)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("error"),
                    message: Text(errorMessage),
                    primaryButton: .cancel {
                        let reType: LaunchType = selectedSegment == .past ? .upcoming : .past
                        selectedSegment = reType
                        viewModel.fetchLaunches(type: reType)
                    },
                    secondaryButton: .default(Text("try_again")) {
                        viewModel.fetchLaunches(type: selectedSegment)
                    }
                )
            }
        }
    }
}
