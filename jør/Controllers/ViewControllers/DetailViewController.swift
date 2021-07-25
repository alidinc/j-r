//
//  DetailViewController.swift
//  jør
//
//  Created by Ali Dinç on 24/07/2021.
//

import UIKit

protocol UpdateTableViewDelegate: AnyObject {
    func updateViewFor(snippet: Snippet, name: String, date: Date, detailText: String)
}

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var date: Date?
    var snippet: Snippet?
    
    weak var delegate: UpdateTableViewDelegate?

    // MARK: - Outlets
    
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateDetailView()
    }
    
    
    // MARK: - Actions

    @IBAction func datePickerViewTapped(_ sender: Any) {
        self.date = datePickerView.date
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
              let textView = detailTextView.text, !textView.isEmpty else { return }
        
        if let snippet = snippet {
            delegate?.updateViewFor(snippet: snippet, name: name, date: date ?? Date(), detailText: textView)
        } else {
            SnippetController.shared.createSnippet(name: name, date: date ?? Date(), detailText: textView)
        }
        navigationController?.popViewController(animated: true)
    }
    

    // MARK: - Methods
    
    func updateDetailView() {
        detailTextView.delegate = self
        nameTextField.delegate = self
        
        guard let snippet = snippet else { return }
        nameTextField.text = snippet.name
        detailTextView.text = snippet.detailText
        datePickerView.date = snippet.date
    }
}

// MARK: - UITextViewDelegate & UITextFieldDelegate

extension DetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if detailTextView.text == "Write entry here…" {
            detailTextView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        detailTextView.endEditing(true)
        detailTextView.resignFirstResponder()
    }
}


extension DetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.endEditing(true)
        return nameTextField.resignFirstResponder()
    }
}
