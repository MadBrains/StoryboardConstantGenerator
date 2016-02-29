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
    
    func parse(storyboardPath: Path) throws -> Dictionary<String, Any>
    {
        let application = ApplicationInfo()
        let result = try StoryboardFileParser.parse(application, pathFileName: storyboardPath.description)
        
        if let _ = result.0 {
            
            let controllers = parseApplication(application)

            let generatedOn = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM.dd.YY"
            let generatedOnString = dateFormatter.stringFromDate(generatedOn)
            
            let storyboardNameFull = storyboardPath.lastComponent
            let storyboardNameShort = storyboardPath.lastComponentWithoutExtension
            
            return ["controllers": controllers,
                    "generated_on": generatedOnString,
                    "storyboard_name": storyboardNameFull,
                    "storyboard_name_short": storyboardNameShort]
        }
        
        throw NSError(domain: "Unable to parse Storyboard file \(storyboardPath.description)", code: 0, userInfo: nil)
    }
    
    private func parseApplication(applicationInfo: ApplicationInfo) -> Array<Any>
    {
        return applicationInfo.viewControllerClasses.map(parseViewControllerClass)
    }
    
    private func parseViewControllerClass(viewControllerClassInfo: ViewControllerClassInfo) -> Dictionary<String, Any>
    {
        let storyboardIdentifiers = NSMutableOrderedSet()
        let segueInstances = NSMutableOrderedSet()
        var tableViewCellPrototypes = Array<Dictionary<String, Any>>()
        var collectionViewCellPrototypes = Array<Dictionary<String, Any>>()

        
        for viewControllerInstanceInfo in viewControllerClassInfo.instanceInfos {
            
            if let instance = viewControllerInstanceInfo.value {

                if let storyboardIdentifier = instance.storyboardIdentifier
                {
                    if storyboardIdentifier.characters.count > 0
                    {
                        storyboardIdentifiers.addObject(instance)
                    }
                }
                
                let segues = instance.segues.flatMap(self.parseSegue)
                segueInstances.addObjectsFromArray(segues)
            
                if let view = instance.view
                {
                    let newTableViewCellPrototypes = self.parseTableViewCellPrototypes(view)
                    if newTableViewCellPrototypes.count > 0
                    {
                        tableViewCellPrototypes = tableViewCellPrototypes + newTableViewCellPrototypes
                    }
                    
                    let newCollectionViewCellPrototypes = self.parseCollectionViewCellPrototypes(view)
                    if newCollectionViewCellPrototypes.count > 0
                    {
                        collectionViewCellPrototypes = collectionViewCellPrototypes + newCollectionViewCellPrototypes
                    }
                }
            }
            
        }
        
        var context: Dictionary<String, Any> = ["class": viewControllerClassInfo.infoClassName]

        if storyboardIdentifiers.count > 0 {
            context["storyboardIds"] = storyboardIdentifiers.array
        }
        
        if segueInstances.count > 0 {
            context["segues"] = segueInstances.array
        }
        
        if tableViewCellPrototypes.count > 0 {
            let cells = tableViewCellPrototypes.map({ (dict) -> Any in
                return dict as Any
            })
            
            context["tableViewCells"] = cells
        }

        if collectionViewCellPrototypes.count > 0 {
            let cells = collectionViewCellPrototypes.map({ (dict) -> Any in
                return dict as Any
            })
            
            context["collectionViewCells"] = cells
        }
        
        return context;
    }

    private func parseSegue(segueInfo: SegueInstanceInfo) -> Dictionary<String, String>?
    {
        guard let identifier = segueInfo.identifier else {
            return nil;
        }
        
        var context = ["identifier": identifier, "class": segueInfo.classInfo.infoClassName]
        
        if let source = segueInfo.source.value, let sourceIdentifier = source.storyboardIdentifier
        {
            context["sourceIdentifier"] = sourceIdentifier
        }
        
        if let destination = segueInfo.destination.value, let destinationIdentifier = destination.storyboardIdentifier
        {
            context["destinationIdentifier"] = destinationIdentifier
        }
        
        return context
    }
    
    func parseTableViewCellPrototypes(view : ViewInstanceInfo) -> Array<Dictionary<String, Any>> {
        
        var result = Array<Dictionary<String, Any>>()
        
        if let tableView = view as? TableViewInstanceInfo
        {
            
            let tableViewCells = tableView.cellPrototypes?.flatMap(paeseTableViewCellPrototype)
            
            if let tableViewCells = tableViewCells {
                result = result + tableViewCells
            }
        }
        
        if let subviews = view.subviews
        {
            for subview in subviews
            {
                let subviewResult = self.parseTableViewCellPrototypes(subview)
                if subviewResult.count > 0
                {
                    result = result + subviewResult
                }
            }
        }
        
        return result
    }
    
    func paeseTableViewCellPrototype(cell: TableViewInstanceInfo.TableViewCellPrototypeInfo) -> Dictionary<String, Any>? {
        
        if let reuseIdentifier = cell.reuseIdentifier {
            return ["reuseIdentifier": reuseIdentifier]
        }
        return nil;
    }
    
    func parseCollectionViewCellPrototypes(view : ViewInstanceInfo) -> Array<Dictionary<String, Any>> {
        var result = Array<Dictionary<String, Any>>()
        
        if let collectionView = view as? CollectionViewInstanceInfo
        {
            let collectionViewCells = collectionView.cellPrototypes?.flatMap(parseCollectionViewCellPrototype)
            
            if let collectionViewCells = collectionViewCells {
                result = result + collectionViewCells
            }
        }
        
        if let subviews = view.subviews
        {
            for subview in subviews
            {
                let subviewResult = self.parseCollectionViewCellPrototypes(subview)
                if subviewResult.count > 0
                {
                    result = result + subviewResult
                }
            }
        }
        
        return result
    }
    
    func parseCollectionViewCellPrototype(cell: CollectionViewInstanceInfo.CollectionViewCellPrototypeInfo) -> Dictionary<String, Any>? {
        if let reuseIdentifier = cell.reuseIdentifier {
            return ["reuseIdentifier": reuseIdentifier]
        }
        return nil;
    }
    
}
