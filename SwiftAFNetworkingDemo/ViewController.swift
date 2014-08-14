//
//  ViewController.swift
//  SwiftAFNetworkingDemo
//
//  Created by Richard Lee on 8/11/14.
//  Copyright (c) 2014 Weimed. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIActionSheetDelegate {
                            
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //SVProgressHUD.showProgress(20.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func downloadImage(sender: AnyObject) {
        var image = loadImageWithFileName("background.png")
        if image != nil {
            println("image: " + image.description)
            self.imageView.image = image
            return
        }
        var url = NSURL.URLWithString("http://www.raywenderlich.com/wp-content/uploads/2014/01/sunny-background.png")
        var request = NSURLRequest(URL: url)

        var operation = AFHTTPRequestOperation(request: request)
        operation.responseSerializer = AFImageResponseSerializer()
        operation.setCompletionBlockWithSuccess( { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("JSON: " + responseObject.description)
                self.imageView.image = responseObject as UIImage
                self.saveImage(self.imageView.image, withFileName: "background.png")
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error: " + error.localizedDescription)
            }
        )
        operation.start()
    }

    func saveImage(image: UIImage, withFileName filename: String) {
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        path = path.stringByAppendingPathComponent("SwiftAFNetworkingDemoImages/")

        var error: NSError? = nil
        NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: &error)
        if error != nil { NSLog("%@", error!) }

        path = path.stringByAppendingPathComponent(filename)
        var imageData = UIImagePNGRepresentation(image)
        NSLog("Saving image at: %@", path)
        NSFileManager.defaultManager().createFileAtPath(path, contents: imageData, attributes: nil)
        //NSLog("Writting: %d", imageData.writeToFile(path, atomically: true))
    }

    func loadImageWithFileName(filename: String) -> UIImage {
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        path = path.stringByAppendingPathComponent("SwiftAFNetworkingDemoImages/")
        path = path.stringByAppendingPathComponent(filename)

        NSLog("Loading image at: %@", path)
        return UIImage(contentsOfFile: path)
    }

    @IBAction func deleteImage(sender: AnyObject) {
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        path = path.stringByAppendingPathComponent("SwiftAFNetworkingDemoImages/")

        var error: NSError? = nil
        NSFileManager.defaultManager().removeItemAtPath(path, error: &error)
    }
}

