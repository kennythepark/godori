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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userCollectionView.dataSource = self
        userCollectionView.delegate = self
        
        userCollectionView.register(UINib(nibName: gamePlayUserCellNibName, bundle: nil),
                                 forCellWithReuseIdentifier: gamePlayUserCellReuseIdentifier)
    }
    
    @IBAction func saveAndCloseAction(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

}

extension GamePlayViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let users = session?.users else { return 0 }
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gamePlayUserCellReuseIdentifier,
                                                      for: indexPath) as! GamePlayUserCollectionViewCell
        
        guard let users = session?.users else { return cell }
        
        let user = Array(users)[indexPath.row] as! CDUser
        
        cell.nameLabel.text = user.name
    
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 8, 8, 8)
    }
    
}
