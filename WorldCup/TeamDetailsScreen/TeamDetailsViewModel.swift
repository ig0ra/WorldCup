//
//  TeamDetailsViewModel.swift
//  WorldCup
//
//  Created by Igor O on 20.07.2022.
//

import Foundation
import UIKit

// MARK: - Input & Output

struct TeamDetailsVMInput {
    let requestFlagImage: () -> ()
}

struct TeamDetailsVMOutput {
    let teamDidChange: (Team?) -> ()
    let imageDidRecieve: (UIImage?) -> ()
}

// MARK: - ViewModel Protocol

protocol ITeamDetailsViewModel {
    var input: TeamDetailsVMInput { get }
    var output: TeamDetailsVMOutput? { get set }
    var team: Team? { get }
}

// MARK: - Implementation

final class TeamDetailsViewModel: ITeamDetailsViewModel {
    // MARK: - Properties
    
    var output: TeamDetailsVMOutput?
    lazy var input: TeamDetailsVMInput = {
        TeamDetailsVMInput(
            requestFlagImage: { [weak self] in
                guard let urlStr = self?.team?.flag, let url = URL(string: urlStr) else {
                    return
                }
                
                self?.requestImage(url: url)
            }
        )
    }()
    
    var team: Team? {
        didSet {
            output?.teamDidChange(team)
        }
    }
    
    // MARK: - Dependencies
    
    private var networkService: IWorldCupNetworkService
    
    // MARK: - Initialisation
    
    init(team: Team?, networkService: IWorldCupNetworkService) {
        self.networkService = networkService
        self.team = team
    }
}

// MARK: - Private

private extension TeamDetailsViewModel {
    func requestImage(url: URL) {
        networkService.getImage(from: url) { [weak self] (result: Result<UIImage, Error>) in
            switch result {
            case .success(let image): self?.output?.imageDidRecieve(image)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
