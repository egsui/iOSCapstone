//
//  JournalViewController.swift
//  FocusBubble
//
//  Created by Yujing Wei on 4/23/25.
//

import UIKit

class JournalViewController: UIViewController {
    
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let moodTitleLabel = UILabel()
    private let moodStackView = UIStackView()
    private let journalTitleLabel = UILabel()
    private let journalTextView = UITextView()
    private let progressTitleLabel = UILabel()
    private let progressStackView = UIStackView()
    private let saveButton = UIButton(type: .system)
    
    private let sessionManager = SessionManager.shared
    private var selectedMood: Mood = .neutral
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupMoodButtons()
        setupProgressView()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Journal"
        
        // Scroll View
        scrollView.showsVerticalScrollIndicator = true
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Mood Section
        moodTitleLabel.text = "How are you feeling?"
        moodTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        contentView.addSubview(moodTitleLabel)
        
        moodStackView.axis = .horizontal
        moodStackView.distribution = .fillEqually
        moodStackView.spacing = 10
        moodStackView.alignment = .center
        contentView.addSubview(moodStackView)
        
        // Journal Section
        journalTitleLabel.text = "Today's Reflection"
        journalTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        contentView.addSubview(journalTitleLabel)
        
        journalTextView.font = UIFont.systemFont(ofSize: 16)
        journalTextView.layer.borderColor = UIColor.systemGray4.cgColor
        journalTextView.layer.borderWidth = 1
        journalTextView.layer.cornerRadius = 8
        journalTextView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        journalTextView.text = "Write about your focus session, challenges, and achievements..."
        journalTextView.textColor = .placeholderText
        journalTextView.delegate = self
        contentView.addSubview(journalTextView)
        
        // Progress Section
        progressTitleLabel.text = "Today's Progress"
        progressTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        contentView.addSubview(progressTitleLabel)
        
        progressStackView.axis = .vertical
        progressStackView.spacing = 8
        progressStackView.backgroundColor = UIColor.systemGray6
        progressStackView.layer.cornerRadius = 8
        progressStackView.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        progressStackView.isLayoutMarginsRelativeArrangement = true
        contentView.addSubview(progressStackView)
        
        // Save Button
        saveButton.setTitle("SAVE JOURNAL", for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        saveButton.backgroundColor = .systemPurple
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 12
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        contentView.addSubview(saveButton)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        moodTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        moodStackView.translatesAutoresizingMaskIntoConstraints = false
        journalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        journalTextView.translatesAutoresizingMaskIntoConstraints = false
        progressTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        progressStackView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Mood Title Label
            moodTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            moodTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            moodTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Mood Stack View
            moodStackView.topAnchor.constraint(equalTo: moodTitleLabel.bottomAnchor, constant: 10),
            moodStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            moodStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Journal Title Label
            journalTitleLabel.topAnchor.constraint(equalTo: moodStackView.bottomAnchor, constant: 20),
            journalTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            journalTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Journal Text View
            journalTextView.topAnchor.constraint(equalTo: journalTitleLabel.bottomAnchor, constant: 10),
            journalTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            journalTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            journalTextView.heightAnchor.constraint(equalToConstant: 200),
            
            // Progress Title Label
            progressTitleLabel.topAnchor.constraint(equalTo: journalTextView.bottomAnchor, constant: 20),
            progressTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            progressTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Progress Stack View
            progressStackView.topAnchor.constraint(equalTo: progressTitleLabel.bottomAnchor, constant: 10),
            progressStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            progressStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Save Button
            saveButton.topAnchor.constraint(equalTo: progressStackView.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupMoodButtons() {
        // Clear existing mood buttons
        for subview in moodStackView.arrangedSubviews {
            moodStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        // Add mood buttons
        for mood in Mood.allCases {
            let button = createMoodButton(mood: mood)
            moodStackView.addArrangedSubview(button)
        }
    }
    
    private func createMoodButton(mood: Mood) -> UIButton {
        let button = UIButton(type: .system)
        
        // Add emoji and text
        let attributedString = NSMutableAttributedString(string: "\(mood.icon)\n", attributes: [
            .font: UIFont.systemFont(ofSize: 30)
        ])
        
        attributedString.append(NSAttributedString(string: mood.rawValue, attributes: [
            .font: UIFont.systemFont(ofSize: 12)
        ]))
        
        button.setAttributedTitle(attributedString, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        
        // Add tag for identification
        button.tag = Mood.allCases.firstIndex(of: mood) ?? 0
        
        // Add action
        button.addTarget(self, action: #selector(moodButtonTapped(_:)), for: .touchUpInside)
        
        // Highlight if selected
        if mood == selectedMood {
            button.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.2)
        } else {
            button.backgroundColor = .clear
        }
        
        button.layer.cornerRadius = 8
        button.frame.size = CGSize(width: 60, height: 60)
        
        return button
    }
    
    private func setupProgressView() {
        // Clear existing progress items
        for subview in progressStackView.arrangedSubviews {
            progressStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        // Add progress items
        let focusTimeRow = createProgressRow(title: "Focus Time:", value: "\(sessionManager.totalFocusTime) minutes")
        let meditationRow = createProgressRow(title: "Meditation:", value: "\(sessionManager.totalMeditationTime) minutes")
        let sessionsRow = createProgressRow(title: "Sessions:", value: "\(sessionManager.sessionsCompleted)")
        
        progressStackView.addArrangedSubview(focusTimeRow)
        progressStackView.addArrangedSubview(meditationRow)
        progressStackView.addArrangedSubview(sessionsRow)
    }
    
    private func createProgressRow(title: String, value: String) -> UIView {
        let rowView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .secondaryLabel
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.boldSystemFont(ofSize: 16)
        valueLabel.textAlignment = .right
        
        rowView.addSubview(titleLabel)
        rowView.addSubview(valueLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: rowView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: rowView.bottomAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: rowView.topAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: rowView.trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: rowView.bottomAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 10)
        ])
        
        return rowView
    }
    
    // MARK: - Actions
    @objc private func moodButtonTapped(_ sender: UIButton) {
        guard let index = Mood.allCases.indices.contains(sender.tag) ? sender.tag : nil else { return }
        selectedMood = Mood.allCases[index]
        setupMoodButtons() // Refresh to update selection
    }
    
    @objc private func saveButtonTapped() {
        // Ensure there's actual text (not just the placeholder)
        guard journalTextView.textColor != .placeholderText && !journalTextView.text.isEmpty else {
            // Show alert that text is required
            let alert = UIAlertController(title: "Text Required", message: "Please write your reflection before saving.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        // Save journal entry
        sessionManager.addJournalEntry(mood: selectedMood, reflection: journalTextView.text)
        
        // Show success message
        let alert = UIAlertController(title: "Journal Saved", message: "Your reflection has been saved successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Reset the form
            self?.journalTextView.text = "Write about your focus session, challenges, and achievements..."
            self?.journalTextView.textColor = .placeholderText
            self?.selectedMood = .neutral
            self?.setupMoodButtons()
        })
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension JournalViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write about your focus session, challenges, and achievements..."
            textView.textColor = .placeholderText
        }
    }
}
