//  DemoView.swift
//  PrototypeApp
//
//  Created by New User on 4/7/19.
//  Copyright © 2019 New User. All rights reserved.
//

import UIKit
import CoreImage

protocol CropperViewControllerDelegate {
    func croppedImage(image: UIImage)
    
}



final class CropperViewController: UIViewController {
    
    
    //  MARK: - Properties
    
    var image: UIImage!
    var delegate: CropperViewControllerDelegate!
    var context:CIContext!
    var currentFilter: CIFilter!
    var processedImage:UIImage!
    
    // MARK: - Connections:
    
    // MARK: -- Outlets
    
    private var cropView: AKImageCropperView {
        return cropViewProgrammatically ?? cropViewStoryboard
    }
    
    @IBOutlet weak var cropViewStoryboard: AKImageCropperView!
    private var cropViewProgrammatically: AKImageCropperView!
    
    @IBOutlet weak var overlayActionView: UIView!
    
    @IBOutlet weak var navigationView: UIView!
    
    // MARK: -- Actions
    @IBOutlet weak var intensity: UISlider!
    
    @IBAction func backAction(_ sender: AnyObject) {
        
        guard !cropView.isEdited else {
            
            let alertController = UIAlertController(title: "Warning!", message:
                "All changes will be lost.", preferredStyle: UIAlertController.Style.alert)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.cancel, handler: { _ in
                
                _ = DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
 self.navigationController?.popViewController(animated: true)
                }}))
            
            alertController.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            return
        }
        
        _ = DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.navigationController?.popViewController(animated: true)
        }}
    
    @IBAction func ChangeFilter(_ sender: UIButton) {
        
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Exposure", style: .default, handler: setFilter))
        
        ac.addAction(UIAlertAction(title: "Blur", style: .default, handler: setFilter))
        
        ac.addAction(UIAlertAction(title: "Sepia", style: .default, handler: setFilter))
        
        ac.addAction(UIAlertAction(title: "Sharpness", style: .default, handler: setFilter))
        
        ac.addAction(UIAlertAction(title: "Negative", style: .default, handler: setFilter))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    func setFilter(action: UIAlertAction) {
        // make sure we have a valid image before continuing!
        guard context != nil else { return }

        // safely read the alert action's title
        //guard let actionTitle = action.title else { return }
        if action.title == "Blur"{
            currentFilter = CIFilter(name: "CIGaussianBlur")
        }else if action.title == "Sepia"{
            currentFilter = CIFilter(name: "CISepiaTone")
        }
        else if action.title == "Sharpness"{
            currentFilter = CIFilter(name: "CIUnsharpMask")
        }
        else if action.title == "Negative"{
            currentFilter = CIFilter(name: "CIColorInvert")
        }
        
        else if action.title == "Exposure"{
                  currentFilter = CIFilter(name: "CIExposureAdjust")
            
        }
        
        
        guard let image = cropView.croppedImage else { return  }
        let cgimg = CIImage(image: image)
        currentFilter.setValue(cgimg, forKey: kCIInputImageKey)
        applyProcessing()
        intensity.isEnabled = true
        
    }
    

    @IBAction func intensityChanged(_ sender: UISlider) {
        
        //cropView.alpha = CGFloat(sender.value)
        applyProcessing()
        
        //print("Filter Applied ")
    }

    func applyProcessing(){
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)}
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity.value * 1, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 20, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: image.size.width / 2, y: image.size.height / 2), forKey: kCIInputCenterKey) }
        if inputKeys.contains(kCIInputEVKey) { currentFilter.setValue(intensity.value/4, forKey: kCIInputEVKey) }
         
        if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
           let image = UIImage(cgImage: cgimg)
            self.cropView.image = image
        }
        
    }
    @IBAction func cropImageAction(_ sender: AnyObject) {
        
         guard let image = cropView.croppedImage else {
            return
         }
        //SAVE Function //
        let alertController = UIAlertController(title: "Save", message:
            "Do you Want to Save This Image?", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
            _ = DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.navigationController?.popViewController(animated: true)
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }}))
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: { _ in
            _ = DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.navigationController?.popViewController(animated: true)
            }}))
        present(alertController, animated: true, completion: nil)
        //**********//
        delegate.croppedImage(image: image)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func showHideOverlayAction(_ sender: AnyObject) {
        
        if cropView.isOverlayViewActive {
            
            cropView.hideOverlayView(animationDuration: 0.3)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                self.overlayActionView.alpha = 0
                
            }, completion: nil)
            
        } else {
            
            cropView.showOverlayView(animationDuration: 0.3)
            
            UIView.animate(withDuration: 0.3, delay: 0.3, options: UIView.AnimationOptions.curveLinear, animations: {
                self.overlayActionView.alpha = 1
                
            }, completion: nil)
            
        }
        
        
    }
    
    var angle: Double = 0.0
    
    @IBAction func rotateAction(_ sender: AnyObject) {

        angle += Double.pi/2
        
        cropView.rotate(angle, withDuration: 0.3, completion: { _ in
            
            if self.angle == 2 * Double.pi {
                self.angle = 0.0
            }
        })
    }
    
    @IBAction func resetAction(_ sender: AnyObject) {
        
       
        
        if self.image != nil{
            cropView.image = image
            
        }
    }
    
    // MARK: -  Life Cycle

    var demoView = DemoView()
    var pinchGesture = UIPinchGestureRecognizer()
    var panGesture = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.cropView.isUserInteractionEnabled = true; //pinching action setup
        self.cropView.isMultipleTouchEnabled = true;
        self.demoView.isUserInteractionEnabled = true; //pinching action setup
               self.demoView.isMultipleTouchEnabled = true;
        title = "instafilter"; navigationController?.isNavigationBarHidden = true;
        self.demoView
            = DemoView(frame: CGRect(x: self.view.frame.size.width/2-100.0/2, y: self.view.frame.size.height/2-100.0/2, width:100.0, height: 100.0));
        
             self.pinchGesture = UIPinchGestureRecognizer(target: self,action:#selector(handlePinch(recognizer:)))
        self.pinchGesture.delegate = self as? UIGestureRecognizerDelegate
        self.panGesture.delegate = self as? UIGestureRecognizerDelegate
                    self.cropView.addGestureRecognizer(self.pinchGesture)
             self.view.addSubview(demoView)
        // Programmatically initialization
        
        /*
        cropViewProgrammatically = AKImageCropperView()
        */
        
        // iPhone 4.7"
        
        /*
        cropViewProgrammatically = AKImageCropperView(frame: CGRect(x: 0, y: 20.0, width: 375.0, height: 607.0))
        view.addSubview(cropViewProgrammatically)
        */
        
        // with constraints
        
        /*
        cropViewProgrammatically = AKImageCropperView()
        cropViewProgrammatically.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cropViewProgrammatically)
        
        if #available(iOS 9.0, *) {
            
            cropViewProgrammatically.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            cropViewProgrammatically.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            topLayoutGuide.bottomAnchor.constraint(equalTo: cropViewProgrammatically.topAnchor).isActive = true
            cropViewProgrammatically.bottomAnchor.constraint(equalTo: navigationView.topAnchor).isActive = true
            
        } else {
            
            for attribute: NSLayoutAttribute in [.top, .left, .bottom, .right] {
                
                var toItem: Any?
                var toAttribute: NSLayoutAttribute!
                
                if attribute == .top {
                    
                    toItem = topLayoutGuide
                    toAttribute = .bottom
                    
                } else if attribute == .bottom {
                    
                    toItem = navigationView
                    toAttribute = .top
                } else {
                    toItem = view
                    toAttribute = attribute
                }
                
                view.addConstraint(
                    NSLayoutConstraint(
                        item: cropViewProgrammatically,
                        attribute: attribute,
                        relatedBy: NSLayoutRelation.equal,
                        toItem: toItem,
                        attribute: toAttribute,
                        multiplier: 1.0, constant: 0))
            }
        }
        */
        

        // Inset for overlay action view
        
        /*
        cropView.overlayView?.configuraiton.cropRectInsets.bottom = 50
        */
        
        // Custom overlay view configuration
        
        /*
        var customConfiguraiton = AKImageCropperCropViewConfiguration()
            customConfiguraiton.cropRectInsets.bottom = 50
        cropView.overlayView = CustomImageCropperOverlayView(configuraiton: customConfiguraiton)
        */
        
        cropView.delegate = self
        cropView.image = image
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        
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
}

//  MARK: - AKImageCropperViewDelegate

extension CropperViewController: AKImageCropperViewDelegate {
    
    func imageCropperViewDidChangeCropRect(view: AKImageCropperView, cropRect rect: CGRect) {
//        print("New crop rectangle: \(rect)")
    }
    

}
