//
//  Meme.swift
//  MemeApp
//
//  Created by Тимур Кошевой on 15.10.2019.
//  Copyright © 2019 Тимур Кошевой. All rights reserved.
//

import Foundation

struct Meme: Codable {
    var postLink: String
    var subreddit: String?
    var title: String
    var url: String
}
