//
//  HomeViewController.swift
//  What Are They In
//
//  Created by Brandon Ching on 3/27/19.
//  Copyright © 2019 Brandon Ching. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

var actorName = ""
var birthday = ""
var imagePath = ""
var id = ""
var movies:[String] = []

class HomeViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var takePicButton: UIButton!
    @IBOutlet weak var takenPicture: UIImageView!
    @IBOutlet weak var backgroundButton: UIView!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var count = UserDefaults.standard.string(forKey: "count")
    var oldCount = ""
    var jsonArray: [String: Any] = [:]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //UserDefaults.standard.set("One", forKey: "count")
        
        //takenPicture.isHidden = true
        
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
        
        count = UserDefaults.standard.string(forKey: "count") ?? ""
    print("count: \(count)")
    print("oldCount: \(oldCount)")
        
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
        
        
        var image = UIImage(data: imageData)
        image = image!.rotate(radians: 2 * .pi)
        takenPicture.image = image
        cameraView.isHidden = true
        takenPicture.isHidden = false
        
        let alert = UIAlertController(title: "Would you like to use this picture?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            
          //  image.transform = CGAffineTransform(rotationAngle: M_PI_2);
            // Pass on the image
            let imageData:NSData = image!.pngData()! as NSData
            
            
            self.sendImage(encodedImage: imageData.base64EncodedString());
            
//            actorName = UserDefaults.standard.string(forKey: "recent\(String(describing: self.oldCount))") ?? ""
            
            sleep(25)
            self.dismiss(animated: false, completion: nil)
            
            print("actorName: \(actorName)")
            
            if actorName == "" {
                print("bad picture")
                
                let alert = UIAlertController(title: "Faulty Picture", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retake", style: .cancel, handler: {
                    action in
                    self.cameraView.isHidden = false
                    self.takenPicture.isHidden = true
                }))
                //actorName = jsonArray["name"] as! String
                self.present(alert, animated: true)
                
            }
            
            self.performSegue(withIdentifier: "toInfoScreen", sender: self)
        }))
            
        alert.addAction(UIAlertAction(title: "Retake", style: .cancel, handler: {
            action in
            self.cameraView.isHidden = false
            self.takenPicture.isHidden = true
        }))
        
        self.present(alert, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        captureSession.startRunning()
        cameraView.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        videoPreviewLayer.isHidden = true
        videoPreviewLayer.isHidden = true
        self.captureSession.stopRunning()
    }
    
    func sendImage(encodedImage: String) {
//        let shleep = true;
//        // loading circle
//        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
//
//        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.style = UIActivityIndicatorView.Style.gray
//        loadingIndicator.startAnimating();
//
//        alert.view.addSubview(loadingIndicator)
//        self.present(alert, animated: true, completion: nil)
        
        
        
        
        let url = URL(string: "http://167.99.145.46:80/scan")
        var request = URLRequest(url: url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let json = ["data": encodedImage];
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions(rawValue: 0))
        
        print(JSONSerialization.isValidJSONObject(json))
        request.httpMethod = "POST"
        request.httpBody = jsonData;
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            guard let jsonArray = responseJSON as? [String: Any] else {
                return
            }
            
            actorName = jsonArray["name"] as! String
            
            birthday = jsonArray["birthday"] as! String
            imagePath = jsonArray["profile_path"] as! String
            id = jsonArray["imdb_id"] as! String
            let publications = jsonArray["known_for"] as! [[String:Any]]

            movies = []
            
            for entries in publications {
                if (entries["original_title"] != nil) {
                    movies.append(entries["original_title"] as! String)
                } else if (entries["original_name"] != nil) {
                    movies.append(entries["original_name"] as! String)
                }
            }
            
            var info: [String] = [birthday, imagePath, id]
            info.append(contentsOf: movies)
            UserDefaults.standard.set(info, forKey: actorName)
            
            //This saves the the name into the recents user defaults
            switch self.count as! String{
                case "One":
                    UserDefaults.standard.set(jsonArray["name"]!, forKey: "recentOne")
                    self.oldCount = "One"
                    self.count = "Two"
                    UserDefaults.standard.set(self.count, forKey: "count")
                case "Two":
                    UserDefaults.standard.set(jsonArray["name"]!, forKey: "recentTwo")
                    self.oldCount = "Two"
                    self.count = "Three"
                    UserDefaults.standard.set(self.count, forKey: "count")
                case "Three":
                    UserDefaults.standard.set(jsonArray["name"]!, forKey: "recentThree")
                    self.oldCount = "Three"
                    self.count = "Four"
                    UserDefaults.standard.set(self.count, forKey: "count")
                case "Four":
                    UserDefaults.standard.set(jsonArray["name"]!, forKey: "recentFour")
                    self.oldCount = "Four"
                    self.count = "Five"
                    UserDefaults.standard.set(self.count, forKey: "count")
                case "Five":
                    UserDefaults.standard.set(jsonArray["name"]!, forKey: "recentFive")
                    self.oldCount = "Five"
                    self.count = "Six"
                    UserDefaults.standard.set(self.count, forKey: "count")
                default:
                    UserDefaults.standard.set(jsonArray["name"]!, forKey: "recentSix")
                    self.oldCount = "Six"
                    self.count = "One"
                    UserDefaults.standard.set(self.count, forKey: "count")
            }
//            completion(<#Void#>);
        }
        task.resume()
    }

}
