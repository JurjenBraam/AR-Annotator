//
//  Easel.swift
//  AR Annotator
//
//  Created by Jurjen Braam on 08-01-18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit

class Painting1: VirtualObject {
    override init() {
        super.init(modelName: "painting1", fileExtension: "scn", thumbImageFilename: "lamp", title: "Painting 1")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

