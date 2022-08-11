//
//  IModel.swift
//  WorldCup
//
//  Created by Igor O on 19.07.2022.
//

import Foundation

protocol IModel: Codable, Hashable {
    init(data: Data?) throws
}

extension IModel {
    init(data: Data?) throws {
        do {
            guard let data = data else {
                throw "dataEncoding"
            }
            self = try JSONDecoder().decode(Self.self, from: data)
        } catch let error {
            print("⚠️ Decoding error:", error.localizedDescription)
            throw error
        }
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { self }
}
