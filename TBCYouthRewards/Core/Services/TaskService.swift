//
//  TaskService.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 13.03.26.
//

import Foundation

struct TaskCompleteResponse: Codable {
    let pointsEarned: Int
    let totalPoints: Int
}

final class TaskService {
    func loadTasks() async throws -> [TaskModel] {
        try await APIClient.shared.request("/Task")
    }

    func completeTask(taskId: Int, userId: Int) async throws -> TaskCompleteResponse {
        try await APIClient.shared.request(
            "/Task/\(taskId)/complete",
            method: "POST",
            queryItems: [
                URLQueryItem(name: "userId", value: "\(userId)")
            ]
        )
    }
}
