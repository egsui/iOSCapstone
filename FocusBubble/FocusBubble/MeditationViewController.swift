//
//  MeditationViewController.swift
//  FocusBubble
//
//  Created by Yujing Wei on 4/23/25.
//

import UIKit

class MeditationViewController: UIViewController {
    
    // MARK: - Properties
    private let titleLabel = UILabel()
    private let meditationImageView = UIImageView()
    private let timerView = UIView()
    private let timerLabel = UILabel()
    private let meditationCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    private let startButton = UIButton(type: .system)
    
    private let sessionManager = SessionManager.shared
    private var selectedMeditation = 0
    
    private let meditations = [
        ("Focus Breath", "5 min", "Breathing exercise to improve focus"),
        ("Calm Mind", "10 min", "Relax and clear your mind"),
        ("Quick Reset", "3 min", "Quick reset between tasks")
    ]
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupCollectionView()
        
        // Register for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimerDisplay), name: .timerDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sessionEnded), name: .sessionDidEnd, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Meditate"
        
        // Title Label
        titleLabel.text = "Choose Your Meditation"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        // Meditation Image View
        meditationImageView.contentMode = .scaleAspectFit
        meditationImageView.tintColor = .systemTeal
        meditationImageView.image = UIImage(systemName: "sparkles")
        meditationImageView.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.1)
        meditationImageView.layer.cornerRadius = 60
        meditationImageView.clipsToBounds = true
        view.addSubview(meditationImageView)
        
        // Timer View
        timerView.backgroundColor = .clear
        timerView.isHidden = true
        view.addSubview(timerView)
        
        // Timer Label
        timerLabel.text = "05:00"
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 48, weight: .bold)
        timerLabel.textAlignment = .center
        timerView.addSubview(timerLabel)
        
        // Collection View
        view.addSubview(meditationCollectionView)
        
        // Start Button
        startButton.setTitle("START MEDITATION", for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        startButton.backgroundColor = .systemTeal
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 12
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        view.addSubview(startButton)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        meditationImageView.translatesAutoresizingMaskIntoConstraints = false
        timerView.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        meditationCollectionView.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Meditation Image View
            meditationImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            meditationImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            meditationImageView.widthAnchor.constraint(equalToConstant: 120),
            meditationImageView.heightAnchor.constraint(equalToConstant: 120),
            
            // Timer View
            timerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            timerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerView.widthAnchor.constraint(equalToConstant: 250),
            timerView.heightAnchor.constraint(equalToConstant: 250),
            
            // Timer Label
            timerLabel.centerXAnchor.constraint(equalTo: timerView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerView.centerYAnchor),
            
            // Collection View
            meditationCollectionView.topAnchor.constraint(equalTo: meditationImageView.bottomAnchor, constant: 20),
            meditationCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            meditationCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            meditationCollectionView.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -20),
            
            // Start Button
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 250),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupCollectionView() {
        meditationCollectionView.delegate = self
        meditationCollectionView.dataSource = self
        meditationCollectionView.register(MeditationCell.self, forCellWithReuseIdentifier: "MeditationCell")
        meditationCollectionView.backgroundColor = .clear
    }
    
    // MARK: - Actions
    @objc private func startButtonTapped() {
        if sessionManager.isSessionActive {
            sessionManager.endSession()
        } else {
            let duration = Int(meditations[selectedMeditation].1.split(separator: " ")[0]) ?? 5
            sessionManager.startMeditation(duration: duration)
            updateUI()
        }
    }
    
    @objc private func updateTimerDisplay() {
        timerLabel.text = sessionManager.timeString(time: sessionManager.timeRemaining)
    }
    
    @objc private func sessionEnded() {
        updateUI()
    }
    
    private func updateUI() {
        if sessionManager.isSessionActive, let session = sessionManager.currentSession, session.isMeditation {
            titleLabel.text = "Breathe..."
            meditationImageView.isHidden = true
            meditationCollectionView.isHidden = true
            timerView.isHidden = false
            startButton.setTitle("END MEDITATION", for: .normal)
            startButton.backgroundColor = .systemRed
            
            timerLabel.text = sessionManager.timeString(time: sessionManager.timeRemaining)
            
            // Add breathing animation
            addBreathingAnimation()
        } else {
            titleLabel.text = "Choose Your Meditation"
            meditationImageView.isHidden = false
            meditationCollectionView.isHidden = false
            timerView.isHidden = true
            startButton.setTitle("START MEDITATION", for: .normal)
            startButton.backgroundColor = .systemTeal
            
            // Remove any existing breathing animations
            meditationImageView.layer.removeAllAnimations()
        }
    }
    
    private func addBreathingAnimation() {
        let breatheIn = CABasicAnimation(keyPath: "transform.scale")
        breatheIn.fromValue = 0.8
        breatheIn.toValue = 1.2
        breatheIn.duration = 4.0
        breatheIn.repeatCount = Float.infinity
        breatheIn.autoreverses = true
        breatheIn.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        meditationImageView.layer.add(breatheIn, forKey: "breathingAnimation")
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension MeditationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meditations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeditationCell", for: indexPath) as? MeditationCell else {
            return UICollectionViewCell()
        }
        
        let meditation = meditations[indexPath.item]
        cell.configure(title: meditation.0, duration: meditation.1, description: meditation.2)
        cell.isSelected = selectedMeditation == indexPath.item
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMeditation = indexPath.item
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 20) / 2
        return CGSize(width: width, height: 120)
    }
}

// MARK: - Meditation Cell
class MeditationCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let durationLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor.systemTeal.withAlphaComponent(0.2) : UIColor.systemGray6
            contentView.layer.borderWidth = isSelected ? 2 : 0
            contentView.layer.borderColor = isSelected ? UIColor.systemTeal.cgColor : nil
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.backgroundColor = UIColor.systemGray6
        contentView.layer.cornerRadius = 10
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        durationLabel.font = UIFont.systemFont(ofSize: 14)
        durationLabel.textColor = .secondaryLabel
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(durationLabel)
        contentView.addSubview(descriptionLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            durationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            durationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            descriptionLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(title: String, duration: String, description: String) {
        titleLabel.text = title
        durationLabel.text = duration
        descriptionLabel.text = description
    }
}
