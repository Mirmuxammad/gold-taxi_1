//
//  Debug.swift
//  TAXI
//
//  Created by iMac_DM on 2/28/21.
//

import Foundation

public let devMode: Bool = true

public func mylog(_ item: Any...) {
    if devMode {
        print("🔴")
        print(item)
    }

}
