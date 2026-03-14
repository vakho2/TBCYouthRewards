//
//  APIClient.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 13.03.26.
//

import Foundation

final class APIClient {
    static let shared = APIClient()

    private let environment: APIEnvironment = .main

    func request<T: Decodable>(
        _ endpoint: String,
        method: String = "GET",
        queryItems: [URLQueryItem] = [],
        body: Data? = nil
    ) async throws -> T {
        var components = URLComponents(string: environment.baseURL + endpoint)!
        components.queryItems = queryItems

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse {

            guard 200..<300 ~= http.statusCode else {
                if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                    throw NSError(
                        domain: "APIError",
                        code: http.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: apiError.message]
                    )
                } else {
                    throw NSError(
                        domain: "APIError",
                        code: http.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "Request failed with status code \(http.statusCode)"]
                    )
                }
            }
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
