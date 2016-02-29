//
//  StencilNamespace.swift
//  StoryboardConstantGenerator
//
//  Created by Иван Ушаков on 27.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

import Foundation
import Stencil

class StancilNamespace: Namespace
{
    
    override init() {
        super.init()
        self.registerTags()
        self.registerFilters()
    }
    
    private func registerTags() {
    
    }
    
    private func registerFilters() {
        self.registerFilter("capitaliseFirstChar", filter: capitaliseFirstChar)
    }
    
}

func toString(value: Any?) -> String? {
    if let value = value as? String {
        return value
    } else if let value = value as? CustomStringConvertible {
        return value.description
    }
    
    return nil
}

func capitaliseFirstChar(value: Any?) -> Any? {
    if var value = toString(value) {
        value.replaceRange(value.startIndex...value.startIndex, with: String(value[value.startIndex]).capitalizedString)
        return value
    }
    
    return value
}