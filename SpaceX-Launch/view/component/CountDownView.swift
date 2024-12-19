//
//  CountDownView.swift
//  spacex-launches
//
//  Created by oktay on 15.12.2024.
//

import Foundation
import SwiftUI

struct CountDownView: View {
    let date: String
    @State private var timeRemaining: TimeInterval = 0
    @State private var timer: Timer? = nil
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: nil) {
                    Text(LocalizedStringKey("launch_date"))
                        .font(.subheadline)
                        .textCase(.uppercase)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.bottom, 1)
                    
                    if let fdate = Date.fromISO8601String(date) {
                        let formattedDate = fdate.formattedLocalDate(format: "yyyy.MM.dd")
                        Text(formattedDate)
                            .font(.caption2)
                            .fontWeight(.regular)
                            .foregroundColor(.white)
                    }
                }
                Spacer()
                HStack (spacing:6) {
                    VStack {
                        Text(formattedTime(timeRemaining: timeRemaining, unit: .hour))
                            .font(.title2)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        Text(LocalizedStringKey("hour"))
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    Text(":")
                        .font(.title2)
                        .foregroundColor(.white)
                    VStack {
                        Text(formattedTime(timeRemaining: timeRemaining, unit: .minute))
                            .font(.title2)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        Text(LocalizedStringKey("minute"))
                            .font(.caption)
                            .foregroundColor(.white)
                        
                    }
                    Text(":")
                        .font(.title2)
                        .foregroundColor(.white).padding(0)
                    VStack {
                        Text(formattedTime(timeRemaining: timeRemaining, unit: .second))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.appPurple)
                        Text(LocalizedStringKey("second"))
                            .font(.caption)
                            .foregroundColor(Color.appPurple)
                    }
                }
            }.padding()
        }
        .background(Color.black)
        .cornerRadius(8)
        .padding(.horizontal)
        .padding(.vertical, 5)
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func formattedTime(timeRemaining: TimeInterval, unit: Calendar.Component) -> String {
        let totalSeconds = Int(timeRemaining)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        switch unit {
        case .hour:
            return String(format: "%02d", hours)
        case .minute:
            return String(format: "%02d", minutes)
        case .second:
            return String(format: "%02d", seconds)
        default:
            return "00"
        }
    }
    
    private func startTimer() {
        guard let launchDate = dateFormatter.date(from: date) else { return }
        
        timeRemaining = launchDate.timeIntervalSinceNow
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
