//
//  ViewController.swift
//  Pong
//
//  Created by Guillaume Etendard on 16/03/2018.
//  Copyright © 2018 Guillaume Etendard. All rights reserved.
//

import UIKit

class ViewController : UIViewController{
    @IBAction func vsComputer(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Difficulty", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Easy", style: .default, handler: { action in
            print(action)
            self.performSegue(withIdentifier: "game", sender: Double(0.7))
        }))
        alert.addAction(UIAlertAction(title: "Medium", style: .default, handler: { action in
            print(action)
            self.performSegue(withIdentifier: "game", sender: Double(0.4))
        }))
        alert.addAction(UIAlertAction(title: "Hard", style: .default, handler: { action in
            print(action)
            self.performSegue(withIdentifier: "game", sender: Double(0.2))
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func vsPlayer(_ sender: UIButton) {
        self.performSegue(withIdentifier: "game", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! GameViewController
        if let difficulty = sender as? Double{
            controller.difficulty = difficulty
            controller.type = "computerGame"
        }else{
            controller.type = "playerGame"
        }
    }
}
