import Foundation


struct JSONStorage {
    static let fileName = "excersisedata.json"
    
    static var fileURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent(fileName)
    }

    static func load() -> ExerciseData? {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoded = try JSONDecoder().decode(ExerciseData.self, from: data)
            return decoded
        } catch {
            print("Failed to load excersisedata.json: \(error.localizedDescription)")
            return nil
        }
    }

    static func save(_ data: ExerciseData) {
        do {
            let encoded = try JSONEncoder().encode(data)
            try encoded.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save excersisedata.json: \(error.localizedDescription)")
        }
    }

    static func delete() {
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Failed to delete excersisedata.json: \(error.localizedDescription)")
        }
    }
    static func ensureFileExistsInDocuments() {
    
        // Check if the file exists in the Documents directory
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            if let bundleURL = Bundle.main.url(forResource: "excersisedata", withExtension: "json") {
                do {
                    try FileManager.default.copyItem(at: bundleURL, to: fileURL)
                    print("Copied excersisedata.json to Documents folder.")
                } catch {
                    print("Failed to copy file: \(error.localizedDescription)")
                }
            }
        }
    }
}
