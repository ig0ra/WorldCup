//
//  Team.swift
//  WorldCup
//
//  Created by Igor O on 19.07.2022.
//

import Foundation

struct Team: IModel {
    let id: Int
    let name: String
    let fifaCode: String
    let iso2: String
    let flag: String
    let emoji: String
    let emojiString: String
}
