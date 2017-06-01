//
//  secondViewController.swift
//  navigateTest
//
//  Created by Bik Gai Hai Gormint on 3/10/17.
//  Copyright © 2017 amirulz. All rights reserved.
//

import UIKit

class secondViewController: UIViewController {

    @IBOutlet weak var lblOutlet: UILabel!
    var inputString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblOutlet.text = inputString

        // Do any additional setup after loading the view.
    }

    @IBAction func btnBack(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

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
