//
//  JSONCategoryImporter.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 18.05.26.
//

import Foundation

struct ImportedCategoryDTO: Decodable {
    let categoryName: String
    let isOrdered: Bool
    let challenges: [ImportedChallengeDTO]
}

struct ImportedChallengeDTO: Decodable {
    let title: String
    let conceptExplanation: String
    let taskDescription: String
    let difficulty: Int
}

enum JSONCategoryImporter {
    static func parse(url: URL) throws -> ImportedCategoryDTO {
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw CategoryImportError.fileReadFailed
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let dto: ImportedCategoryDTO
        do {
            dto = try decoder.decode(ImportedCategoryDTO.self, from: data)
        } catch {
            throw CategoryImportError.invalidFormat
        }

        guard !dto.challenges.isEmpty else {
            throw CategoryImportError.emptyChallenges
        }

        for challenge in dto.challenges {
            guard (1...3).contains(challenge.difficulty) else {
                throw CategoryImportError.invalidDifficulty(
                    challenge.difficulty
                )
            }

            guard
                challenge.taskDescription.count >= 3
                    && challenge.conceptExplanation.count >= 3
            else {
                throw CategoryImportError.invalidFormat
            }
        }

        return dto
    }
}

enum CategoryImportError: LocalizedError {
    case fileReadFailed
    case invalidFormat
    case emptyChallenges
    case invalidDifficulty(Int)

    var errorDescription: String? {
        switch self {
        case .fileReadFailed: return "Could not read the selected file."
        case .invalidFormat:
            return "The file is not valid JSON or is missing required fields."
        case .emptyChallenges:
            return "The category must contain at least one challenge."
        case .invalidDifficulty(let value):
            return
                "Difficulty must be between (including) 1–3. Found: \(value)."
        }
    }
}
