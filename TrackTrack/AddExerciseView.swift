import SwiftUI

struct AddExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var exerciseName: String = ""
    @State private var numberOfSets: Int = 3
    @State private var startingWeight: Int = 50
    @State private var selectedDays: Set<Int> = [] // 1=Sunday, 2=Monday, etc.
    
    let days = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Add Exercise")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Exercise Name")
                    .font(.headline)
                
                TextField("Exercise Name", text: $exerciseName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                HStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("Number of Sets")
                            .font(.headline)
                        
                        CounterView(label: "", value: $numberOfSets)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Starting Weight")
                            .font(.headline)
                        
                        CounterView(label: "", value: $startingWeight, unit: "lb")
                    }
                }
                
                Text("Week")
                    .font(.headline)
                
                HStack {
                    ForEach(0..<days.count, id: \.self) { index in
                        Button(action: {
                            toggleDay(index)
                        }) {
                            Text(days[index])
                                .fontWeight(.bold)
                                .frame(width: 40, height: 40)
                                .background(selectedDays.contains(index) ? Color.customSwitchBlue : Color(.systemGray5))
                                .foregroundColor(selectedDays.contains(index) ? .white : .black)
                                .cornerRadius(20)
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                saveExercise()
                clearFields()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.customSwitchBlue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom)

        }
    }
    
    private func toggleDay(_ index: Int) {
        if selectedDays.contains(index) {
            selectedDays.remove(index)
        } else {
            selectedDays.insert(index)
        }
    }
    
    private func saveExercise() {
        // 1. Load existing data
        var exerciseData = JSONStorage.load() ?? ExerciseData(dailyProgress: [:])
        
        // 2. Create new ExerciseProgress
        let newExercise = ExerciseProgress(
            exerciseName: exerciseName,
            sets: (0..<numberOfSets).map { _ in
                ExerciseDetailSet(weight: startingWeight, reps: 10, difficulty: 0.5)
            }
        )

        // 3. Insert into selected days
        for dayIndex in selectedDays {
            let dateString = dateStringForNext(dayOfWeek: dayIndex)
            
            if exerciseData.dailyProgress[dateString] != nil {
                exerciseData.dailyProgress[dateString]?.append(newExercise)
            } else {
                exerciseData.dailyProgress[dateString] = [newExercise]
            }
        }

        // 4. Save back to file
        JSONStorage.save(exerciseData)
    }

    private func dateStringForNext(dayOfWeek: Int) -> String {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today) - 1 // Sunday=0
        
        var offset = dayOfWeek - weekday
        if offset < 0 {
            offset += 7
        }
        
        let targetDate = calendar.date(byAdding: .day, value: offset, to: today)!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: targetDate)
    }


    private func formattedToday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    private func clearFields() {
        exerciseName = ""
        numberOfSets = 3
        startingWeight = 50
        selectedDays.removeAll()
    }
}
