//
//  location.swift
//  Uber Clone
//
//  Created by James  Luberisse on 11/18/21.
//  Copyright © 2021 Balaji. All rights reserved.
//

import Foundation
import Firebase


struct Location {
    var name: String = UUID().uuidString
    var latitude: Double = 0.00;
    var longitude: Double = 0.00;
}
