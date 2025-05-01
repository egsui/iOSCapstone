//
//  RoomsViewController.swift
//  FocusBubble
//
//  Created by Yujing Wei on 4/23/25.
//

import UIKit

class RoomsViewController: UIViewController {
    
    // MARK: - Properties
    private let createRoomButton = UIButton(type: .system)
    private let roomsLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let sessionManager = SessionManager.shared
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Focus Rooms"
        
        // Create Room Button
        createRoomButton.setTitle("CREATE ROOM", for: .normal)
        createRoomButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        createRoomButton.backgroundColor = .systemOrange
        createRoomButton.setTitleColor(.white, for: .normal)
        createRoomButton.layer.cornerRadius = 12
        createRoomButton.addTarget(self, action: #selector(createRoomButtonTapped), for: .touchUpInside)
        view.addSubview(createRoomButton)
        
        // Rooms Label
        roomsLabel.text = "Active Rooms"
        roomsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(roomsLabel)
        
        // Table View
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        createRoomButton.translatesAutoresizingMaskIntoConstraints = false
        roomsLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Create Room Button
            createRoomButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            createRoomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createRoomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createRoomButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Rooms Label
            roomsLabel.topAnchor.constraint(equalTo: createRoomButton.bottomAnchor, constant: 20),
            roomsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // Table View
            tableView.topAnchor.constraint(equalTo: roomsLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RoomCell.self, forCellReuseIdentifier: "RoomCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    // MARK: - Actions
    @objc private func createRoomButtonTapped() {
        let alertController = UIAlertController(title: "Create Room", message: "Enter a name for your focus room", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Room Name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let createAction = UIAlertAction(title: "Create", style: .default) { [weak self] _ in
            guard let self = self,
                  let textField = alertController.textFields?.first,
                  let roomName = textField.text, !roomName.isEmpty else { return }
            
            self.sessionManager.createRoom(name: roomName)
            self.tableView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(createAction)
        
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDelegate & DataSource
extension RoomsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessionManager.activeRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as? RoomCell else {
            return UITableViewCell()
        }
        
        let room = sessionManager.activeRooms[indexPath.row]
        cell.configure(with: room)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - RoomCellDelegate
extension RoomsViewController: RoomCellDelegate {
    func didTapJoinButton(for room: FocusRoom) {
        sessionManager.joinRoom(room: room)
        
        // Show alert for demo purposes
        let alert = UIAlertController(title: "Join Room", message: "You've joined \(room.name)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Room Cell
protocol RoomCellDelegate: AnyObject {
    func didTapJoinButton(for room: FocusRoom)
}

class RoomCell: UITableViewCell {
    
    private let containerView = UIView()
    private let nameLabel = UILabel()
    private let participantsLabel = UILabel()
    private let statusLabel = UILabel()
    private let joinButton = UIButton(type: .system)
    
    private var room: FocusRoom?
    weak var delegate: RoomCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
        
        containerView.backgroundColor = UIColor.systemGray6
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 4
        contentView.addSubview(containerView)
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        containerView.addSubview(nameLabel)
        
        participantsLabel.font = UIFont.systemFont(ofSize: 14)
        participantsLabel.textColor = .secondaryLabel
        containerView.addSubview(participantsLabel)
        
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        containerView.addSubview(statusLabel)
        
        joinButton.setTitle("Join", for: .normal)
        joinButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        joinButton.backgroundColor = .systemOrange
        joinButton.setTitleColor(.white, for: .normal)
        joinButton.layer.cornerRadius = 8
        joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
        containerView.addSubview(joinButton)
        
        // Setup constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        participantsLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: joinButton.leadingAnchor, constant: -16),
            
            participantsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            participantsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            statusLabel.topAnchor.constraint(equalTo: participantsLabel.bottomAnchor, constant: 4),
            statusLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            statusLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12),
            
            joinButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            joinButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            joinButton.widthAnchor.constraint(equalToConstant: 80),
            joinButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    func configure(with room: FocusRoom) {
        self.room = room
        
        nameLabel.text = room.name
        participantsLabel.text = "\(room.participants) participants"
        
        statusLabel.text = room.isActive ? "Active" : "Inactive"
        statusLabel.textColor = room.isActive ? .systemGreen : .systemRed
    }
    
    @objc private func joinButtonTapped() {
        guard let room = room else { return }
        delegate?.didTapJoinButton(for: room)
    }
}
