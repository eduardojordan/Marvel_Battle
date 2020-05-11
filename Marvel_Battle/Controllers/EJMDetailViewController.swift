//
//  EJMDetailViewController.swift
//  Marvel_Battle
//
//  Created by MAC on 11/05/2020.
//  Copyright © 2020 eduardojordan.com. All rights reserved.
//

import UIKit

class EJMDetailViewController: UIViewController {

    @IBOutlet var imageDetail: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var getName = String()
    var getDescription = String()
    var getImage = URL(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = getName
        if getDescription == ""{
        descriptionLabel.text = "Not description Available"
        } else {
        descriptionLabel.text = getDescription
        }
        
        let imgData = getImage
        let pathString = "http://i.annihil.us" + imgData!.path + "/portrait_xlarge.jpg"
        let url = URL(string: pathString)
        imageDetail.image = UIImage(url: url)
        
     
   
        

    }
    


}
