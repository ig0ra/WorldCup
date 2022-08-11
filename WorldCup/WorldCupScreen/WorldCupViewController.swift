//
//  ViewController.swift
//  WorldCup
//
//  Created by Igor O on 19.07.2022.
//

import UIKit

final class WorldCupViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Dependencies
    
    var viewModel: IWorldCupViewModel?
    
    // MARK: - Private properties
    
    private let searchController = UISearchController()
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return true}
        return text.isEmpty
    }

    // MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        setupTableView()
        setupVMOutput()
        
        viewModel?.input.requestGroups()
    }
}

// MARK: - Private

private extension WorldCupViewController {
    func setupVMOutput() {
        viewModel?.output = .init(
            contentDidChange: { [weak self] in
                self?.tableView.reloadData()
            }
        )
    }
    
    func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension WorldCupViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        searchBarIsEmpty ? viewModel?.groups.count ?? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchBarIsEmpty ? viewModel?.groups[section].teams.count ?? 0 : viewModel?.filteredTeams.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        
        if searchBarIsEmpty {
            cell.textLabel?.text = viewModel?.groups[indexPath.section].teams[indexPath.item].name
        } else {
            cell.textLabel?.text = viewModel?.filteredTeams[indexPath.item].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = UINib( nibName: "HeaderView", bundle: nil)
            .instantiate(withOwner: nil, options: nil)[0] as? HeaderView
        else { return UIView() }
        
        if searchBarIsEmpty {
            headerView.titleLabel.text = viewModel?.groups[section].name
            
            headerView.viewTapped = { [weak self] in
                guard let self = self, let viewModel = self.viewModel else { return }
                viewModel.input.showGroupDetails(
                    self,
                    viewModel.groups[section])
            }
        } else {
            headerView.titleLabel.text = "Search results"
        }
        
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if searchBarIsEmpty {
            viewModel.input.showTeamDetails(
                self,
                viewModel.groups[indexPath.section].teams[indexPath.item])
        } else {
            viewModel.input.showTeamDetails(
                self,
                viewModel.filteredTeams[indexPath.item])
        }
    }
}

// MARK: - Assembler

extension WorldCupViewController {
    struct Assembler {
        init() {}
        
        func assemble() throws -> WorldCupViewController {
            let identifier = String(describing: WorldCupViewController.self)
            let storyboard = UIStoryboard(name: identifier, bundle: nil)
            
            guard let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? WorldCupViewController else {
                throw "Can't instantiate TeamDetailsViewController"
            }
            
            vc.viewModel = WorldCupViewModel.init(networkService: WorldCupNetworkService())
            
            return vc
        }
    }
}

extension WorldCupViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        viewModel?.input.searchTextDidChange(text)
    }
}
