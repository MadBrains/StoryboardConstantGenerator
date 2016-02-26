//
//  Application.swift
//  StoryboardConstantGenerator
//
//  Created by Иван Ушаков on 25.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

import Foundation
import Swiftline
import StoryboardKit
import PathKit
import Stencil

class Application {
    
    func run() throws -> Int {
        
        guard (Args.parsed.flags.indexForKey("h")) == nil else {
            self.printHelp()
            return 0
        }

        guard let inputPathString = Args.parsed.flags["i"] else {
            self.printHelp()
            return -1
        }
        
        guard let outputDirString = Args.parsed.flags["o"] else {
            self.printHelp()
            return -1
        }
        
        guard let templateDirString = Args.parsed.flags["t"] else {
            self.printHelp()
            return -1
        }

        let inputPath = Path(inputPathString).normalize()
        let storyboardName = inputPath.lastComponentWithoutExtension
        let context = try StoryboardParser().parse(inputPath)

        let outputDirPath = Path(outputDirString).normalize()
        let templateDirPath = Path(templateDirString).normalize()
        
        for path in templateDirPath {
            guard path.isFile else {
                continue
            }
            
            let rendered = try self.renderTemplate(context, path: path.normalize())
            let outputPath = outputDirPath + "\(storyboardName)\(path.lastComponent)"
            try outputPath.write(rendered)
        }

        return 0;
    }
    
    private func printHelp() {
        print("printHelp");
    }
    
    private func renderTemplate(params: Dictionary<String, Any>, path: Path) throws -> String {
        let context = Context(dictionary: params)
        let template = try Template(path: path)
        return try template.render(context)
    }
}