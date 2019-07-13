
//  ViewController.swift
//  QR code Scanner
//
//  Created by user155698 on 7/6/19.
//  Copyright © 2019 user155698. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    
    @IBOutlet weak var VideoPreview: UIView!
    
    let avCaptureSession = AVCaptureSession()
    var Barcode = String()
    
    enum error: Error {
        
        case noCameraAvailable
        case videoInitInoutFailed
    }
    
    override func viewDidLoad() {
        do {
            try scanQRCode()
            
        } catch
        {
            print("Failed to scan QR/barcode")
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects:[AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            let machineReadebleCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if machineReadebleCode.type == AVMetadataObject.ObjectType.ean13{
                
                Barcode = machineReadebleCode.stringValue!
                self.performSegue(withIdentifier:"UnwindFromBarcodeReader", sender: self)
                
            }
        }
    }
    
    func scanQRCode() throws {
        
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("No camera.")
            throw error.noCameraAvailable
        }
        guard let avCaptureInput = try? AVCaptureDeviceInput(device: avCaptureDevice) else
        {
            print("Failed to init camera.")
            throw error.videoInitInoutFailed
        }
        
        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        avCaptureSession.addInput(avCaptureInput)
        avCaptureSession.addOutput(avCaptureMetadataOutput)
        
        avCaptureMetadataOutput.metadataObjectTypes = [.qr, .aztec,.code128, .code39, .code39Mod43, .code93, .dataMatrix, .ean13,.ean8]
        let avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        
        avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avCaptureVideoPreviewLayer.frame = VideoPreview.bounds
        
        self.VideoPreview.layer.addSublayer(avCaptureVideoPreviewLayer)
        avCaptureSession.startRunning()
}
}
