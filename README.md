Original App Design Project - README
===

# FocusBubble

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

**FocusBubble** is an app designed to help users stay productive with Pomodoro-based work sessions while incorporating mindfulness techniques. It combines focus sprints with meditation breaks and reflection journaling to enhance both productivity and mental well-being. With social accountability features, users can stay motivated and track their emotional progress throughout the day.


### App Evaluation

- **Category:** Productivity / Wellness  
- **Mobile:**  
  - Start Pomodoro focus sessions and mindfulness breaks  
  - Join live focus rooms or solo sessions  
  - Mobile-first, with optional desktop sync for deep work  
- **Story:**  
  FocusBubble is the perfect balance between deep work and mental relaxation. Users focus for set intervals, then recharge with guided meditation and reflection prompts, creating a holistic productivity experience.  
- **Market:**  
  Students, remote workers, freelancers, and creators who want to stay productive while balancing mindfulness and well-being.  
  - **Monetization:**  
    - Premium team/friend rooms  
    - Unlockable meditation packs (e.g., "Focus Flow", "Unwind", "Confidence")  
    - Daily/weekly reflection journaling insights  
- **Habit:**  
  Encourages daily deep work sessions, regular breaks for mental clarity, and reflective journaling. Users can track their mood and productivity cycles.  
- **Scope:**  
  - **V1:** Basic Pomodoro timer, focus rooms, meditation breaks  
  - **V2:** Personal mood and reflection journal  
  - **V3:** Friends & team accountability rooms  
  - **V4:** AI coach for mood insights, task suggestions, calendar sync  


## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- As a user, I want to start a Pomodoro session so I can focus on my tasks in structured intervals.  
- As a user, I want a meditation break after each focus session so I can recharge and maintain my productivity.  
- As a user, I want to track my mood and reflection after each session so I can see my progress over time.  
- As a user, I want to join focus rooms with friends or colleagues for social accountability.  
- As a user, I want to receive insights about my emotional state and productivity patterns.  

**Optional Nice-to-have Stories**

- As a user, I want to sync my calendar with the app to automatically schedule my focus sessions.  
- As a user, I want AI recommendations for tasks based on my mood and productivity trends.  
- As a user, I want to purchase premium meditation packs for different types of focus.  


### 2. Screen Archetypes

- [ ] **Home Screen**  
  * Displays the Pomodoro timer, start button for focus sessions, and options for joining focus rooms.  
- [ ] **Meditation Screen**  
  * Provides guided meditation options with a timer and soothing background music.  
- [ ] **Journal Screen**  
  * Allows users to track their mood and reflect on their focus session with journaling prompts.  
- [ ] **Friends/Team Room Screen**  
  * Displays focus rooms and shows the number of active participants. Users can join or create rooms.  


### 3. Navigation

**Tab Navigation** (Tab to Screen)

- **Home:** Home screen with the Pomodoro timer and focus session options.  
- **Meditation:** Access guided meditations for breaks after work sessions.  
- **Journal:** Allows users to reflect and track their emotional and productivity patterns.  
- **Rooms:** View or join focus rooms with friends or teams for social accountability.  

**Flow Navigation** (Screen to Screen)

- [ ] **Home Screen**  
  * Tap "Start Session" to begin a Pomodoro focus session.  
  * Tap "Meditation" to start a meditation session after focus time.  
- [ ] **Meditation Screen**  
  * Tap "End Session" to return to the Home screen after meditation.  
- [ ] **Journal Screen**  
  * Tap "Save Journal" to return to the Home screen after reflecting on your session.  
- [ ] **Friends/Team Room Screen**  
  * Tap "Join Room" to enter a focus room with friends.  
  * Tap "Create Room" to form a new room and invite others to join.


## Wireframes

[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 

### Models


| Model Name       | Attributes                                      | Description                                      |
|------------------|-------------------------------------------------|--------------------------------------------------|
| **User**         | `username`, `email`, `password`, `mood_history` | Stores user data including login and reflection history. |
| **FocusSession** | `start_time`, `end_time`, `duration`, `mood`    | Stores data about each focus session, including duration and mood at the end. |
| **Room**         | `room_name`, `participants`, `is_active`        | Stores information about a focus room, including participants and whether the room is currently active. |
| **Meditation**   | `type`, `duration`, `audio_file`                | Stores meditation session details such as type and audio file. |

### Networking

- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]


