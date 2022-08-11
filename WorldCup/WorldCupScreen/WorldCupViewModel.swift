//
//  WorldCupViewModel.swift
//  WorldCup
//
//  Created by Igor O on 19.07.2022.
//

import Foundation
import UIKit

// MARK: - Input & Output

struct WorldCupVMInput {
    let requestGroups: () -> ()
    let showGroupDetails: (UIViewController, Group) -> ()
    let showTeamDetails: (UIViewController, Team) -> ()
    let searchTextDidChange: (String) -> ()
}

struct WorldCupVMOutput {
    let contentDidChange: () -> ()
}

// MARK: - ViewModel protocol

protocol IWorldCupViewModel {
    var input: WorldCupVMInput { get }
    var output: WorldCupVMOutput? { get set }
    var groups: [Group] { get }
    var filteredTeams: [Team] { get }
}

// MARK: - Implementation

final class WorldCupViewModel: IWorldCupViewModel {
    // MARK: - Properties
    
    var output: WorldCupVMOutput?
    lazy var input: WorldCupVMInput = {
        WorldCupVMInput(
            requestGroups: { [weak self] in
                self?.getGroups()
            },
            showGroupDetails: { [weak self] (view, group) in
                self?.showGroupDetails(view: view, group: group)
            },
            showTeamDetails: { [weak self] (view, team) in
                self?.showTeamDetails(view: view, team: team)
            },
            searchTextDidChange: { [weak self] text in
                self?.filterContentForSearchText(text)
            }
        )
    }()
    
    var groups: [Group] = [] {
        didSet {
            output?.contentDidChange()
        }
    }
    
    var filteredTeams: [Team] = [] {
        didSet {
            output?.contentDidChange()
        }
    }
    
    // MARK: - Dependencies
    
    private let networkService: IWorldCupNetworkService
    
    // MARK: - Initialisation
    
    init(networkService: IWorldCupNetworkService) {
        self.networkService = networkService
    }
}

// MARK: - Private

private extension WorldCupViewModel {
    private func getGroups() {
        networkService.getGroups { [weak self] (result: Result<Groups, Error>) in
            switch result {
            case .success(let groups):
                self?.groups = groups.allValues
            case .failure(let error): print(error)
            }
        }
    }
    
    private func showGroupDetails(view: UIViewController, group: Group) {
        guard let vc = try? GroupDetailsViewController.Assembler(with: group).assemble() else {
            return
        }
        
        view.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showTeamDetails(view: UIViewController, team: Team) {
        guard let vc = try? TeamDetailsViewController.Assembler(with: team).assemble() else {
            return
        }
        
        view.navigationController?.pushViewController(vc, animated: true)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        var teams = [Team]()
        groups.forEach { teams.append(contentsOf: $0.teams) }
        
        let filteredTeams = teams.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }
        self.filteredTeams = filteredTeams.sorted { $0.name < $1.name }
    }
}
