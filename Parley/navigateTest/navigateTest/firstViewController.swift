//
//  firstViewController.swift
//  navigateTest
//
//  Created by Bik Gai Hai Gormint on 3/10/17.
//  Copyright © 2017 amirulz. All rights reserved.
//

import UIKit

class firstViewController: UIViewController {

    @IBOutlet weak var btnOutlet: UITextField!
    @IBAction func navigateToSecond(sender: UIButton) {
        
        if(btnOutlet.text != ""){
    
        let storyBoardObj = UIStoryboard(name: "Main", bundle: nil)
        let secondViewContollerObj = storyBoardObj.instantiateViewController(withIdentifier: "secondViewController") as! secondViewController
        secondViewContollerObj.inputString = btnOutlet.text
        
       // let delegate = UIApplication.shared.delegate as! AppDelegate
        
       // delegate.window?.rootViewController=secondViewContollerObj
        self.navigationController?.pushViewController(secondViewContollerObj, animated: true)
        }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
