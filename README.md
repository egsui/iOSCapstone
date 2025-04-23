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

[This section will be completed in Unit 9]

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
