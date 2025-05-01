//
//  HomeViewController.swift
//  FocusBubble
//
//  Created by Yujing Wei on 4/23/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let timerCircleView = UIView()
    private let timerLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let startButton = UIButton(type: .system)
    private let pauseButton = UIButton(type: .system)
    private let endButton = UIButton(type: .system)
    private let joinRoomLabel = UILabel()
    private let roomsScrollView = UIScrollView()
    private let roomsStackView = UIStackView()
    
    private let sessionManager = SessionManager.shared
    private var circleLayer: CAShapeLayer?
    private var progressLayer: CAShapeLayer?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        
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
        title = "Home"
        
        // Title Label
        titleLabel.text = "Ready to Focus?"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        // Timer Circle View
        timerCircleView.backgroundColor = .clear
        view.addSubview(timerCircleView)
        
        // Create circle shape
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 125, y: 125), radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        circleLayer = CAShapeLayer()
        circleLayer?.path = circlePath.cgPath
        circleLayer?.fillColor = UIColor.clear.cgColor
        circleLayer?.strokeColor = UIColor.systemPurple.withAlphaComponent(0.3).cgColor
        circleLayer?.lineWidth = 15
        
        progressLayer = CAShapeLayer()
        progressLayer?.path = circlePath.cgPath
        progressLayer?.fillColor = UIColor.clear.cgColor
        progressLayer?.strokeColor = UIColor.systemPurple.cgColor
        progressLayer?.lineWidth = 15
        progressLayer?.strokeEnd = 1.0
        progressLayer?.lineCap = .round
        
        if let circleLayer = circleLayer, let progressLayer = progressLayer {
            timerCircleView.layer.addSublayer(circleLayer)
            timerCircleView.layer.addSublayer(progressLayer)
        }
        
        // Timer Label
        timerLabel.text = "25:00"
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 48, weight: .bold)
        timerLabel.textAlignment = .center
        timerCircleView.addSubview(timerLabel)
        
        // Subtitle Label
        subtitleLabel.text = "Focus Time"
        subtitleLabel.font = UIFont.systemFont(ofSize: 18)
        subtitleLabel.textAlignment = .center
        timerCircleView.addSubview(subtitleLabel)
        
        // Buttons
        startButton.setTitle("START SESSION", for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        startButton.backgroundColor = .systemPurple
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 12
        view.addSubview(startButton)
        
        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        pauseButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        pauseButton.tintColor = .systemPurple
        pauseButton.isHidden = true
        view.addSubview(pauseButton)
        
        endButton.setTitle("End", for: .normal)
        endButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        endButton.setImage(UIImage(systemName: "stop.circle.fill"), for: .normal)
        endButton.tintColor = .systemRed
        endButton.isHidden = true
        view.addSubview(endButton)
        
        // Join Room Section
        joinRoomLabel.text = "Join Focus Room"
        joinRoomLabel.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(joinRoomLabel)
        
        roomsScrollView.showsHorizontalScrollIndicator = false
        view.addSubview(roomsScrollView)
        
        roomsStackView.axis = .horizontal
        roomsStackView.spacing = 15
        roomsStackView.distribution = .fillEqually
        roomsScrollView.addSubview(roomsStackView)
        
        // Add rooms to stack view
        setupRooms()
    }
    
    private func setupConstraints() {
        // Making all views translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        timerCircleView.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        endButton.translatesAutoresizingMaskIntoConstraints = false
        joinRoomLabel.translatesAutoresizingMaskIntoConstraints = false
        roomsScrollView.translatesAutoresizingMaskIntoConstraints = false
        roomsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Timer Circle View
            timerCircleView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            timerCircleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerCircleView.widthAnchor.constraint(equalToConstant: 250),
            timerCircleView.heightAnchor.constraint(equalToConstant: 250),
            
            // Timer Label
            timerLabel.centerXAnchor.constraint(equalTo: timerCircleView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerCircleView.centerYAnchor, constant: -15),
            
            // Subtitle Label
            subtitleLabel.centerXAnchor.constraint(equalTo: timerCircleView.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 5),
            
            // Start Button
            startButton.topAnchor.constraint(equalTo: timerCircleView.bottomAnchor, constant: 30),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 250),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Pause Button
            pauseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            pauseButton.topAnchor.constraint(equalTo: timerCircleView.bottomAnchor, constant: 30),
            pauseButton.widthAnchor.constraint(equalToConstant: 100),
            pauseButton.heightAnchor.constraint(equalToConstant: 50),
            
            // End Button
            endButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            endButton.topAnchor.constraint(equalTo: timerCircleView.bottomAnchor, constant: 30),
            endButton.widthAnchor.constraint(equalToConstant: 100),
            endButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Join Room Label
            joinRoomLabel.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 30),
            joinRoomLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // Rooms Scroll View
            roomsScrollView.topAnchor.constraint(equalTo: joinRoomLabel.bottomAnchor, constant: 10),
            roomsScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            roomsScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            roomsScrollView.heightAnchor.constraint(equalToConstant: 120),
            
            // Rooms Stack View
            roomsStackView.topAnchor.constraint(equalTo: roomsScrollView.topAnchor),
            roomsStackView.leadingAnchor.constraint(equalTo: roomsScrollView.leadingAnchor),
            roomsStackView.trailingAnchor.constraint(equalTo: roomsScrollView.trailingAnchor),
            roomsStackView.bottomAnchor.constraint(equalTo: roomsScrollView.bottomAnchor),
            roomsStackView.heightAnchor.constraint(equalTo: roomsScrollView.heightAnchor)
        ])
    }
    
    private func setupActions() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        endButton.addTarget(self, action: #selector(endButtonTapped), for: .touchUpInside)
    }
    
    private func setupRooms() {
        // Clear any existing room views
        for subview in roomsStackView.arrangedSubviews {
            roomsStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        // Add room cards
        for room in sessionManager.activeRooms {
            let roomCard = createRoomCard(room: room)
            roomsStackView.addArrangedSubview(roomCard)
        }
    }
    
    private func createRoomCard(room: FocusRoom) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = UIColor.systemGray6
        cardView.layer.cornerRadius = 10
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = room.name
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)
        
        let participantsLabel = UILabel()
        participantsLabel.text = "\(room.participants) participants"
        participantsLabel.font = UIFont.systemFont(ofSize: 12)
        participantsLabel.textColor = .secondaryLabel
        participantsLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(participantsLabel)
        
        let statusLabel = UILabel()
        statusLabel.text = room.isActive ? "Active" : "Inactive"
        statusLabel.font = UIFont.systemFont(ofSize: 12)
        statusLabel.textColor = room.isActive ? .systemGreen : .systemRed
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            cardView.widthAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            participantsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            participantsLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            participantsLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            statusLabel.topAnchor.constraint(equalTo: participantsLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            statusLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
        ])
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(roomCardTapped(_:)))
        cardView.addGestureRecognizer(tapGesture)
        cardView.isUserInteractionEnabled = true
        cardView.tag = sessionManager.activeRooms.firstIndex(where: { $0.id == room.id }) ?? 0
        
        return cardView
    }
    
    // MARK: - Actions
    @objc private func startButtonTapped() {
        sessionManager.startSession()
        updateUI()
    }
    
    @objc private func pauseButtonTapped() {
        if sessionManager.isSessionActive {
            sessionManager.pauseSession()
            pauseButton.setTitle("Resume", for: .normal)
            pauseButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        } else {
            sessionManager.resumeSession()
            pauseButton.setTitle("Pause", for: .normal)
            pauseButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        }
    }
    
    @objc private func endButtonTapped() {
        sessionManager.endSession()
    }
    
    @objc private func roomCardTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag, index < sessionManager.activeRooms.count else { return }
        let room = sessionManager.activeRooms[index]
        sessionManager.joinRoom(room: room)
        
        // Show alert for demo purposes
        let alert = UIAlertController(title: "Join Room", message: "You've joined \(room.name)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Update UI
    @objc private func updateTimerDisplay() {
        timerLabel.text = sessionManager.timeString(time: sessionManager.timeRemaining)
        
        // Update progress layer
        let progress = CGFloat(sessionManager.timeRemaining) / (25 * 60)
        progressLayer?.strokeEnd = progress
    }
    
    @objc private func sessionEnded() {
        updateUI()
    }
    
    private func updateUI() {
        if sessionManager.isSessionActive {
            titleLabel.text = "Focus Session"
            startButton.isHidden = true
            pauseButton.isHidden = false
            endButton.isHidden = false
            joinRoomLabel.isHidden = true
            roomsScrollView.isHidden = true
            
            timerLabel.text = sessionManager.timeString(time: sessionManager.timeRemaining)
            
            if let session = sessionManager.currentSession {
                subtitleLabel.text = session.isMeditation ? "Meditation Time" : "Focus Time"
            }
        } else {
            titleLabel.text = "Ready to Focus?"
            startButton.isHidden = false
            pauseButton.isHidden = true
            endButton.isHidden = true
            joinRoomLabel.isHidden = false
            roomsScrollView.isHidden = false
            
            timerLabel.text = "25:00"
            subtitleLabel.text = "Focus Time"
            progressLayer?.strokeEnd = 1.0
        }
    }
}
