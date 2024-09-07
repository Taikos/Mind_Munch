# 📄 README

## 🛠 Conditions to Test:
- SwiftUI framework
- Xcode 15.4
- iOS 17+
- Development primarily on iPhone 15 Pro Max
- 📱 Responsiveness: QA was not extensively conducted for other devices or screen sizes.

---

## ✅ Requirements:
- **Download & Analyze:**
  - Impulse's "Candy Sort" game √
  - Duolingo √
- **Vision:**
  - Build a 10x improved version of Impulse's "Candy Sort" game √

---

## 🧩 Key Features Implemented:
- 🎥 **Animations**
- 📳 **Haptic Feedback**
- 💥 **Particle Effects**
- ❤️ **Life System:** Used as an end condition for losing the game.
- 🏆 **Scoring System**
- 🏗 **Level Factory:** Allows dynamic level generation and monitoring of the difficulty curve.
- 🔄 **Game Loop:**
  - Start screen with best score and benefits √
  - Gameplay √
  - Result screen with track record of past games √

---

## 🚀 Additional Rules & Features:
- 🎯 **Bonus System:**
  - Add extra moves, undo actions, or use extra jars.
- 🛑 **Error-Free Implementation:**
  - No red warnings or build issues.

---

## 📊 Additional Features:
- **SwiftData usage**
- **Video Integration**
- **Sound Effects:** Activated when hitting the avatar √
- **3D Animated Avatar**
- **Functional In-App Purchases:** Implemented for the life system and deployed on App Store Connect.
- **Ads:** Integrated AdMob for when the player loses.
- 📈 **Progression Graph:** Tracks player's game progression.
- ⏱ **Time Spent Tracker:** Monitors time spent and could evolve into a daily quest tracker.
- 🔄 **Automatic Refill System:** 
  - Bonuses like undo, extra jars, and life refill every 5 minutes (to simplify QA).
  - Next step: Add a timer and additional IAPs to trigger users when they fail and need bonuses.

---

## 🔔 User Engagement Features:
- **Tracking Request:** Prompt user for tracking permissions.
- **Notification Request**
- ⭐ **Rating Request**
- 📝 **Complete Onboarding Process**
- 🏅 **Static Leaderboard**

---

## 🎨 Customization:
- **App Icon:** Changeable.
- **Custom Fonts:** Applied in select places.

---

## 📱 Launch Features:
- 🟩 No yellow warnings in the project.
- 🌐 **Language Support:** Added support for Spanish.
- 📈 **Progression Feeling:** User progress tracked visually and emotionally.

---

## 🔧 Future Improvements:
- 🛠 **Widget Support**
- 🛍 **Additional IAPs:** Linked to in-app consumables.
- 🆓 **Pro Subscription:** Removes ads when players lose.
- 📉 **Progression Graph Algorithm:** Refined using key data points.
- 🌐 **Live Leaderboard**
- 🛠 **MMP Installation**
- 🔔 **Push Notifications:** Recurring notifications for user engagement.
- 🧹 **Code Cleanup**
- 🆕 **More Fonts usage**

---

## 🌊 Onboarding Improvement:
- **Wave Animation:** To be improved in the onboarding process.

---

## 🧠 Level Generator Explanation:
- **Level Generation:**
  - Determine number of colors and empty jars based on difficulty.
  - Randomly assign colors and distribute them into jars.
  - Shuffle jars to randomize level layout.

- **Difficulty Calculation:**
  - Start with a base difficulty level, which is equal to the highest level reached.
  - Apply a multiplier based on:
    - ⏳ Time spent (faster times = higher difficulty)
    - 🏆 Score achieved (higher score = higher difficulty)
    - ❤️ Remaining lives (more lives = slightly increased difficulty)
  
- **Dynamic Difficulty Adjustment:**
  - The algorithm balances player performance to increase the challenge if they improve and adapt the difficulty if they struggle.
  - **Improvement:** Take into account player's purchasing habits—big spenders should experience more challenging gameplay.

---

## ⚙️ Deployment:
- 🟢 TestFlight ready.
- 🟢 Compliant with AppStore Guidelines (privacy settings, etc.).
