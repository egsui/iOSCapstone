//
//  Models.swift
//  FocusBubble
//
//  Created by Yujing Wei on 4/23/25.
//

import Foundation
import UIKit

// MARK: - Session Manager
class SessionManager {
    static let shared = SessionManager() // Singleton pattern
    
    var currentSession: Session?
    var isSessionActive = false
    var timeRemaining = 25 * 60 // Default focus time: 25 minutes
    var sessionsCompleted = 0
    var totalFocusTime = 0
    var totalMeditationTime = 0
    var journals: [JournalEntry] = []
    var activeRooms: [FocusRoom] = [
        FocusRoom(id: "1", name: "Team Alpha", participants: 4, isActive: true),
        FocusRoom(id: "2", name: "Design Team", participants: 2, isActive: true),
        FocusRoom(id: "3", name: "Study Group", participants: 3, isActive: true)
    ]
    
    private var timer: Timer?
    
    private init() {} // Private initializer for singleton
    
    func startSession() {
        currentSession = Session(startTime: Date())
        isSessionActive = true
        timeRemaining = 25 * 60
        startTimer()
    }
    
    func pauseSession() {
        timer?.invalidate()
        isSessionActive = false
    }
    
    func resumeSession() {
        isSessionActive = true
        startTimer()
    }
    
    func endSession() {
        timer?.invalidate()
        
        if let session = currentSession {
            session.endTime = Date()
            totalFocusTime += Int(session.duration / 60)
            sessionsCompleted += 1
        }
        
        isSessionActive = false
        currentSession = nil
        
        // Notify observers that session ended
        NotificationCenter.default.post(name: .sessionDidEnd, object: nil)
    }
    
    func startMeditation(duration: Int = 5) {
        currentSession = Session(startTime: Date(), isMeditation: true)
        isSessionActive = true
        timeRemaining = duration * 60
        startTimer()
    }
    
    func addJournalEntry(mood: Mood, reflection: String) {
        let entry = JournalEntry(date: Date(), mood: mood, reflection: reflection)
        journals.append(entry)
    }
    
    func joinRoom(room: FocusRoom) {
        // Logic to join a focus room would go here
    }
    
    func createRoom(name: String) -> FocusRoom {
        let newRoom = FocusRoom(id: UUID().uuidString, name: name, participants: 1, isActive: true)
        activeRooms.append(newRoom)
        return newRoom
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, self.timeRemaining > 0 else {
                self?.timer?.invalidate()
                self?.endSession()
                return
            }
            
            self.timeRemaining -= 1
            
            // Notify observers that timer updated
            NotificationCenter.default.post(name: .timerDidUpdate, object: nil)
            
            // Check if session is complete
            if self.timeRemaining == 0 {
                self.timer?.invalidate()
                
                // If this was a focus session, suggest meditation
                if let session = self.currentSession, !session.isMeditation {
                    self.endSession()
                } else {
                    self.endSession()
                }
            }
        }
    }
    
    func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Session Model
class Session {
    let id = UUID()
    let startTime: Date
    var endTime: Date?
    let isMeditation: Bool
    
    init(startTime: Date, endTime: Date? = nil, isMeditation: Bool = false) {
        self.startTime = startTime
        self.endTime = endTime
        self.isMeditation = isMeditation
    }
    
    var duration: TimeInterval {
        guard let endTime = endTime else { return 0 }
        return endTime.timeIntervalSince(startTime)
    }
}

// MARK: - Journal Entry Model
struct JournalEntry {
    let id = UUID()
    let date: Date
    let mood: Mood
    let reflection: String
}

// MARK: - Mood Enum
enum Mood: String, CaseIterable {
    case terrible = "Terrible"
    case bad = "Bad"
    case neutral = "Neutral"
    case good = "Good"
    case excellent = "Excellent"
    
    var icon: String {
        switch self {
        case .terrible: return "😫"
        case .bad: return "😕"
        case .neutral: return "😐"
        case .good: return "🙂"
        case .excellent: return "😄"
        }
    }
}

// MARK: - Focus Room Model
struct FocusRoom {
    let id: String
    let name: String
    var participants: Int
    var isActive: Bool
}

// MARK: - Custom Notifications
extension Notification.Name {
    static let timerDidUpdate = Notification.Name("timerDidUpdate")
    static let sessionDidEnd = Notification.Name("sessionDidEnd")
}
