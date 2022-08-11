//
//  headerView.swift
//  WorldCup
//
//  Created by Igor O on 19.07.2022.
//

import UIKit

final class HeaderView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    
    var viewTapped: (() -> ())?
    
    @IBAction func viewGestureTapped(_ sender: UITapGestureRecognizer) {
        viewTapped?()
    }
}
