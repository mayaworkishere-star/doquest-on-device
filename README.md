# DoQuest — On-device habit game for iPhone

DoQuest turns real-life actions into game progress. The first quest is a **bicep-curl challenge**: the iPhone camera detects a body pose locally, counts completed repetitions, and rewards XP, a daily streak, and badges.

> **Privacy principle:** camera frames are processed on-device and are never stored or uploaded.

## Why this is a strong ML portfolio project

It combines a clear behaviour-change problem with an Apple-native ML implementation:

- **Vision body-pose detection** turns live camera frames into shoulder, elbow, and wrist landmarks.
- A transparent **joint-angle algorithm** converts those landmarks into a verified repetition count.
- A gamified layer awards XP and streaks only after a completed quest.
- The design is deliberately honest about uncertainty: low-confidence poses or incomplete movement do not earn XP.

## MVP

**User story:** “As a student with a busy schedule, I want a small workout game that verifies my reps privately, so I can sustain an exercise habit without manually logging it.”

| Feature | Definition of done |
| --- | --- |
| One exercise | Detect a bicep curl using shoulder–elbow–wrist angle. |
| Verification | A rep counts only after a contracted pose followed by a full extension. |
| Game loop | 10 verified reps complete a quest and unlock 100 XP. |
| Streak | Complete one quest per calendar day to extend the streak. |
| Privacy | No accounts, servers, image saving, or analytics in the MVP. |

## Architecture

```text
Camera frame → Vision body pose → joint landmarks → elbow angle
                                                    ↓
                                      RepCounter state machine
                                                    ↓
                                      Quest progress + XP + streak
```

The package in this repository contains the testable core game logic. The next step is an iOS SwiftUI target that supplies landmarks from `VNDetectHumanBodyPoseRequest` and renders the camera/game interface.

## Run the current checks

```bash
swift test
```

## Build plan

1. Create an iOS App target in Xcode (SwiftUI, iOS 17+), then add this package as a local package.
2. Add a camera preview using AVFoundation.
3. Run Vision body-pose detection for each camera frame.
4. Map the detected shoulder, elbow, and wrist points into `JointPoint` values and feed them to `RepCounter`.
5. Persist `QuestProgress` locally with SwiftData.
6. Test with different lighting, camera distances, clothing, and body sizes; document the failure cases.

## Product decisions and limitations

- Start with **one side-facing bicep curl**, rather than promising every exercise. A scoped MVP makes accuracy measurable.
- The app detects movement—not exercise quality or health outcomes. It should not offer medical or injury-prevention advice.
- “Study mode” is a later feature: it can reward a timed focus session, but should never claim to judge whether someone is truly studying from a camera feed.

## Roadmap

- [x] Tested repetition-counting and streak logic
- [ ] Live camera + Vision body-pose adapter
- [ ] SwiftUI quest screen with XP animation
- [ ] Local persistence and weekly progress view
- [ ] Short usability test with 5 users
- [ ] Model/algorithm evaluation report

## References

- [Apple Vision: detecting human body poses](https://developer.apple.com/documentation/vision/vndetecthumanbodyposerequest)
- [Apple: classifying images with Vision and Core ML](https://developer.apple.com/documentation/coreml/classifying-images-with-vision-and-core-ml)

