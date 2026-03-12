import Foundation
import OSLog

actor ConvexService {
    private let baseURL: URL
    private let session: URLSession
    private let authManager: AuthManager
    private let decoder: JSONDecoder
    private let logger = Logger(subsystem: "com.sen.app", category: "Convex")

    init(deploymentURL: String, authManager: AuthManager) {
        guard let url = URL(string: "\(deploymentURL)/api") else {
            preconditionFailure("Invalid Convex deployment URL: \(deploymentURL)")
        }
        self.baseURL = url
        self.authManager = authManager
        self.decoder = JSONDecoder()

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        self.session = URLSession(configuration: config)
    }

    // MARK: - Public API

    func query<T: Decodable & Sendable>(
        path: String,
        args: [String: ConvexValue] = [:]
    ) async throws -> T {
        try await execute(endpoint: "query", path: path, args: args)
    }

    func queryOptional<T: Decodable & Sendable>(
        path: String,
        args: [String: ConvexValue] = [:]
    ) async throws -> T? {
        try await executeOptional(endpoint: "query", path: path, args: args)
    }

    func mutation(
        path: String,
        args: [String: ConvexValue] = [:]
    ) async throws {
        let _: EmptyValue = try await execute(endpoint: "mutation", path: path, args: args)
    }

    // MARK: - Private

    private func execute<T: Decodable>(
        endpoint: String,
        path: String,
        args: [String: ConvexValue]
    ) async throws -> T {
        let data = try await performRequest(endpoint: endpoint, path: path, args: args)
        let response = try decoder.decode(ConvexResponse<T>.self, from: data)

        switch response.status {
        case "success":
            guard let value = response.value else {
                throw SenError.network("Empty response from Convex")
            }
            return value
        case "error":
            let message = response.errorMessage ?? "Unknown Convex error"
            logger.error("Convex \(endpoint) error for \(path): \(message)")
            if message.contains("Unauthenticated") || message.contains("Unauthorized") {
                throw SenError.auth(message)
            }
            throw SenError.network(message)
        default:
            throw SenError.network("Unexpected Convex response status: \(response.status)")
        }
    }

    private func executeOptional<T: Decodable>(
        endpoint: String,
        path: String,
        args: [String: ConvexValue]
    ) async throws -> T? {
        let data = try await performRequest(endpoint: endpoint, path: path, args: args)
        let response = try decoder.decode(ConvexResponseOptional<T>.self, from: data)

        switch response.status {
        case "success":
            return response.value
        case "error":
            let message = response.errorMessage ?? "Unknown Convex error"
            logger.error("Convex \(endpoint) error for \(path): \(message)")
            if message.contains("Unauthenticated") || message.contains("Unauthorized") {
                throw SenError.auth(message)
            }
            throw SenError.network(message)
        default:
            throw SenError.network("Unexpected Convex response status: \(response.status)")
        }
    }

    private func performRequest(
        endpoint: String,
        path: String,
        args: [String: ConvexValue]
    ) async throws -> Data {
        let url = baseURL.appendingPathComponent(endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = await authManager.currentToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let body = ConvexRequest(path: path, args: args)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw SenError.network("Invalid response")
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            logger.error("HTTP \(httpResponse.statusCode) for \(path)")
            throw SenError.network("HTTP \(httpResponse.statusCode)")
        }

        return data
    }
}

// MARK: - Convex Value Encoding

nonisolated enum ConvexValue: Sendable, Encodable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)

    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let v): try container.encode(v)
        case .int(let v): try container.encode(v)
        case .double(let v): try container.encode(v)
        case .bool(let v): try container.encode(v)
        }
    }
}

// MARK: - Request / Response Types

nonisolated private struct ConvexRequest: Encodable {
    let path: String
    let args: [String: ConvexValue]
}

nonisolated private struct ConvexResponse<T: Decodable>: Decodable {
    let status: String
    let value: T?
    let errorMessage: String?
}

nonisolated private struct ConvexResponseOptional<T: Decodable>: Decodable {
    let status: String
    let value: T?
    let errorMessage: String?
}

nonisolated private struct EmptyValue: Decodable {}
