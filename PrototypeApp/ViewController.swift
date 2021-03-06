//
//  ViewController.swift
//  PrototypeApp
//
//  Created by New User on 10/14/18.
//  Copyright © 2018 New User. All rights reserved.
//
import UIKit
import Purchases
//code to identify color of pixels in RGB

extension UIImage {
  /*
   func getPixelColor(point: CGPoint) -> UIColor? {
          guard let cgImage = cgImage,
              let pixelData = cgImage.dataProvider?.data
              else { return nil }

          let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

          let alphaInfo = cgImage.alphaInfo
          assert(alphaInfo == .premultipliedFirst || alphaInfo == .first || alphaInfo == .noneSkipFirst, "This routine expects alpha to be first component")

          let byteOrderInfo = cgImage.byteOrderInfo
          assert(byteOrderInfo == .order32Little || byteOrderInfo == .orderDefault, "This routine expects little-endian 32bit format")

          let bytesPerRow = cgImage.bytesPerRow
          let pixelInfo = Int(point.y) * bytesPerRow + Int(point.x) * 4;

    //  let a: CGFloat = CGFloat(data[pixelInfo+3]) / 255
//let r: CGFloat = CGFloat(data[pixelInfo+2]) / 255
   //       let g: CGFloat = CGFloat(data[pixelInfo+1]) / 255
   //       let b: CGFloat = CGFloat(data[pixelInfo  ]) / 255

    let b = CGFloat(data[pixelInfo]) / CGFloat(255.0)
       let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
       let r = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
       let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
    
          return UIColor(red: r, green: g, blue: b, alpha: a)
   */
    func imageWith(newSize: CGSize) -> UIImage {
         let renderer = UIGraphicsImageRenderer(size: newSize)
         let image = renderer.image { _ in
             self.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
         }

         return image
     }
    
         func getPixelColor(point: CGPoint, sourceView: UIView) -> UIColor {
             let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
             let colorSpace = CGColorSpaceCreateDeviceRGB()
             let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
             let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

             context!.translateBy(x: -point.x, y: -point.y)

             sourceView.layer.render(in: context!)
             let color: UIColor = UIColor(red: CGFloat(pixel[0])/255.0,
                                          green: CGFloat(pixel[1])/255.0,
                                          blue: CGFloat(pixel[2])/255.0,
                                          alpha: CGFloat(pixel[3])/255.0)
             pixel.deallocate()
             return color
         }
    
   
    
    //this function give the best result
   /*public func getPixelColor1(pos: CGPoint) -> UIColor {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
        }
    
    func getPixelColor2(pos: CGPoint) -> UIColor {
        
        guard let cgImage = cgImage, let pixelData = cgImage.dataProvider?.data else { return UIColor.clear }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        // adjust the pixels to constrain to be within the width/height of the image
        let y = pos.y > 0 ? pos.y - 1 : 0
        let x = pos.x > 0 ? pos.x - 1 : 0
        let pixelInfo = ((Int(self.size.width) * Int(y)) + Int(x)) * bytesPerPixel
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    // works for different image formats
    func getPixelColor(_ image:UIImage, _ point: CGPoint) -> UIColor {
        let cgImage : CGImage = image.cgImage!
        guard let pixelData = CGDataProvider(data: (cgImage.dataProvider?.data)!)?.data else {
            return UIColor.clear
        }
        let data = CFDataGetBytePtr(pixelData)!
        let x = Int(point.x)
        let y = Int(point.y)
        let index = Int(image.size.width) * y + x
        let expectedLengthA = Int(image.size.width * image.size.height)
        let expectedLengthGrayScale = 2 * expectedLengthA
        let expectedLengthRGB = 3 * expectedLengthA
        let expectedLengthRGBA = 4 * expectedLengthA
        let numBytes = CFDataGetLength(pixelData)
        switch numBytes {
        case expectedLengthA:
            return UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(data[index])/255.0)
        case expectedLengthGrayScale:
            return UIColor(white: CGFloat(data[2 * index]) / 255.0, alpha: CGFloat(data[2 * index + 1]) / 255.0)
        case expectedLengthRGB:
            return UIColor(red: CGFloat(data[3*index])/255.0, green: CGFloat(data[3*index+1])/255.0, blue: CGFloat(data[3*index+2])/255.0, alpha: 1.0)
        case expectedLengthRGBA:
            return UIColor(red: CGFloat(data[4*index])/255.0, green: CGFloat(data[4*index+1])/255.0, blue: CGFloat(data[4*index+2])/255.0, alpha: CGFloat(data[4*index+3])/255.0)
        default:
            // unsupported format
            return UIColor.clear
        }
    }
}
 */
}
// get RGB value from UIColor
extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
}

extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate,CropperViewControllerDelegate {
    

// This is the label that displays the number when calculate is hit
    @IBOutlet weak var piCalc: UILabel!
    @IBOutlet weak var circleCalc: UILabel!
     @IBOutlet weak var date: UILabel!
    var demoView = DemoView()
    var pinchGesture = UIPinchGestureRecognizer()
    var panGesture = UIPanGestureRecognizer()
    var currentValue:Float = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.demoView = DemoView(frame: CGRect(x: self.view.frame.size.width/2-100.0/2, y: self.view.frame.size.height/2-100.0/2, width: 100.0, height: 100.0))
        
        
        
        // Initialization code
    
        
        self.demoView.isUserInteractionEnabled = true //pinching action setup
        self.demoView.isMultipleTouchEnabled = true
        
        
        self.pinchGesture = UIPinchGestureRecognizer(target: self,action:#selector(handlePinch(recognizer:)))
        self.panGesture = UIPanGestureRecognizer(target: self,action:#selector(handlePan(recognizer:)))
        self.pinchGesture.delegate = self
        self.panGesture.delegate = self
        self.demoView.addGestureRecognizer(self.pinchGesture)
        self.demoView.addGestureRecognizer(self.panGesture)
        
        
        self.view.addSubview(demoView)

        
        }
    
    
    @IBAction func handlePinch(recognizer:UIPinchGestureRecognizer) {
        //demoView.transform = CGAffineTransform(scaleX: recognizer.scale, y: recognizer.scale)
        demoView.transform = demoView.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
        recognizer.scale = 1
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.demoView)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.demoView)
    }

//Displays the image
    
    @IBOutlet weak var pupil: UIImageView!
   
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var pupilLabel: UILabel!
    
    @IBOutlet weak var abnormalCheck: UISwitch!
    @IBOutlet weak var xmax: UILabel!
    @IBOutlet weak var xmin: UILabel!
    @IBOutlet weak var ymin: UILabel!
    @IBOutlet weak var ymax: UILabel!
    @IBOutlet weak var rad: UILabel!
    @IBOutlet weak var cpoint: UILabel!
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var cr: UILabel!
    @IBOutlet weak var cg: UILabel!
    @IBOutlet weak var cb: UILabel!
    @IBAction func abnormalPupil(_ abnormalCheck: UISwitch){
        if abnormalCheck.isOn{
            pupilLabel.text = "THE PUPIL IS ABNORMAL"
            circleCalc.isHidden = true;
        }
        else{
            pupilLabel.text = "THE PUPIL IS NORMAL"
        }
    }
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func sliderMoved(_ slider: UISlider){
        currentValue = slider.value
        demoView.transform = CGAffineTransform(scaleX: CGFloat(currentValue), y: CGFloat(currentValue))
    }
    
    // code to access camera: take picture button
    @IBAction func camera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            //UIImageWriteToSavedPhotosAlbum(pupil.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil) //save image
            //imagePicker.cameraOverlayView = demoView
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    // code to access photo library: upload photo button
    @IBAction func library(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    //code to save image
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
// code to display selected image and crop
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        dismiss(animated: true) {
            let cropperViewController = self.storyboard?.instantiateViewController(withIdentifier: "cropperViewController") as! CropperViewController
            cropperViewController.image = image
            cropperViewController.delegate = self
            self.navigationController?.pushViewController(cropperViewController, animated: true)
        }
    }
    func croppedImage(image: UIImage){
        pupil.image = image
    }
 
    
    //defines the colors that are "black" and part of the pupil. Not all pixels in the pupil will be exactly black, rather, a varying range of dark shades that appear black.
