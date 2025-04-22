//
//  TrackTrackApp.swift
//  TrackTrack
//
//  Created by R on 22/04/25.
//

import SwiftUI

@main
struct TrackTrackApp: App {
    init() {
        JSONStorage.ensureFileExistsInDocuments()
        WorkoutHistoryStorage.ensureFileExistsInDocuments()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
