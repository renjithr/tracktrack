import Foundation

struct WorkoutHistoryStorage {
    static let fileName = "workouthistory.json"
    
    static var fileURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent(fileName)
    }

    static func load() -> WorkoutHistoryData {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoded = try JSONDecoder().decode(WorkoutHistoryData.self, from: data)
            return decoded
        } catch {
            print("Failed to load workout history, initializing empty.")
            return WorkoutHistoryData(history: [:])
        }
    }

    static func save(_ data: WorkoutHistoryData) {
        do {
            let encoded = try JSONEncoder().encode(data)
            try encoded.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save workout history: \(error.localizedDescription)")
        }
    }

    static func ensureFileExistsInDocuments() {
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            let emptyData = WorkoutHistoryData(history: [:])
            save(emptyData)
            print("Created empty workout history file.")
        }
    }
}