// calculate pi button. Checks "x" number of pixels. "Black" points inside the circle are added to i, others are added to o. Divides to get ratio and displays this ratio.
  @IBAction func calculate(_ sender: Any) {
          var i = 0
          var o = 0
          var x = 0
          var countCirclePixals = 1
    var image = pupil.image
        image = image?.imageWith(newSize: CGSize(width: 414, height: 459))
          //let currentDateTime = Date()
    let currentDateTime = Date()
   let dateFormatter = DateFormatter()
   dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
   date.text = "\(dateFormatter.string(from: currentDateTime))"
          if image == nil {piCalc.text = "please select an image"}
          else{
              
           //   let frameSquare = UIView(frame: demoView.convert(demoView.frame, to: pupil.inputView)) //UI View out of square's location on image frame . //demoView.bounds
              
              //adjust coordinates
              let Xmin = Int(demoView.frame.minX) - Int(pupil.frame.minX)
              let Ymin = Int(demoView.frame.minY) - Int(pupil.frame.minY)
              let Xmax = Int(demoView.frame.maxX) - Int(pupil.frame.minX)
              let Ymax = Int(demoView.frame.maxY) - Int(pupil.frame.minY)
              let radius = Int(demoView.frame.size.width)/2
              /*
               let cXmin = Int(testingCircleClass.frame.minX) - Int(pupil.frame.minX)
               let cYmin = Int(testingCircleClass.frame.minY) - Int(pupil.frame.minY)
               let cXmax = Int(testingCircleClass.frame.maxX) - Int(pupil.frame.minX)
               let cYmax = Int(testingCircleClass.frame.maxY) - Int(pupil.frame.minY)
               let cradius = Int(testingCircleClass.frame.size.width)/2
               
               */
              xmax.text = "Xmax: " + String(Xmax)
              xmin.text = "Xmin: " + String(Xmin)
              ymax.text = "Ymax: " + String(Ymax)
              ymin.text = "Ymin: " + String(Ymin)
              rad.text = "radius: " + String(radius)
              
              
              
              let xCenter = CGFloat(Xmin + radius)
              let yCenter = CGFloat(Ymin + radius)
              let circle1 = UIBezierPath(arcCenter: CGPoint(x: xCenter, y: yCenter), radius: CGFloat(radius), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
          //  let circle1 = demoView.circle
              
              //find the color of the center point
              let centerPoint = CGPoint(x:xCenter,y:yCenter)
            let centerColor = image?.getPixelColor(point: centerPoint, sourceView: (pupil)!)
            let centerR = CGFloat((centerColor?.rgba.red)!)
            let centerG = CGFloat((centerColor?.rgba.green)!)
            let centerB = CGFloat((centerColor?.rgba.blue)!)
              
              cpoint.text = "\("cpoint: ")\(centerPoint)"
              //ccolor.text = "\("ccolor: ")\(centerColor)"
              cr.text = "\("centerR: ")\(centerR)"
              cg.text = "\("centerG: ")\(centerG)"
              cb.text = "\("centerB: ")\(centerB)"
              
              
              // This calculates pi
              while x < 3000{
                  
                let pos = CGPoint(x:Int.random(in:Xmin...Xmax),y:Int.random(in:Ymin...Ymax))
                let color = image!.getPixelColor(point: pos, sourceView: pupil!)
                var red: CGFloat = 0.0
                var green: CGFloat = 0.0
                var blue: CGFloat = 0.0
                  
                  //defines the colors that are "black" and part of the pupil. Not all pixels in the pupil will be exactly black, rather, a varying range of dark shades that appear black.
                  
                red = (color.rgba.red)
                green = (color.rgba.green)
                blue = (color.rgba.blue)
                  
               if circle1.contains(pos){
                          
                          countCirclePixals += 1
                      }
                      //edge case when the center is pure black
                     // if circle1.contains(point) && (centerR + centerG + centerB <= 0.02) {
                   //       centerR = 0.05
                  //        centerG = 0.05
                  //        centerB = 0.05
                  //    }
                      
                      //adjust the values for contrast: right now 0.3 deviation from the color of the center pt
                      //gray scale transformation: New grayscale image = ( (0.3 * R) + (0.59 * G) + (0.11 * B) ).
                      
                      if circle1.contains(pos) && (red + green + blue <= 1.4 * (centerR + centerG + centerB))
                          //                    red < 1.3 * centerR &&
                          //                    green < 1.3 * centerG &&
                          //                    blue < 1.3 * centerB {
                          
                      {
                          i += 1}
                      else{
                          o += 1}
                      
                      x += 1}
                  
          
              let ratio = 4 * Float(i)/Float(x)
              let circleCounterRatio = (Float((Float(countCirclePixals)/3000)*4));
                
              piCalc.text = String(ratio)
              circleCalc.text = "Circle: " + String( circleCounterRatio)
          }//end of while loop
          counter.text = "\("counter: ")\(countCirclePixals)"
          print(i);
          print(o);
          print(x);
          print("\n");
      }
      
  }












