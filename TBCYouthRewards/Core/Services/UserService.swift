//
//  UserService.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 13.03.26.
//

import Foundation

final class UserService {
    func loadProfile(username: String) async throws -> UserProfile {
        try await APIClient.shared.request(
            "/User/profile",
            queryItems: [
                URLQueryItem(name: "username", value: username)
            ]
        )
    }
}
