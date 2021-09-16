//
//  CameraViewController.swift
//  InstaClone
//
//  Created by Afir Thes on 15.09.2021.
//

import UIKit

class CameraViewController: UIViewController {

    @IBOutlet weak var simpleCameraView: SimpleCameraView!
    
    var simpleCamera: SimpleCamera!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        simpleCamera = SimpleCamera(cameraView: simpleCameraView)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        simpleCamera.startSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        simpleCamera.stopSession()
    }
    
    @IBAction func startCapture(_ sender: Any) {
        if simpleCamera.currentCaptureMode == .photo {
            simpleCamera.takePhoto { image, success in
                if success {
                    print("image success")
                    if let _image = image {
                        
                        // do something with image
                        
                    }
                }
            }
        }
    }

}
