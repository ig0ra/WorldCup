//
//  Group.swift
//  WorldCup
//
//  Created by Igor O on 19.07.2022.
//

import Foundation

struct Body: IModel {
    let groups: Groups
}

struct Groups: IModel {
    let a, b, c, d, e, f, g, h: Group
    var allValues: [Group] { [a, b, c, d, e, f, g, h] }
}

struct Group: IModel {
    let name: String
    let winner, runnerup: Int
    let teams: [Team]
}
