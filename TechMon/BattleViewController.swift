//
//  BattleViewController.swift
//  TechMon
//
//  Created by 竹村明日香 on 2020/05/15.
//  Copyright © 2020 Takemura assan. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerHPLabel: UILabel!
    @IBOutlet var playerMPLabel: UILabel!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPLabel: UILabel!
    @IBOutlet var enemyMPLabel: UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var playerHP = 100
    var playerMP = 0
    var enemyHP = 200
    var enemyMP = 0
    
    var gameTimer: Timer!
    var isPlayerAttackAvailabel: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerNameLabel.text = "勇者"
        playerImageView.image = UIImage(named: "yusya.png")
        playerHPLabel.text = "\(playerHP) / 100"
        playerMPLabel.text = "\(playerHP) / 20"
        
        enemyNameLabel.text = "龍"
        enemyImageView.image = UIImage(named: "monster.png")
        enemyHPLabel.text = "\(enemyHP) / 200"
        enemyMPLabel.text = "\(enemyMP) / 35"
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGame), userInfo: nil, repeats: true)
        
        gameTimer.fire()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "BGM_battle001")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
    
    @objc func updateGame(){
        
        playerMP += 1
        if playerMP >= 20 {
            
            isPlayerAttackAvailabel = true
            playerMP = 20
        } else {
            
            isPlayerAttackAvailabel = false
        }
        
        enemyMP += 1
        if enemyMP >= 35{
            
            enemyAttack()
            enemyMP = 0
        }
        
        playerMPLabel.text = "\(playerMP) / 20"
        enemyMPLabel.text = "\(enemyMP) / 35"
    }
    
    func enemyAttack(){
        
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        playerHP -= 20
        
        playerHPLabel.text = "\(playerHP) / 100"
        
        if playerHP <= 0{
            
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        }
    }
    
    func finishBattle(vanishImageView: UIImageView, isPlayerWin: Bool){
        techMonManager.vanishAnimation(imageView: vanishImageView)
        techMonManager.stopBGM()
        gameTimer.invalidate()
        isPlayerAttackAvailabel = false
        
        var finishMessage: String = ""
        if isPlayerWin {
            
            techMonManager.playSE(fileName: "SE_fanfare")
            finishMessage = "勇者の勝利！"
        } else {
            
            techMonManager.playSE(fileName: "SE_gameover")
            finishMessage = "勇者の敗北..."
        }
        
        let alert = UIAlertController(title: "バトル終了", message: finishMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated:  true, completion: nil)
    }
    
    @IBAction func attackAtion(){
        
        if isPlayerAttackAvailabel {
            
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_attack")
            
            enemyHP -= 30
            playerMP = 0
            
            enemyHPLabel.text = "\(enemyHP) / 200"
            playerMPLabel.text = "\(playerMP) / 20"
            
            if enemyHP <= 0 {
                
                finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}