# Sprint Planning for FocusBubble

## Sprint 1: **Set up the project and integrate basic networking**
**Duration**: 1 week  
**Goals**:  
- Set up the project repository on GitHub, establish basic app structure, and integrate version control.
- Set up a basic **Pomodoro timer** feature (without a UI) for testing networking.
- Implement **read-only networking** to fetch data (e.g., meditation types, Pomodoro session details) from a mock API or a placeholder backend.

**Tasks**:
- Initialize project structure (folders, files, libraries).
- Set up API client for reading meditation and Pomodoro session data.
- Test basic networking flow with mock data.

---

## Sprint 2: **Design and implement the Home Screen**
**Duration**: 1 week  
**Goals**:  
- Design and implement the **Home Screen** to display the Pomodoro timer and options to start focus sessions.
- Allow the user to initiate a Pomodoro session.
- Implement UI for showing the timer countdown and session controls.

**Tasks**:
- Create Home Screen UI (Pomodoro timer, Start/Stop buttons).
- Implement Pomodoro session start/stop functionality.
- Connect the Pomodoro timer with backend to manage session state (e.g., start and end time).

---

## Sprint 3: **Build the Meditation Screen and implement breaks**
**Duration**: 1 week  
**Goals**:  
- Design and implement the **Meditation Screen** where users can take a break after each Pomodoro session.
- Integrate a **meditation feature** with different session types (e.g., Focus Flow, Unwind).
- Add a timer for meditation breaks and soothing background music.

**Tasks**:
- Create UI for meditation screen (options for meditation type and timer).
- Integrate with backend to fetch meditation audio files and types.
- Implement logic to transition from Pomodoro timer to meditation break.

---

## Sprint 4: **Build the User Profile Screen and Mood Tracking**
**Duration**: 1 week  
**Goals**:  
- Design and implement the **User Profile Screen**.
- Allow users to track their mood and add journal entries after each Pomodoro session.
- Store mood data and reflections in local storage (or a backend database).

**Tasks**:
- Create profile UI with user details and mood tracking.
- Implement functionality for users to enter and save mood reflections.
- Set up local data persistence (e.g., saving user mood history in a local database).

---

## Sprint 5: **Implement Focus Rooms for Social Accountability**
**Duration**: 1 week  
**Goals**:  
- Design and implement **Friends/Team Room** functionality.
- Users should be able to join or create focus rooms with friends or colleagues for social accountability.
- Display the number of active participants in each room.

**Tasks**:
- Create UI for room creation and joining.
- Implement functionality to create and manage focus rooms.
- Display participants and allow users to join rooms.

---

## Sprint 6: **Implement Journaling and Insights**
**Duration**: 1 week  
**Goals**:  
- Add the **Journal Screen** to track user reflections after each Pomodoro session.
- Implement a system to provide insights about emotional states and productivity patterns.
- Store journal entries and insights data for future reference.

**Tasks**:
- Create journal screen UI with mood reflection prompts.
- Implement mood and productivity insights functionality.
- Integrate with backend to store journal entries and insights.

---

## Sprint 7: **Premium Features and Advanced User Tracking**
**Duration**: 1 week  
**Goals**:  
- Implement premium features such as unlocking additional meditation packs (e.g., "Focus Flow," "Unwind").
- Implement tracking of user productivity trends and insights across sessions.
- Add the ability to view analytics on how productivity improves over time.

**Tasks**:
- Implement feature unlocking for premium meditation packs.
- Add analytics tracking for user productivity (e.g., number of sessions completed, productivity improvements).
- Set up UI for viewing advanced insights and premium features.

---

## Sprint 8: **Testing and Bug Fixing**
**Duration**: 1 week  
**Goals**:  
- Thorough testing of all app features, including UI, networking, data persistence, and user accounts.
- Address bugs and issues found during testing.
- Polish app for the final release.

**Tasks**:
- Conduct unit and integration tests for the core features (Pomodoro timer, meditation, journaling).
- Perform user acceptance testing (UAT).
- Fix bugs and issues based on testing feedback.

