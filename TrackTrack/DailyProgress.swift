import Foundation

struct ExerciseData: Codable {
    var dailyProgress: [String: [ExerciseProgress]]
}


struct ExerciseProgress: Codable, Identifiable {
    var id = UUID()
    let exerciseName: String
    let sets: [ExerciseDetailSet]

    enum CodingKeys: String, CodingKey {
        case exerciseName, sets
    }
}

struct ExerciseDetailSet: Codable {
    let weight: Int
    let reps: Int
    let difficulty: Double
}

struct WorkoutHistoryData: Codable {
    var history: [String: [WorkoutHistoryEntry]]
}

struct WorkoutHistoryEntry: Codable, Identifiable {
    var id = UUID()
    let exerciseName: String
    let sets: [WorkoutSet]
}

struct WorkoutSet: Codable {
    let weight: Int
    let reps: Int
    let difficulty: Double
}
