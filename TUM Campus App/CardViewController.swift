//
//  ViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft
import UIKit

class CardViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!

    var manager: TumDataManager?
    var cards: [DataElement] = []
    var nextLecture: CalendarRow?
    var refresh = UIRefreshControl()
    
    func refresh(_ sender: AnyObject?) {
        manager?.getCardItems(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "logo-blue")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        self.navigationItem.titleView = imageView
        if let bounds = imageView.superview?.bounds {
            imageView.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height)
        }
        refresh.addTarget(self, action: #selector(CardViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresh)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        manager = (self.tabBarController as? CampusTabBarController)?.manager
        refresh(nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var mvc = segue.destination as? DetailView {
            mvc.delegate = self
        }
        if let mvc = segue.destination as? CalendarViewController {
            mvc.nextLectureItem = nextLecture
        }
    }

}

extension CardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(cards.count, 1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 480
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = cards | indexPath.row ?? EmptyCard()
        let cell = tableView.dequeueReusableCell(withIdentifier: item.getCellIdentifier()) as? CardTableViewCell ?? CardTableViewCell()
        cell.setElement(item)
        cell.selectionStyle = .none
        return cell
    }
    
 func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}


extension CardViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return -1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        return UICollectionViewCell()
    }
    
}


extension CardViewController: ImageDownloadSubscriber, DetailViewDelegate {
    
    func updateImageView() {
        tableView.reloadData()
    }
    
    func dataManager() -> TumDataManager {
        return manager ?? TumDataManager(user: nil)
    }
}

extension CardViewController: TumDataReceiver {
    
    func receiveData(_ data: [DataElement]) {
        if cards.count <= data.count {
            for item in data {
                if let movieItem = item as? Movie {
                    movieItem.subscribeToImage(self)
                }
                if let lectureItem = item as? CalendarRow {
                    nextLecture = lectureItem
                }
            }
            cards = data
            DispatchQueue.main.async(execute: {self.tableView.reloadData()})
        }
        DispatchQueue.main.async(execute: {self.refresh.endRefreshing()})
    }
}

