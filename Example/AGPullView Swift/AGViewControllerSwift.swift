//
//  AGViewController.swift
//  AGPullView
//
//  Created by Alexey Getman on 26/09/2016.
//  Copyright © 2016 Aleksey Getman. All rights reserved.
//

import UIKit

class AGViewControllerSwift: UIViewController, AGConfiguratorDelegate, UITableViewDataSource {
    
    let configurator = AGPullViewConfigurator()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //AGPullView configuration
        self.configurator.setupPullView(forSuperview: self.view, colorScheme:ColorSchemeTypeDarkTransparent)
        self.configurator.percentOfFilling = 85
        self.configurator.delegate = self
        self.configurator.needBounceEffect = true
        self.configurator.animationDuration = 0.3
        self.configurator.enableShowingWithTouch = true;
        self.configurator.enableHidingWithTouch = false;
        self.configurator.enableBlurEffect(withBlurStyle: .dark)
        
        //Test UITableView
        let table = UITableView(frame: CGRect(), style: .grouped)
        table.dataSource = self
        table.separatorStyle = .none;
        table.backgroundColor = UIColor.clear
        
        //Filling whole AGPullView with test UITableView
        self.configurator.fullfillContentView(with: table)
    }
    
    //For correct working of layout in early versions of iOS 10
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.configurator.layoutPullView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.red
        cell.textLabel?.text = "Test"
        return cell;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.configurator.handleTouchesBegan(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.configurator.handleTouchesMoved(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.configurator.handleTouchesEnded(touches)
    }
    
    func didDrag(_ pullView: AGPullView!, withOpeningPercent openingPercent: Float) {
        print("\(openingPercent)")
    }
    
    func didShow(_ pullView: AGPullView!) {
        print("shown");
    }

    func didHide(_ pullView: AGPullView!) {
        print("hidden")
    }
    func didTouch(toShow pullView: AGPullView!) {
        print("touched to show")
    }

    func didTouch(toHide pullView: AGPullView!) {
        print("touched to hide")
    }
    
    @IBAction func backToObjCController(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeAppearenceToRandom(_ sender: AnyObject) {
        let randomBlur = arc4random_uniform(2)
        self.configurator.blurStyle = UIBlurEffectStyle(rawValue: Int(randomBlur))!
        
        let randomColorScheme = arc4random_uniform(6)
        self.configurator.colorSchemeType = PullViewColorSchemeType(rawValue: randomColorScheme)
    }
    

}
