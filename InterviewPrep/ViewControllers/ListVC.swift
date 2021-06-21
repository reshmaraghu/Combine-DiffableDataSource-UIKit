//
//  ListVC.swift
//  InterviewPrep
//
//  Created by Raghu, Reshma L on 10/02/21.
//

import UIKit
import Combine

class TableViewDiffableDataSource: UITableViewDiffableDataSource<String?, ImageModel> {
    
}

class ListVC: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var indexOfSelectedRow: Int?
    var viewModel = ListViewModel()
    @Published var keyStroke: String = ""
    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCells()
        self.setupSearchController()
        self.setupObservers()
    }
    
    private func registerTableViewCells() {
        let customTableViewCell = UINib(nibName: "CustomTableViewCell",
                                  bundle: nil)
        self.tableView.register(customTableViewCell, forCellReuseIdentifier: "CustomTableViewCell")
    }
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for images in NASA's library"
        navigationItem.searchController = searchController
        /**
         * Ensure that the search bar doesn’t remain on the screen if the user navigates to another view controller while the UISearchController is active
         */
        definesPresentationContext = true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexOfSelectedRow = indexPath.row
        self.performSegue(withIdentifier: "showImage", sender: self)
    }
}

//MARK: - UISearchBar Delegate
extension ListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.keyStroke = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.keyStroke = ""
    }
}

//MARK: - Observers
extension ListVC {
    func setupObservers() {
        // MONITOR search bar textfield keystrokes
        $keyStroke
            .receive(on: RunLoop.main)
            .sink { (keyWordValue) in
                print(keyWordValue)
                self.viewModel.keyWordSearch = keyWordValue
            }.store(in: &cancellables)
        // DIFFABLE DS
        viewModel.diffableDataSource = TableViewDiffableDataSource(tableView: tableView) { (tableView, indexPath, model) -> UITableViewCell? in
                    
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell
                else { return UITableViewCell() }
                    
            cell.imageModel = model
            return cell
        }
    }
}
