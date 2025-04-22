import Charts
import SwiftUI

struct ProgressChartView: View {
    var history: WorkoutHistoryData
    var exerciseName: String

    var body: some View {
        let workoutEntries = extractEntries(for: exerciseName)
        let exerciseColor = colorForExercise(exerciseName)

        VStack {
            Text("\(exerciseName) Progress")
                .font(.title2)
                .fontWeight(.bold)
                .padding()

            if workoutEntries.isEmpty {
                Text("No history available for \(exerciseName).")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                Chart(workoutEntries) { entry in
                    LineMark(
                        x: .value("Date", entry.date),
                        y: .value("Reps", entry.totalReps)
                    )
                    .foregroundStyle(exerciseColor)
                    .symbol(Circle())
                }
                .frame(height: 300)
                .padding()
            }
        }
    }

    private func extractEntries(for exerciseName: String) -> [WorkoutChartEntry] {
        var result: [WorkoutChartEntry] = []
        
        for (date, exercises) in history.history {
            if let matchingExercise = exercises.first(where: { $0.exerciseName == exerciseName }) {
                let totalReps = matchingExercise.sets.map { $0.reps }.reduce(0, +)
                result.append(WorkoutChartEntry(date: date, totalReps: totalReps))
            }
        }
        
        return result.sorted(by: { $0.date < $1.date })
    }

    private func colorForExercise(_ name: String) -> Color {
        // Assign a consistent color per exercise name
        let colors: [Color] = [.red, .blue, .green, .orange, .purple, .pink, .teal, .yellow]
        let hashValue = abs(name.hashValue)
        let index = hashValue % colors.count
        return colors[index]
    }
}

struct WorkoutChartEntry: Identifiable {
    let id = UUID()
    let date: String
    let totalReps: Int
}

