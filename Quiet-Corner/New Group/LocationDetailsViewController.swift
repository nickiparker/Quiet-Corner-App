//
//  LocationDetailsViewController.swift
//  Quiet-Corner
//
//  Created by JODIE PARKER on 26/04/2019.
//  Copyright © 2019 Nickiparker. All rights reserved.
//

import UIKit
import SDWebImage
import Accelerate

class LocationDetailsViewController: UIViewController, SDWebImageManagerDelegate {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var advertImage: UIImageView! {
        didSet {
            advertImage.contentMode = .scaleAspectFill
            advertImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var locationImage: UIImageView! {
        didSet {
            let gradient = CAGradientLayer()
            gradient.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor, UIColor.clear.cgColor]
            gradient.locations = [0.0, 1.0]
            
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 0, y: 0)
            gradient.frame = CGRect(x: 0,
                                    y: 0,
                                    width: UIScreen.main.bounds.width,
                                    height: locationImage.bounds.height)
            
            locationImage.layer.insertSublayer(gradient, at: 0)
            locationImage.contentMode = .scaleAspectFill
            locationImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var locationDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(location)
        locationLabel.text = location[0].location
        locationDescription.text = location[0].description
        
        SDWebImageManager.shared().delegate = self
        SDWebImageManager.shared().loadImage(with: URL(string: "https://static2.bigstockphoto.com/2/6/2/large1500/262292797.jpg"), options: [], progress: nil) { (image, data, error, cacheType, finished, url) in
            // Do something
            self.locationImage.image = image
        }
        SDWebImageManager.shared().loadImage(with: URL(string: "https://static2.bigstockphoto.com/2/6/2/large1500/262292797.jpg"), options: [], progress: nil) { (image, data, error, cacheType, finished, url) in
            // Do something
            self.advertImage.image = image
        }
        
        // need to create logic to add icons for interests
    }
    
    // Resize image from url to be consistent with UIImageView
    func imageManager(_ imageManager: SDWebImageManager, transformDownloadedImage image: UIImage?, with imageURL: URL?) -> UIImage? {
        guard let image = image, let imageURL = imageURL else {
            return nil
        }
        if (imageURL.lastPathComponent == "large" && (image.size.width > 1000 || image.size.width > 1000)) {
            let targetSize = CGSize(width: 1000, height: 1000)
            UIGraphicsBeginImageContextWithOptions(targetSize, !SDCGImageRefContainsAlpha(image.cgImage), image.scale)
            image.draw(in: CGRect(origin: .zero, size: targetSize))
            
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return scaledImage
        } else {
            return image
        }
    }
    
    @IBAction func goToNavigation(_ sender: Any) {
        
        // segue to navigation sending location details (looks like this might still be held globally
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
