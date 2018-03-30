//
//  InsertScoreViewController.swift
//  godori
//
//  Created by KP on 2018-03-27.
//  Copyright © 2018 KP. All rights reserved.
//

import UIKit

private let insertScoreCellNibName = "InsertScoreTableViewCell"
private let insertScoreCellReuseIdentifier = "InsertScoreCellIdentifier"

class InsertScoreViewController: UIViewController {
    
    var receiver: CDUser?
    var payers: [CDUser]?
    
    @IBOutlet weak var payersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payersTableView.dataSource = self
        payersTableView.delegate = self
        payersTableView.separatorStyle = .none
        
        payersTableView.register(UINib.init(nibName: insertScoreCellNibName, bundle: nil),
                                 forCellReuseIdentifier: insertScoreCellReuseIdentifier)
        
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

}

extension InsertScoreViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payers!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: insertScoreCellReuseIdentifier,
                                                 for: indexPath) as! InsertScoreTableViewCell
        
        guard let payer = payers?[indexPath.row] else { return cell }
        
        cell.selectionStyle = .none
        cell.nameLabel.text = payer.name
        cell.totalScoreLabel.text = "0"
        
        return cell
    }
    
    
}
