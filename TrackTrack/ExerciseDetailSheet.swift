import SwiftUI

struct ExerciseDetailSheet: View {
    let exerciseName: String
    
    @State private var sets: [ExerciseSet] = [
        ExerciseSet(id: UUID(), weight: 0, reps: 10, difficulty: 0.5),
        ExerciseSet(id: UUID(), weight: 0, reps: 10, difficulty: 0.5)
    ]
    @State private var currentSetIndex: Int = 0
    
    var body: some View {
        VStack(spacing: 24) {
            Text(exerciseName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            if !sets.isEmpty {
                SetCardView(set: $sets[currentSetIndex], setNumber: currentSetIndex + 1)
                    .padding(.horizontal)
            }
            
            HStack(spacing: 40) {
                Button(action: {
                    if currentSetIndex > 0 {
                        currentSetIndex -= 1
                    }
                }) {
                    Text("Previous")
                        .foregroundColor(currentSetIndex == 0 ? .gray : .customSwitchBlue)
                }
                .disabled(currentSetIndex == 0)
                
                Button(action: {
                    if currentSetIndex < sets.count - 1 {
                        currentSetIndex += 1
                    }
                }) {
                    Text("Next")
                        .foregroundColor(currentSetIndex == sets.count - 1 ? .gray : .customSwitchBlue)
                }
                .disabled(currentSetIndex == sets.count - 1)
            }
            .padding(.bottom)
            
            Button(action: {
                saveWorkout()
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.customSwitchBlue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
    
    private func saveWorkout() {
        let today = formattedToday()

        var history = WorkoutHistoryStorage.load()

        let workoutEntry = WorkoutHistoryEntry(
            exerciseName: exerciseName,
            sets: sets.map { WorkoutSet(weight: $0.weight, reps: $0.reps, difficulty: $0.difficulty) }
        )

        if history.history[today] != nil {
            history.history[today]?.append(workoutEntry)
        } else {
            history.history[today] = [workoutEntry]
        }

        WorkoutHistoryStorage.save(history)
    }

    private func formattedToday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

}

struct ExerciseSet: Identifiable {
    let id: UUID
    var weight: Int
    var reps: Int
    var difficulty: Double
}

struct SetCardView: View {
    @Binding var set: ExerciseSet
    let setNumber: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Set \(setNumber)")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            CounterView(label: "Weight", value: $set.weight, unit: "lb")
            CounterView(label: "Reps", value: $set.reps)
            
            Text("Difficulty")
                .font(.headline)
            Slider(value: $set.difficulty, in: 0...1, step: 0.01)
                .accentColor(.customSwitchBlue)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(20)
    }
}

struct CounterView: View {
    let label: String
    @Binding var value: Int
    var unit: String? = nil

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.subheadline)
            HStack {
                Button(action: {
                    if value > 0 { value -= 1 }
                }) {
                    Image(systemName: "minus")
                        .frame(width: 32, height: 32)
                        .background(Color(.systemGray4))
                        .foregroundColor(.customSwitchBlue)
                        .clipShape(Circle())
                }

                Spacer()

                Text("\(value)\(unit != nil ? " \(unit!)" : "")")
                    .font(.title3)
                    .fontWeight(.bold)

                Spacer()

                Button(action: {
                    value += 1
                }) {
                    Image(systemName: "plus")
                        .frame(width: 32, height: 32)
                        .background(Color(.systemGray4))
                        .foregroundColor(.customSwitchBlue)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
        }
    }
}

