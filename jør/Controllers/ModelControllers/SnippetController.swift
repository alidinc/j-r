//
//  SnippetController.swift
//  jør
//
//  Created by Ali Dinç on 23/07/2021.
//

import Foundation


class SnippetController {
    
    static let shared = SnippetController()
    
    var snippets = [Snippet]()
    var filteredSnippets = [Snippet]()
    
    // MARK: - CRUD Functions
    
    func createSnippet(name: String, date: Date, detailText: String) {
        let newSnippet = Snippet(name: name, date: date, detailText: detailText)
        snippets.append(newSnippet)
        saveToPersistenceStore()
    }
    
    func updateSnippet(snippet: Snippet, name: String, date: Date, detailText: String) {
        snippet.name = name
        snippet.date = date
        snippet.detailText = detailText
        saveToPersistenceStore()
    }
    
    func deleteSnippet(snippet: Snippet) {
        guard let index = snippets.firstIndex(of: snippet) else { return }
        snippets.remove(at: index)
        saveToPersistenceStore()
    }
    
    
    // MARK: - Persistence


    
    func createPersistenceStore() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = url[0].appendingPathComponent("Snippets.json")
        return fileUrl
    }
    
    func saveToPersistenceStore() {
        do {
            let data = try JSONEncoder().encode(snippets)
            try data.write(to: createPersistenceStore())
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
    
    func loadFromPersistenceStore() {
        do {
            let data = try Data(contentsOf: createPersistenceStore())
            snippets = try JSONDecoder().decode([Snippet].self, from: data)
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
}
