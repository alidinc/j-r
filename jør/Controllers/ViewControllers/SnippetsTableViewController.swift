//
//  ViewController.swift
//  jør
//
//  Created by Ali Dinç on 23/07/2021.
//

import UIKit

class SnippetsTableViewController: UITableViewController {

    // MARK: - Properties
    
    let searchBarController = UISearchController(searchResultsController: nil)

    var isSearchBarEmpty: Bool {
        searchBarController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        return searchBarController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearch(_ searchText: String) {
        SnippetController.shared.filteredSnippets = SnippetController.shared.snippets.filter {
            (snippet: Snippet) -> Bool in
            return snippet.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        SnippetController.shared.loadFromPersistenceStore()
        
        searchBarController.searchResultsUpdater = self
        searchBarController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchBarController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
    tableView.reloadData()
    }
}



extension SnippetsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? SnippetController.shared.filteredSnippets.count : SnippetController.shared.snippets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "snippetCell", for: indexPath) as? SnippetTableViewCell else { return UITableViewCell() }
        
        let snippet: Snippet
        if isFiltering {
            snippet = SnippetController.shared.filteredSnippets[indexPath.row]
        } else {
            snippet = SnippetController.shared.snippets[indexPath.row]
        }
        cell.snippet = snippet
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let destinationVC = segue.destination as? DetailViewController,
                  let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let snippet: Snippet
            if isFiltering {
                snippet = SnippetController.shared.filteredSnippets[indexPath.row]
            } else {
                snippet = SnippetController.shared.snippets[indexPath.row]
            }
            
            destinationVC.snippet = snippet
            destinationVC.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 7
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let snippetToDelete = SnippetController.shared.snippets[indexPath.row]
            SnippetController.shared.deleteSnippet(snippet: snippetToDelete)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


extension SnippetsTableViewController: UpdateTableViewDelegate {
    
    func updateViewFor(snippet: Snippet, name: String, date: Date, detailText: String) {
        SnippetController.shared.updateSnippet(snippet: snippet, name: name, date: date, detailText: detailText)
        tableView.reloadData()
    }
}


extension SnippetsTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearch(searchBar.text!)
    }
}
