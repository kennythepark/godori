//
//  GamePlayViewController.swift
//  godori
//
//  Created by KP on 2018-03-28.
//  Copyright © 2018 KP. All rights reserved.
//

import UIKit

private let gamePlayUserCellNibName = "GamePlayUserCollectionViewCell"
private let gamePlayUserCellReuseIdentifier = "GamePlayUserCellIdentifier"

class GamePlayViewController: UIViewController {

    @IBOutlet weak var userCollectionView: UICollectionView!
    var session: CDSession?
    var users: [CDUser]?
    
    var receiver: CDUser? = nil
    var payers: [CDUser]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userCollectionView.dataSource = self
        userCollectionView.delegate = self
        userCollectionView.register(UINib(nibName: gamePlayUserCellNibName, bundle: nil),
                                 forCellWithReuseIdentifier: gamePlayUserCellReuseIdentifier)
        
        guard let userSet = session?.users else { return }
        users = Array(userSet) as? [CDUser]
        
        initializeCurrentScores()
    }
    
    @IBAction func saveAndCloseAction(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

}

// MARK: Segue Logic
extension GamePlayViewController {
    @objc func performSegueToInsertScoreViewController(sender: UIButton) {
        let buttonTag = sender.tag
        
        receiver = users?[buttonTag]
        
        // I really don't like this, something more elegant please
        users?.forEach({ user in
            if users?.index(of: user) != buttonTag {
                payers?.append(user)
            }
        })
        
        performSegue(withIdentifier: "calculateTransaction", sender: self)
        
        receiver = nil
        payers?.removeAll()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calculateTransaction" {
            if let gamePlayVC = segue.destination as? InsertScoreViewController {
                gamePlayVC.receiver = receiver
                gamePlayVC.payers = payers
            }
        }
    }
}

// MARK: Score Calculation Logic
extension GamePlayViewController {
    func initializeCurrentScores() {
        users?.forEach({ user in
            user.currentScore = 0
        })
    }
}

extension GamePlayViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gamePlayUserCellReuseIdentifier,
                                                      for: indexPath) as! GamePlayUserCollectionViewCell
        
        guard let user = users?[indexPath.row] else { return cell }
        
        cell.nameLabel.text = user.name
        cell.currentScoreLabel.text = String(user.currentScore)
//        cell.calculateScoreButton.tag = indexPath.row
//        cell.calculateScoreButton.addTarget(self,
//                                            action: #selector(performSegueToInsertScoreViewController(sender:)),
//                                            for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did press at indexPath \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 8, 8, 8)
    }
    
}
