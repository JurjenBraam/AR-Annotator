//
//  Easel.swift
//  AR Annotator
//
//  Created by Jurjen Braam on 08-01-18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit

class Painting3: VirtualObject {
    override init() {
        super.init(modelName: "painting3", fileExtension: "scn", thumbImageFilename: "lamp", title: "Painting 3")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

