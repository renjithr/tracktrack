import SwiftUI

struct IdentifiableExerciseName: Identifiable {
    var id: String { name }
    let name: String
}

struct ProgressViewTab: View {
    @State private var workoutHistory = WorkoutHistoryData(history: [:])
    @State private var selectedExercise: IdentifiableExerciseName?

    var body: some View {
        NavigationView {
            List {
                ForEach(uniqueExerciseNames(), id: \.self) { exerciseName in
                    Button(action: {
                        selectedExercise = IdentifiableExerciseName(name: exerciseName)
                    }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(exerciseName)
                                .font(.headline)
                            if let summary = latestSummary(for: exerciseName) {
                                Text("Last: \(summary.weight) lb, \(summary.totalSets) sets, diff \(String(format: "%.2f", summary.avgDifficulty))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Progress")
            .sheet(item: $selectedExercise) { selected in
                ProgressChartView(history: workoutHistory, exerciseName: selected.name)
            }
        }
        .onAppear {
            loadHistory()
        }
    }

    private func loadHistory() {
        workoutHistory = WorkoutHistoryStorage.load()
    }

    private func uniqueExerciseNames() -> [String] {
        var names: Set<String> = []
        for exercises in workoutHistory.history.values {
            for exercise in exercises {
                names.insert(exercise.exerciseName)
            }
        }
        return Array(names).sorted()
    }

    private func latestSummary(for exerciseName: String) -> (weight: Int, totalSets: Int, avgDifficulty: Double)? {
        let sortedDates = workoutHistory.history.keys.sorted(by: >)
        
        for date in sortedDates {
            if let exercises = workoutHistory.history[date] {
                if let matchingExercise = exercises.first(where: { $0.exerciseName == exerciseName }) {
                    let sets = matchingExercise.sets
                    let weight = sets.first?.weight ?? 0
                    let totalSets = sets.count
                    let avgDifficulty = sets.map { $0.difficulty }.reduce(0, +) / Double(totalSets)
                    
                    return (weight, totalSets, avgDifficulty)
                }
            }
        }
        
        return nil
    }
}

