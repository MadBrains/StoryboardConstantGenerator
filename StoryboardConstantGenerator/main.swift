//
//  Application.swift
//  StoryboardConstantGenerator
//
//  Created by Иван Ушаков on 25.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

import Foundation

do {
    try Application().run();
}
catch let error as NSError  {
    print(error);
}