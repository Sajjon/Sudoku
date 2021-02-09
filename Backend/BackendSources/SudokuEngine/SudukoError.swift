//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-02-09.
//

import Foundation

public enum SudukoError: Swift.Error {
    case digitAlready(in: Scope)
}
