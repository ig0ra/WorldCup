//
//  GroupDetailsViewController.swift
//  WorldCup
//
//  Created by Igor O on 19.07.2022.
//

import UIKit

final class GroupDetailsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var runnerUpLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Dependencies
    
    var viewModel: IGroupDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        setupGroupIntoUI(viewModel?.group)
    }
}

// MARK: - Private

private extension GroupDetailsViewController {
    func setupVMOutput() {
        viewModel?.output = .init(detailsDidChange: { [weak self] group in
            self?.setupGroupIntoUI(group)
        })
    }
    
    func setupGroupIntoUI(_ group: Group?) {
        DispatchQueue.main.async {
            guard let group = group else {
                return
            }

            self.title = group.name
            self.winnerLabel.text = "Winner: \(group.winner)"
            self.runnerUpLabel.text = "Runner-up: \(group.runnerup)"
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension GroupDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.group.teams.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell") else { return UITableViewCell() }
        let teamsNames = viewModel?.group.teams.sorted { $0.name < $1.name}
        cell.textLabel?.text = teamsNames?[indexPath.item].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let teams = viewModel?.group.teams.sorted { $0.name < $1.name}
        guard let team = teams?[indexPath.item] else {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel?.input.showDetailsDidTap(self, team)
    }
}

// MARK: - Assembler

extension GroupDetailsViewController {
    struct Assembler {
        private let group: Group
        
        init(with group: Group) {
            self.group = group
        }
        
        func assemble() throws -> GroupDetailsViewController {
            let identifier = String(describing: GroupDetailsViewController.self)
            let storyboard = UIStoryboard(name: identifier, bundle: nil)
            
            guard let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? GroupDetailsViewController else {
                throw "Can't instantiate TeamDetailsViewController"
            }
            
            vc.viewModel = GroupDetailsViewModel(group: group)
            
            return vc
        }
    }
}
