import SwiftUI

struct TodayView: View {
    var selectedDayIndex: Int

    @State private var exercises: [ExerciseProgress] = []
    @State private var selectedExercise: ExerciseProgress?
    @State private var toggles: [UUID: Bool] = [:]
    @State private var allData: ExerciseData?
    @State private var bounceTrigger = true

    let days = ["S", "M", "T", "W", "T", "F", "S"]
    
    // 🔥 List of exercise related SF Symbols
    let exerciseIcons = [
        "figure.walk",
        "figure.run",
        "dumbbell",
        "figure.strengthtraining.traditional",
        "figure.flexibility",
        "figure.cross.training",
        "heart.circle",
        "bolt.heart",
        "lungs",
        "hare"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("\(days[selectedDayIndex])'s Exercise")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal)

            if exercises.isEmpty {
                Text("No exercises planned for this day.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(exercises) { exercise in
                            HStack {
                                // Delete button
                                Button(action: {
                                    bounceTrigger.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        deleteExercise(exercise)
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .symbolEffect(.bounce, value: bounceTrigger)
                                }
                                .padding(.leading, 10)

                                // Exercise card button
                                Button(action: {
                                    selectedExercise = exercise
                                }) {
                                    HStack(spacing: 10) {
                                        Image(systemName: exerciseIcons.randomElement() ?? "figure.walk") // 🎯 Random Icon
                                            .foregroundColor(.blue)

                                        Text(exercise.exerciseName)
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)

                                        Spacer()

                                        Toggle("", isOn: Binding(
                                            get: { toggles[exercise.id] ?? false },
                                            set: { toggles[exercise.id] = $0 }
                                        ))
                                        .toggleStyle(SwitchToggleStyle(tint: .customSwitchBlue))
                                        .labelsHidden()
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .transition(.opacity)
                    }
                }
                .padding(.top, 20)
            }

            Spacer()
        }
        .sheet(item: $selectedExercise) { exercise in
            ExerciseDetailSheet(exerciseName: exercise.exerciseName)
        }
        .onAppear {
            JSONStorage.ensureFileExistsInDocuments()
            allData = JSONStorage.load()
            loadExercises(for: selectedDayIndex)
        }
        .onChange(of: selectedDayIndex) { newValue in
            loadExercises(for: newValue)
        }
    }

    private func loadExercises(for dayIndex: Int) {
        guard let allData = allData else { return }
        
        let todayDate = dateString(for: dayIndex)
        exercises = allData.dailyProgress[todayDate] ?? []
        toggles = [:]
        for exercise in exercises {
            toggles[exercise.id] = false
        }
    }

    private func deleteExercise(_ exercise: ExerciseProgress) {
        guard var allData = allData else { return }

        let todayDate = dateString(for: selectedDayIndex)

        if var exercisesForDay = allData.dailyProgress[todayDate] {
            exercisesForDay.removeAll { $0.id == exercise.id }
            allData.dailyProgress[todayDate] = exercisesForDay
            JSONStorage.save(allData)
            self.allData = allData
            loadExercises(for: selectedDayIndex)
        }
    }

    private func dateString(for dayIndex: Int) -> String {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today) - 1
        
        var offset = dayIndex - weekday
        if offset < 0 {
            offset += 7
        }
        
        let selectedDate = calendar.date(byAdding: .day, value: offset, to: today)!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: selectedDate)
    }
}
