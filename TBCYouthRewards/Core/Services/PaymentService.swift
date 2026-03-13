//
//  PaymentService.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 13.03.26.
//

import Foundation

final class PaymentService {
    func simulatePayment(userId: Int, taskId: Int) async throws -> PaymentSimulateResponse {
        let body = try JSONEncoder().encode(PaymentSimulateRequest(taskId: taskId))

        return try await APIClient.shared.request(
            "/Payment/simulate",
            method: "POST",
            queryItems: [
                URLQueryItem(name: "userId", value: "\(userId)")
            ],
            body: body
        )
    }
}
