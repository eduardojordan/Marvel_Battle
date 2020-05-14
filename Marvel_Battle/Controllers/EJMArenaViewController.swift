//
//  EJMArenaViewController.swift
//  Marvel_Battle
//
//  Created by MAC on 12/05/2020.
//  Copyright © 2020 eduardojordan.com. All rights reserved.
//

import UIKit
import CoreData

class EJMArenaViewController: UIViewController , EJMSearchViewControllerDelegate, EJMSearchViewControllerDelegate2{
    
    
    @IBOutlet var nameHero1Label: UILabel!
    @IBOutlet var imageHero1: UIImageView!
    @IBOutlet var nameHero2Label: UILabel!
    @IBOutlet var imageHero2: UIImageView!
    @IBOutlet var selectHero1: UIButton!
    @IBOutlet var selectHero2: UIButton!
    @IBOutlet var combatBButton: UIButton!
    
    var getName1 = ""
    var getImage1 = URL(string: "")
    var getComics1 = 0
    
    var getName2 = ""
    var getImage2 = URL(string: "")
    var getComics2 = 0
    
    func addItemViewController(_ controller: EJMSearchViewController?, didFinishEnteringItem item: DataCharacter?) {
        self.getName1 = (item?.name)!
        self.getImage1 = item?.image
        self.getComics1 = item!.totalComics
        print("COMBATIENTE (1)",getName1)
    }
    
    func addItemViewController2(_ controller: EJMSearchViewController?, didFinishEnteringItem item: DataCharacter?) {
        self.getName2 = (item?.name)!
        self.getImage2 = item?.image
        self.getComics2 = item!.totalComics
        print("COMBATIENTE (2)",getName2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectHero1.addTarget(self, action:#selector(actionSelectHero1), for: .touchUpInside)
        selectHero2.addTarget(self, action:#selector(actionSelectHero2), for: .touchUpInside)
        combatBButton.addTarget(self, action:#selector(actionCombat), for: .touchUpInside)
    }
    
    @objc func actionSelectHero1(){
        let controller = storyboard!.instantiateViewController(withIdentifier: "EJMSearchViewController") as! EJMSearchViewController
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
        
        nameHero1Label.text = self.getName1
        print(">",self.getName1)
        if getImage1 != nil {
            let pathString = "http://i.annihil.us" + getImage1!.path + "/portrait_xlarge.jpg"
            let url = URL(string: pathString)
            if  url == nil {
                imageHero1.image = UIImage(named: "imgNotAvailable.jpg")
            }else{
                imageHero1.image = UIImage(url: url)
            }
        }
    }
    
    
    @objc func actionSelectHero2(){
        let controller = storyboard!.instantiateViewController(withIdentifier: "EJMSearchViewController") as! EJMSearchViewController
        controller.delegate2 = self
        self.present(controller, animated: true, completion: nil)
        
        nameHero2Label.text = self.getName2
        print(">",self.getName2)
        if getImage2 != nil {
            let pathString = "http://i.annihil.us" + getImage2!.path + "/portrait_xlarge.jpg"
            let url = URL(string: pathString)
            if  url == nil {
                imageHero2.image = UIImage(named: "imgNotAvailable.jpg")
            }else{
                imageHero2.image = UIImage(url: url)
            }
        }
    }
    
    @objc func actionCombat(){
        
        isFighterIsNil()
        isFighterIsSame()
        FightersIsOnlyOne()
        FighterReady()
        coredataSave()
        
    }
    
    func isFighterIsNil(){
        if (self.getName1 == "" && self.getName2 == "") {
            print("DEBE SELECCIONAR 2 HEROES")
            let alert = UIAlertController(title: "Attention", message: "You must select 2 marvel heroes", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func isFighterIsSame(){
        if (self.getName1 == self.getName2)  {
            print("COMBATIENTES",self.getName1, self.getName2)
            
            print("EL RESULTADO SIEMPRE SERA EMPATE")
            let alert = UIAlertController(title: "Attention", message: "They must be different super heroes", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func FightersIsOnlyOne(){
        if (self.getName1 == "" || self.getName2 == ""){
            print("DEBE COLOCAR 2 ")
            
            let alert = UIAlertController(title: "Attention", message: "Must have 2 fighters", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func FighterReady(){
        // WIN BIGGER COMICS SHOW
        var win = max(self.getComics1, self.getComics2)
        print("COMBAT \(self.getName1,self.getComics1) vs \(self.getName2,self.getComics2)")
        var winner = ""
        var combatWinnerCounter = +1
        if win == self.getComics1 {
            winner = self.getName1
        } else {
            winner = self.getName2
        }
        let alert = UIAlertController(title: "The Winners is...", message: " 👉 \(winner) 👈", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ranking show", style: UIAlertAction.Style.destructive, handler: { action in
            
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "EJMRankingViewController") as! EJMRankingViewController
            self.present(controller, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func coredataSave(){
        // COREDATA SAVE
        //        print("COREDATA SAVE!!")
        //           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        //           let managedContex = appDelegate.persistentContainer.viewContext
        //           let userEntity = NSEntityDescription.entity(forEntityName: "CharacterEntity", in: managedContex)!
        //
        //           let product = NSManagedObject(entity: userEntity, insertInto: managedContex)
        //        // SALVAR EL GANADOR NAME AND SUMAR UNA VEZ DE GANADA
        //        print("PARA COREDATA COMBATWINNER NAME ", winner)
        //        print("PARA COREDATA COMBATWINNER COUNTER", combatWinnerCounter)
        //          product.setValue(combatWinnerCounter, forKey: "combatWinner")
        //           product.setValue(winner, forKey: "nameChracter")
        //
        //           do{
        //               try managedContex.save()
        //           }catch let error as NSError{
        //               print("Could not save \(error)")
        //           }
    }
    
}

extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
