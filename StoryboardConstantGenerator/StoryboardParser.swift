//
//  StoryboardParser.swift
//  StoryboardConstantGenerator
//
//  Created by Иван Ушаков on 26.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

import Foundation
import PathKit
import StoryboardKit

class StoryboardParser {
    
    func parse(storyboardPath: Path) throws -> Dictionary<String, Any> {
        let application = ApplicationInfo()
        let result = try StoryboardFileParser.parse(application, pathFileName: storyboardPath.description)
        
        if let storyboard = result.0 {
            let segues = storyboard.scenes
                .map({ (sceneInfo) -> Array<SegueInstanceInfo> in
                    return sceneInfo.controller!.segues
                })
                .flatten()
                .flatMap({ (segueInfo) -> Dictionary<String, String>? in
                    if let identifier = segueInfo.identifier {
                        return ["identifier": identifier]
                    }
                    return nil;
                })
         
            let generatedOn = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "M/d/YY"
            let generatedOnString = dateFormatter.stringFromDate(generatedOn)
            
            let storyboardName = storyboardPath.lastComponentWithoutExtension
            
            return ["segues": segues, "generated_on": generatedOnString, "storyboard_name": storyboardName]
        }
        
        throw NSError(domain: "Unable to parse Storyboard file \(storyboardPath.description)", code: 0, userInfo: nil)
    }
    
}