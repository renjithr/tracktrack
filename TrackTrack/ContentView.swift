// ExerciseTrackerApp.swift
import SwiftUI


// MainTabView.swift
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            TodayScreen()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Today")
                }
            
            ProgressViewTab()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Progress")
                }
            
            PlanView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Plan")
                }
        }
    }
}

// PlanView.swift
import SwiftUI

struct PlanView: View {
    var body: some View {
        AddExerciseView()
    }
}
