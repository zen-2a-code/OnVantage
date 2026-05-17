//
//  AttemptStatus.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 28.04.26.
//

import Foundation

enum AttemptStatus: String, Codable {
    case completed, skipped
    // inProgress intentionally omitted. Attempts are only recorded on completion/skip
}
