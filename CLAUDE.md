# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.
必ず日本語で回答してください。

## Project Overview

ParentFeel is an iOS app for tracking parental emotions (親の感情を記録するiOSアプリ). Built with SwiftUI and SwiftData, it allows parents to log their emotional responses to situations with their children.

## Development Commands

### Building and Testing
- Build: Open `ParentFeel/ParentFeel.xcodeproj` in Xcode and use Cmd+B
- Run tests: Use Cmd+U in Xcode or run the test plan `ParentFeel.xctestplan`
- Unit tests are in `ParentFeelTests/` directory
- UI tests are in `ParentFeelUITests/` directory (currently disabled in test plan)

### Test Framework
- Uses Swift Testing framework (not XCTest) for unit tests
- Test files follow the pattern `*Tests.swift`
- All test classes should be marked with `@MainActor` and `@Suite`
- Individual tests use `@Test` attribute with descriptive names

## Architecture

### Core Data Model
- **Emotion**: Main SwiftData model representing emotional records
  - Contains emotion type, child/parent actions, notes, timestamp
  - Includes self-reflection fields: past experience, feelings, sentiment, desired response
- Uses SwiftData with persistent storage (not in-memory)

### View Architecture
- **MVVM pattern** with SwiftUI views and dedicated ViewState classes
- ViewState classes are `@MainActor` `ObservableObject` instances
- Navigation handled via `NavigationStack` with custom `Screen` enum

### Key Components
- **HomeView**: Main list view with monthly grouping of emotions
- **EmotionInputView**: Form for creating/editing emotional records  
- **EmotionDetailView**: Detail view for viewing emotion records
- **ActionSelectionView**: Multi-selection interface for actions

### View States
Each major view has a corresponding ViewState class:
- `HomeViewState`: Manages emotion list, grouping, deletion
- `EmotionInputViewState`: Handles form state and validation
- `EmotionDetailViewState`: Manages detail view interactions
- `ActionSelectionViewState`: Handles action selection logic

### Navigation
- Uses `Screen` enum for type-safe navigation:
  - `.home`: Home view
  - `.input(Emotion?)`: Input view (create or edit)
  - `.detail(Emotion)`: Detail view

### Data Grouping
- Emotions are grouped by month in the home view
- `groupEmotionsByMonth()` method creates `MonthSection` objects
- Sections are sorted in reverse chronological order

## Testing Strategy

### Unit Tests
- Focus on ViewState business logic
- Use in-memory ModelContainer for SwiftData testing
- Mock ModelContext operations where needed
- Test grouping, deletion, and state management functions

### Key Test Patterns
- Create test contexts with `ModelContainer(isStoredInMemoryOnly: true)`
- Use `ContextRecorder` pattern for testing deletion operations
- Test date grouping with controlled timestamps
- Verify navigation path state changes

## Development Notes

- Uses SwiftUI with iOS deployment target requirements
- Localizable strings in `Localizable.xcstrings`
- Google Services integration via `GoogleService-Info.plist`
- Hot reloading support via Inject framework in development