//
//  TeamDetailsViewController.swift
//  WorldCup
//
//  Created by Igor O on 20.07.2022.
//

import UIKit

final class TeamDetailsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fifaCodeLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    
    // MARK: - Dependencies
    
    var viewModel: ITeamDetailsViewModel?
    
    // MARK: - LifeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupOutputEvents()
        
        setupTeamIntoUI(viewModel?.team)
        
        viewModel?.input.requestFlagImage()
    }
}

// MARK: - Private

private extension TeamDetailsViewController {
    func setupOutputEvents() {
        viewModel?.output = .init(
            teamDidChange: { [weak self] team in
                self?.setupTeamIntoUI(team)
            },
            imageDidRecieve: { [weak self] image in
                DispatchQueue.main.async {
                    self?.flagImageView.image = image
                }
            }
        )
    }
    
    func setupTeamIntoUI(_ team: Team?) {
        guard let team = team else { return }
        
        DispatchQueue.main.async {
            self.nameLabel.text = "Team name: " + team.name
            self.fifaCodeLabel.text = "FIFA code: " + team.fifaCode
        }
    }
}

// MARK: = Assembler

extension TeamDetailsViewController {
    struct Assembler {
        private let team: Team
        
        init(with team: Team) {
            self.team = team
        }
        
        func assemble() throws -> TeamDetailsViewController {
            let identifier = String(describing: TeamDetailsViewController.self)
            let storyboard = UIStoryboard(name: identifier, bundle: nil)
            
            guard let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? TeamDetailsViewController else {
                throw "Can't instantiate TeamDetailsViewController"
            }

            vc.viewModel = TeamDetailsViewModel(team: team, networkService: WorldCupNetworkService())
            
            return vc
        }
    }
}

