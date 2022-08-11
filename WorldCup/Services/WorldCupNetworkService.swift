//
//  WorldCupNetworkService.swift
//  WorldCup
//
//  Created by Igor O on 19.07.2022.
//

import Foundation
import UIKit

// MARK: - Network Service protocol

protocol IWorldCupNetworkService {
    func getGroups(completion: (Result<Groups, Error>) -> ())
    func getImage(from url: URL, completion: @escaping  (Result<UIImage, Error>) -> ())
}

// MARK: - Implementation

final class WorldCupNetworkService: IWorldCupNetworkService {
    
    // MARK: - Dependencies
    
    private let session: URLSession
    
    // MARK: - Initialisation
    
    init(with session: URLSession = URLSession(configuration: .ephemeral)) {
        self.session = session
    }
}

// MARK: - IWorldCupNetworkService

extension WorldCupNetworkService {
    func getGroups(completion: (Result<Groups, Error>) -> ()) {
        guard let path = Bundle.main.url(forResource: "WorldCup2018", withExtension: "json") else {
            return completion(.failure("Can't load World Cup 2018"))
        }
        
        do {
            let data = try Data(contentsOf: path)
            let groups = try Body(data: data).groups
            
            completion(.success(groups))
        } catch {
            completion(.failure(error))
        }
    }
    
    func getImage(from url: URL, completion: @escaping  (Result<UIImage, Error>) -> ()) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                return completion(.failure(error ?? "Something went wrong"))
            }
            
            completion(.success(image))
        }.resume()
    }
}


