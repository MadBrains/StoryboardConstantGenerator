//
//  Application.swift
//  StoryboardConstantGenerator
//
//  Created by Иван Ушаков on 25.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

/* 
 *  TODO:
 *  add prefix for classes param
 *  parse --input, --output, --template
 *  parse cell reuse identifiers of tableviews, collection views
 *  add project name param
 *  refactor merging contexts
*/


import Foundation
import Swiftline
import StoryboardKit
import PathKit
import Stencil

class Application {
    
    func run() throws -> Int {
                
        guard (Args.parsed.flags.indexForKey("h")) == nil && (Args.parsed.flags.indexForKey("help")) == nil else {
            self.printUsage()
            exit(EX_USAGE)
        }

        guard let inputPathString = Args.parsed.flags["i"] else {
            self.printUsage()
            exit(EX_USAGE)
        }
        
        guard let outputDirString = Args.parsed.flags["o"] else {
            self.printUsage()
            exit(EX_USAGE)
        }
        
        guard let templateDirString = Args.parsed.flags["t"] else {
            self.printUsage()
            exit(EX_USAGE)
        }
        
        let inputPath = Path(inputPathString).normalize()
        let storyboardName = inputPath.lastComponentWithoutExtension
        let context = try StoryboardParser().parse(inputPath)
        
        let outputDirPath = Path(outputDirString)
        let templateDirPath = Path(templateDirString).normalize()
        
        for path in templateDirPath {
            guard path.isFile else {
                continue
            }
            
            let filename = "\(storyboardName)\(path.lastComponent)"
            let outputPath = outputDirPath + filename
            
            var mutableContext = context
            mutableContext["file_name"] = filename
            
            print("Start generate \(outputPath.description)")
            
            let rendered = try self.renderTemplate(mutableContext, path: path.normalize())
            try outputPath.write(rendered)
            
            print("Generated \(outputPath.description)")
        }

        return 0;
    }
    
    private func printUsage() {        
        let usage = "Usage: \(Args.parsed.parameters[0]) [options] \n"
            + "\t-h, --help:\n"
            + "\t\tPrints a help message.\n"
            + "\t-i, --input:\n"
            + "\t\tPath to the input file.\n"
            + "\t-t, --template:\n"
            + "\t\tPath to directory with templates.\n"
            + "\t-o, --output:\n"
            + "\t\tPath to output directory."
        
        print(usage)
        exit(EX_USAGE)
    }
    
    private func renderTemplate(params: Dictionary<String, Any>, path: Path) throws -> String {
        let namespace = StancilNamespace()
        let context = Context(dictionary: params)
        let template = try Template(path: path)
        return try template.render(context, namespace: namespace)
    }
}