//
//  HomeViewController.swift
//  What Are They In
//
//  Created by Brandon Ching on 3/27/19.
//  Copyright © 2019 Brandon Ching. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var takePicButton: UIButton!
    @IBOutlet weak var takenPicture: UIImageView!
    @IBOutlet weak var backgroundButton: UIView!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        cameraView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.cameraView.bounds
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        takenPicture.isHidden = true
        
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSession.Preset.photo

        takePicButton.frame = CGRect(x: takePicButton.frame.origin.x, y: takePicButton.frame.origin.y, width: 75, height: 75)
        takePicButton.layer.cornerRadius = 0.5 * takePicButton.bounds.size.width
        
        takePicButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
    
        backgroundButton.layer.cornerRadius = 0.5 * backgroundButton.bounds.size.width
    }
    
    @IBAction func didTakePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        let image = UIImage(data: imageData)
        takenPicture.image = image
        cameraView.isHidden = true
        takenPicture.isHidden = false
        
        let alert = UIAlertController(title: "Would you like to use this picture?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            
            // Save the image to the database
            
            self.performSegue(withIdentifier: "toInfoScreen", sender: self)
        }))
            
        alert.addAction(UIAlertAction(title: "Retake", style: .cancel, handler: {
            action in
            self.cameraView.isHidden = false
            self.takenPicture.isHidden = true
        }))
        
        self.present(alert, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
}
