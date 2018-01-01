//
//  CityPickerViewController.swift
//  Noemi Official
//
//  Created by LIVECT LAB on 13/03/2016.
//  Copyright © 2016 LIVECT LAB. All rights reserved.
//

import UIKit

public protocol CityPickerViewControllerDelegate: class {
    func CityPickerDidSelectRow(nation: String, city: String)
    func CityPickerDidPressedCancelButton()
    func CityPickerDidPressedSelectButton(CityPicker: CityPickerViewController ,nation: String, city: String)
}

public class CityPickerViewResponder {
    let CityPicker: CityPickerViewController
    
    // Initialisation
    public init(CityPicker: CityPickerViewController) {
        self.CityPicker = CityPicker
    }

    public func close() {
        self.CityPicker.hideView()
    }
    
    public func setDismissBlock(dismissBlock: @escaping DismissBlock) {
        self.CityPicker.dismissBlock = dismissBlock
    }
}


public typealias DismissBlock = () -> Void

// numberOfComponents and pickerView
//MARK: The Main Class
public class CityPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    

    // Members declaration
    var baseView = UIView()
    var blurView = UIVisualEffectView()
    var cityPicker = UIPickerView()
    var closeBtn = UIButton()
    var selectBtn = UIButton()
    var cityLabel =  UILabel()
    var nationLabel =  UILabel()
    var dismissBlock : DismissBlock?
    private var selfReference: CityPickerViewController?
    
    
    // DELEGATE
    public weak var delegate: CityPickerViewControllerDelegate! = nil
    
    // ARRAYS
    var nations = cityPickerClass.getNations().nations
    var currentCities = [String]()
    
    // Options
    var startingNation = "Italy"
    var startingCity = "Rome"
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    
    required public init() {
        super.init(nibName:nil, bundle:nil)
        // Set up main view
        
        view.frame = UIScreen.main.bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        view.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.0)
        view.addSubview(baseView)
        // Base View
        baseView.frame = view.frame
        
        //visual effect view
        blurView.frame = view.frame
        blurView.effect = UIBlurEffect(style: .dark)
        baseView.addSubview(blurView)
        
        // close button
        closeBtn.frame = CGRect(x: 10, y: 0, width: 50, height: 30)
        closeBtn.layer.masksToBounds = true
        closeBtn.setTitle("Cancel", for: .normal)
        closeBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        closeBtn.contentHorizontalAlignment = .left
        closeBtn.addTarget(self, action: Selector(("closeCityPickerView:")), for: .touchUpInside)
        baseView.addSubview(closeBtn)
        
        // select button
        selectBtn.frame = CGRect(x: baseView.frame.width - 60, y: 0, width: 50, height: 30)
        selectBtn.layer.masksToBounds = true
        selectBtn.setTitle("Select", for: .normal)
        selectBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        selectBtn.contentHorizontalAlignment = .right
        selectBtn.addTarget(self, action: Selector(("selectCityPickerView:")), for: .touchUpInside)
        baseView.addSubview(selectBtn)
        
        //title label
        cityLabel.frame = CGRect(x: 0, y: 0, width: baseView.frame.width - 120, height: 30)
        cityLabel.center.x = baseView.center.x
        cityLabel.text = startingCity
        cityLabel.textAlignment = .center
        cityLabel.textColor = UIColor.lightGray
        cityLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        cityLabel.adjustsFontSizeToFitWidth = true
        cityLabel.minimumScaleFactor = 0.5
        baseView.addSubview(cityLabel)
        
        //nation label
        nationLabel.frame = CGRect(x: 0, y: 0, width: baseView.frame.width - 120, height: 30)
        nationLabel.center.x = baseView.center.x
        nationLabel.text = startingNation
        baseView.addSubview(nationLabel)
        nationLabel.isHidden = true
        
        //picker view
        cityPicker.frame = CGRect(x: 0, y: 40, width: baseView.frame.width, height: baseView.frame.height - 40)
        baseView.addSubview(cityPicker)
        
        
        
        cityPicker.delegate = self
        cityPicker.dataSource = self
        
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let rv = UIApplication.shared.keyWindow! as UIWindow
        let sz = rv.frame.size
        
        // Set background frame
        view.frame.size = sz
        
    }
    
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        //cityPicker.delegate = self
        //cityPicker.dataSource = self
    }
    
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        callCities(_nation: "Italy")
        print("number of components \(cityPicker.numberOfComponents)")
        cityPicker.selectRow(108, inComponent: 0, animated: false)
        cityPicker.selectRow(3398, inComponent: 1, animated: false)
        
        cityPicker.reloadAllComponents()
        cityLabel.text = startingCity
        nationLabel.text = startingNation
        
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        cityLabel.text?.removeAll()
        nationLabel.text?.removeAll()
    }
    
    // show view
    public func showCityPicker(ViewController:UIViewController,backgroundColor:UIColor, blurView_hidden: Bool) -> CityPickerViewResponder{
        
        return showCityPickerView(viewController: ViewController,backgroundColor: backgroundColor,blurView_hidden: blurView_hidden)
        
    }
    
    public func showCityPickerView(viewController:UIViewController, backgroundColor:UIColor, blurView_hidden: Bool) -> CityPickerViewResponder {
        selfReference = self
        let rv = UIApplication.shared.keyWindow! as UIWindow
        //rv.addSubview(view)
        view.frame = rv.bounds
        baseView.frame = rv.bounds
        blurView.frame = rv.bounds
        
        
        baseView.backgroundColor = backgroundColor
        blurView.isHidden = blurView_hidden
        
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewController.present(selfReference!, animated: true, completion: nil)
        
        
        
        return CityPickerViewResponder(CityPicker: self)
    }
    
    //MARK: Select Button
    
    func selectCityPickerView(sender: UIButton!) {
        
        delegate?.CityPickerDidPressedSelectButton(CityPicker: self, nation: nationLabel.text!, city: cityLabel.text!)
        hideView()
    }
    
    //MARK: Close CityPicker
    
    func closeCityPickerView(sender: UIButton!) {
        
        hideView()
        delegate?.CityPickerDidPressedCancelButton()
    }
    
    public func hideView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 1
            }, completion: { finished in
                
                if(self.dismissBlock != nil) {
                    // Call completion handler when the alert is dismissed
                    self.dismissBlock!()
                }
                
                
                self.dismiss(animated: true, completion: nil)
                self.selfReference = nil
        })
    }
    
    
    
    //MARK: Main Functions
    func callCities(_nation: String) {
        
        let citiesArray = cityPickerClass.getNations().allValues[_nation] as! [String]
        print("citiesArray: \(citiesArray.count)")
        let sortedcities = citiesArray.sorted {  $0 < $1 }
        print("sortedcities: \(sortedcities.count)")
        
        currentCities = sortedcities
        
    }




//MARK: Extension Picker Delegate

    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            
            return nations.count
            
        }else {
            
            return currentCities.count
        }
        
        
    
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        
        
        if component == 0 {
            let titleData = nations[row]
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 15.0)!,NSAttributedStringKey.foregroundColor:UIColor.white])
            return myTitle
        } else {
            
            let titleData = currentCities[row]
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 15.0)!,NSAttributedStringKey.foregroundColor:UIColor.white])
            return myTitle
        }
        
    }
    
    
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("here1")
        if component == 0 {
            
            callCities(_nation: nations[row])
            cityPicker.reloadComponent(1)
        
        }
        
        nationLabel.text = nations[pickerView.selectedRow(inComponent: 0)]
        cityLabel.text = currentCities[pickerView.selectedRow(inComponent: 1)]
        
        delegate?.CityPickerDidSelectRow(nation: nationLabel.text!,city: cityLabel.text!)
    }
    
    
    
    public func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
}
