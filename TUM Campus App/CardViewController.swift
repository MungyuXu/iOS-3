//
//  ViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft
import UIKit

class CardViewController: UITableViewController, EditCardsViewControllerDelegate {
    
    var manager: TumDataManager?
    var cards: [DataElement] = []
    var nextLecture: CalendarRow?
    var refresh = UIRefreshControl()
    var search: UISearchController?
    
    func refresh(_ sender: AnyObject?) {
<<<<<<< HEAD
        manager?.getCardItems(self)
        if cards.count == 0 {
            refresh.endRefreshing()
        }
    }
    
    func didUpdateCards() {
        cards.removeAll()
        refresh(nil)
        tableView.reloadData()
=======
        manager?.loadCards(skipCache: sender != nil).onResult(in: .main) { data in
            self.nextLecture = data.value?.flatMap({ $0 as? CalendarRow }).first
            self.cards = data.value ?? []
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
>>>>>>> master
    }
    
    func didUpdateCards() {
        refresh(nil)
        tableView.reloadData()
    }
    
<<<<<<< HEAD
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
=======
}

extension CardViewController: DetailViewDelegate {
    
    func dataManager() -> TumDataManager? {
        return manager
>>>>>>> master
    }
}

extension CardViewController {
    
    func setupLogo() {
        let bundle = Bundle.main
        let nib = bundle.loadNibNamed("TUMLogoView", owner: nil, options: nil)?.flatMap { $0 as? UIView }
        guard let view = nib?.first else { return }
        self.navigationItem.titleView = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogo()
<<<<<<< HEAD

        refresh.addTarget(self, action: #selector(CardViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresh)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        manager = (self.tabBarController as? CampusTabBarController)?.manager
        refresh(nil)
=======
        setupTableView()
        setupSearch()
        
        manager = (self.navigationController as? CampusNavigationController)?.manager
        refresh(nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
>>>>>>> master
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var mvc = segue.destination as? DetailView {
            mvc.delegate = self
        }
        if let navCon = segue.destination as? UINavigationController,
            let mvc = navCon.topViewController as? EditCardsViewController {
<<<<<<< HEAD
            mvc.delegate = self
        }
=======
            
            mvc.delegate = self
        }

>>>>>>> master
        if let mvc = segue.destination as? CalendarViewController {
            mvc.nextLectureItem = nextLecture
        }
    }
<<<<<<< HEAD
=======
    
    func setupLogo() {
        let bundle = Bundle.main
        let nib = bundle.loadNibNamed("TUMLogoView", owner: nil, options: nil)?.flatMap { $0 as? UIView }
        guard let view = nib?.first else { return }
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        self.navigationItem.titleView = view
    }
    
    func setupTableView() {
        refresh.addTarget(self, action: #selector(CardViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresh)
        definesPresentationContext = true
    }
    
    func setupSearch() {
        let storyboard = UIStoryboard(name: "CardView", bundle: nil)
        guard let searchResultsController = storyboard.instantiateViewController(withIdentifier: "SearchResultsController") as? SearchResultsController else {
            fatalError("Unable to instatiate a SearchResultsViewController from the storyboard.")
        }
        searchResultsController.delegate = self
        searchResultsController.navCon = self.navigationController
        search = UISearchController(searchResultsController: searchResultsController)
        search?.searchResultsUpdater = searchResultsController
        search?.searchBar.placeholder = "Search"
        search?.obscuresBackgroundDuringPresentation = true
        search?.hidesNavigationBarDuringPresentation = true
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = search
        } else {
            self.tableView.tableHeaderView = search?.searchBar
        }
    }
>>>>>>> master
}

extension CardViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(cards.count, 1)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 480
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = cards | indexPath.row ?? EmptyCard()
        let cell = tableView.dequeueReusableCell(withIdentifier: item.getCellIdentifier()) as? CardTableViewCell ?? CardTableViewCell()
        cell.setElement(item)
        cell.selectionStyle = .none
		return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}


