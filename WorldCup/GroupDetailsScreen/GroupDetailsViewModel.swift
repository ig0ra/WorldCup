//
//  GroupDetailsViewModel.swift
//  WorldCup
//
//  Created by Igor O on 19.07.2022.
//

import Foundation
import UIKit

// MARK: - Input & Output

struct GroupDetailsVMInput {
    let showDetailsDidTap: (UIViewController, Team) -> ()
}

struct GroupDetailsVMOutput {
    let detailsDidChange: (Group) -> ()
}

// MARK: - ViewModel protocol

protocol IGroupDetailsViewModel {
    var input: GroupDetailsVMInput { get }
    var output: GroupDetailsVMOutput? { get set }
    var group: Group { get }
}

// MARK: - Implementation

final class GroupDetailsViewModel: IGroupDetailsViewModel {
    // MARK: - Properties
    var output: GroupDetailsVMOutput?
    lazy var input: GroupDetailsVMInput = {
        .init { [weak self] (view, team) in
            guard let vc = try? TeamDetailsViewController.Assembler.init(with: team).assemble() else {
                return
            }
            
            view.navigationController?.pushViewController(vc, animated: true)
        }
    }()
    
    var group: Group {
        didSet {
            output?.detailsDidChange(group)
        }
    }
    
    // MARK: - Initialisation
    
    init(group: Group) {
        self.group = group
    }
}
