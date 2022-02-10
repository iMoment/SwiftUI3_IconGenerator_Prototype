//
//  IconVM.swift
//  IconGenerator
//
//  Created by Stanley Pan on 2022/02/10.
//

import SwiftUI

class IconVM: ObservableObject {
    // MARK: Selected Image for Icon
    @Published var selectedImage: NSImage?
    
    // MARK: Picking Image using NSOpen Panel
    func selectImage() {
        let panel = NSOpenPanel()
        panel.title = "Choose an image"
        panel.showsResizeIndicator = true
        panel.showsHiddenFiles = false
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [.image, .png, .jpeg]
        
        if panel.runModal() == .OK {
            if let result = panel.url?.path {
                let image = NSImage(contentsOf: URL(fileURLWithPath: result))
                self.selectedImage = image
            }
        } else {
            // MARK: Error Occurred
        }
    }
}
