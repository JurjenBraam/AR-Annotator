import Foundation
import SceneKit

class Chair: VirtualObject {

	override init() {
		super.init(modelName: "chair", fileExtension: "scn", thumbImageFilename: "chair", title: "Chair")
        self.scale = SCNVector3(x: 1.1, y: 1.1, z: 1.1)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
