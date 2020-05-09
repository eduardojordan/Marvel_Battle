//
//  Extensions.swift
//  Marvel_Battle
//
//  Created by MAC on 09/05/2020.
//  Copyright © 2020 eduardojordan.com. All rights reserved.
//

import Foundation

extension Dictionary {
    var queryString: String? {
        return self.reduce("") { "\($0!)\($1.0)=\($1.1)&" }
    }
}
