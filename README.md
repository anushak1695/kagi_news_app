# Kagi's News App

A modern, responsive news application built with Flutter that provides a seamless experience for browsing and consuming news content across different categories.

## Features

### 1. News Categories
- Dynamic category selection with horizontal scrolling
- Visual feedback for selected categories
- Smooth transitions between categories
- Adaptive UI for different screen sizes

### 2. Article Display
- Clean, modern article cards with images
- Article details including title, description, source, and publication date
- Direct links to full articles
- Search functionality within selected categories
- "Latest Articles" section highlighting recent content

### 3. Interactive UI Elements
- Swipe-up gesture for quick category selection
- Tap-to-confirm functionality
- Animated loading indicators
- Responsive design using AdaptiveSize
- Custom color scheme and typography

### 4. Media Integration
- Video clips section with thumbnails
- Video player with controls
- Additional information section with video content
- Interactive media center

### 5. Search Functionality
- Real-time search within selected categories
- Search suggestions
- Clear search option
- Search results display with article cards

## Technical Implementation

### Architecture
- MVVM (Model-View-ViewModel) architecture
- State management using ChangeNotifier
- Responsive design using AdaptiveSize
- Modular code structure

### Key Components

#### 1. HomePage
- Main application screen
- Category selection
- Article display
- Search functionality
- Swipe-up gesture implementation

#### 2. NewsService
- API integration
- Category fetching
- Article retrieval
- Error handling

#### 3. NewsArticleCard
- Custom article display widget
- Image handling
- Date formatting
- Source attribution

#### 4. MediaPage
- Video content display
- Video player integration
- Thumbnail generation
- Playback controls

### Adaptive Design
- Uses AdaptiveSize for responsive layouts
- Dynamic font sizing
- Flexible padding and margins
- Device-specific optimizations

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^latest
  responsive_sizer: ^latest
  url_launcher: ^latest
  shimmer: ^latest
  video_player: ^latest
  chewie: ^latest
```

## UI/UX Features

### 1. Color Scheme
- Primary Color: Custom teal shade
- Secondary Colors: White, Grey
- Accent Colors: Various opacity levels
- Consistent color usage throughout the app

### 2. Typography
- Poppins font family
- Comic Neue for headings
- Adaptive font sizes
- Consistent text styling

### 3. Animations
- Bounce animation for swipe indicator
- Smooth transitions between states
- Loading animations
- Gesture-based interactions

### 4. Layout
- Responsive grid system
- Flexible container sizing
- Adaptive spacing
- Consistent padding and margins

## UI Guidelines

### 1. Color System

#### Primary Colors
```dart
// Main theme colors
const Color primaryColor = Color(0xFF1E88E5);  // Main blue
const Color accentColor = Color(0xFFE6A810);   // Gold accent
const Color backgroundColor = Color(0xFFF5F5F5); // Light background
```

#### Usage Guidelines
- Primary color for main actions and important elements
- Accent color for highlights and secondary actions
- Background color for content areas
- White for cards and elevated surfaces

### 2. Typography System

#### Font Families
```dart
// Main text styles
TextStyle(
  fontFamily: 'Poppins',
  fontSize: AdaptiveSize.sp(16),
  fontWeight: FontWeight.w500,
)

// Headings
TextStyle(
  fontFamily: 'Comic Neue',
  fontSize: AdaptiveSize.sp(24),
  fontWeight: FontWeight.w600,
)
```

#### Text Hierarchy
- H1: 24sp - Main headings
- H2: 20sp - Section headings
- H3: 18sp - Subheadings
- Body: 16sp - Regular text
- Caption: 14sp - Small text and captions

### 3. Spacing System

#### Padding and Margins
```dart
// Standard spacing values
const double spacingXS = 4.0;
const double spacingS = 8.0;
const double spacingM = 16.0;
const double spacingL = 24.0;
const double spacingXL = 32.0;

// Usage
padding: EdgeInsets.all(AdaptiveSize.w(spacingM))
margin: EdgeInsets.symmetric(horizontal: AdaptiveSize.w(spacingL))
```

#### Layout Grid
- Use consistent spacing between elements
- Maintain 8dp grid system
- Apply responsive spacing using AdaptiveSize

### 4. Component Guidelines

#### News Article Card
```dart
Container(
  margin: EdgeInsets.all(AdaptiveSize.w(spacingM)),
  padding: EdgeInsets.all(AdaptiveSize.w(spacingM)),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(AdaptiveSize.w(12)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: AdaptiveSize.w(8),
        offset: Offset(0, AdaptiveSize.h(4)),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Image
      ClipRRect(
        borderRadius: BorderRadius.circular(AdaptiveSize.w(8)),
        child: Image.network(
          imageUrl,
          height: AdaptiveSize.h(200),
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
      SizedBox(height: AdaptiveSize.h(spacingM)),
      // Title
      Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: AdaptiveSize.sp(18),
          fontWeight: FontWeight.w600,
        ),
      ),
      // Content
      Text(
        description,
        style: GoogleFonts.poppins(
          fontSize: AdaptiveSize.sp(14),
          color: Colors.grey[600],
        ),
      ),
    ],
  ),
)
```

#### Category Selector
```dart
Container(
  margin: EdgeInsets.symmetric(horizontal: AdaptiveSize.w(spacingS)),
  padding: EdgeInsets.symmetric(
    horizontal: AdaptiveSize.w(spacingM),
    vertical: AdaptiveSize.h(spacingS),
  ),
  decoration: BoxDecoration(
    color: isSelected ? primaryColor : Colors.grey[100],
    borderRadius: BorderRadius.circular(AdaptiveSize.w(20)),
    border: Border.all(
      color: isSelected ? primaryColor : Colors.grey[300],
      width: 1,
    ),
  ),
  child: Text(
    category.name,
    style: GoogleFonts.poppins(
      fontSize: AdaptiveSize.sp(14),
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      color: isSelected ? Colors.white : Colors.black87,
    ),
  ),
)
```

### 5. Animation Guidelines

#### Swipe Gesture Animation
```dart
// Bounce animation for swipe indicator
AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 1000),
)..repeat(reverse: true);

Animation<double> _bounceAnimation = Tween<double>(
  begin: 0.0,
  end: 10.0,
).animate(
  CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
  ),
);
```

#### Loading Animation
```dart
// Loading overlay animation
AnimatedOpacity(
  duration: const Duration(milliseconds: 200),
  opacity: _swipeProgress,
  child: Container(
    color: primaryColor,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: AdaptiveSize.w(3),
          ),
          SizedBox(height: AdaptiveSize.h(spacingM)),
          Text(
            'Loading...',
            style: GoogleFonts.poppins(
              fontSize: AdaptiveSize.sp(18),
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  ),
)
```

### 6. Responsive Design Patterns

#### Adaptive Layout
```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      // Tablet/Desktop layout
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: AdaptiveSize.w(spacingM),
          mainAxisSpacing: AdaptiveSize.h(spacingM),
        ),
        itemBuilder: (context, index) => NewsArticleCard(),
      );
    } else {
      // Mobile layout
      return ListView.builder(
        itemBuilder: (context, index) => NewsArticleCard(),
      );
    }
  },
)
```

### 7. Interaction Patterns

#### Gesture Handling
```dart
GestureDetector(
  onVerticalDragUpdate: (details) {
    if (details.primaryDelta! < 0) {
      setState(() {
        _swipeProgress -= (details.primaryDelta! / 100);
        _swipeProgress = _swipeProgress.clamp(0.0, 1.0);
      });
    }
  },
  onTap: () {
    // Handle tap
  },
  child: Container(
    // Visual feedback for interaction
    decoration: BoxDecoration(
      color: _isPressed ? primaryColor.withOpacity(0.1) : Colors.transparent,
      borderRadius: BorderRadius.circular(AdaptiveSize.w(8)),
    ),
  ),
)
```

### 8. Accessibility Guidelines

#### Text Contrast
- Maintain minimum contrast ratio of 4.5:1 for normal text
- Use semantic colors for text and backgrounds
- Provide sufficient touch targets (minimum 48x48dp)

#### Screen Reader Support
```dart
Semantics(
  label: 'News article card',
  child: NewsArticleCard(),
)
```

## Search Guidelines

### 1. Search Implementation

#### Search Bar Component
```dart
Container(
  margin: EdgeInsets.symmetric(horizontal: AdaptiveSize.w(16)),
  padding: EdgeInsets.symmetric(
    horizontal: AdaptiveSize.w(16),
    vertical: AdaptiveSize.h(8),
  ),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(AdaptiveSize.w(12)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: AdaptiveSize.w(8),
        offset: Offset(0, AdaptiveSize.h(2)),
      ),
    ],
  ),
  child: Row(
    children: [
      Icon(
        Icons.search,
        size: AdaptiveSize.w(24),
        color: Colors.grey[600],
      ),
      SizedBox(width: AdaptiveSize.w(8)),
      Expanded(
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search articles...',
            hintStyle: GoogleFonts.poppins(
              fontSize: AdaptiveSize.sp(14),
              color: Colors.grey[400],
            ),
            border: InputBorder.none,
          ),
          style: GoogleFonts.poppins(
            fontSize: AdaptiveSize.sp(14),
            color: Colors.black87,
          ),
          onChanged: (value) {
            // Handle search input
            _handleSearch(value);
          },
        ),
      ),
      if (_searchController.text.isNotEmpty)
        IconButton(
          icon: Icon(
            Icons.clear,
            size: AdaptiveSize.w(20),
            color: Colors.grey[600],
          ),
          onPressed: () {
            _searchController.clear();
            _clearSearch();
          },
        ),
    ],
  ),
)
```

### 2. Search Functionality

#### Search Logic
```dart
void _handleSearch(String query) {
  if (query.isEmpty) {
    _clearSearch();
    return;
  }

  // Debounce search to prevent too many API calls
  _debounceTimer?.cancel();
  _debounceTimer = Timer(const Duration(milliseconds: 500), () {
    _performSearch(query);
  });
}

Future<void> _performSearch(String query) async {
  try {
    setState(() => _isSearching = true);
    
    final results = await _newsService.searchArticles(
      query: query,
      category: _selectedCategory,
    );
    
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  } catch (e) {
    setState(() => _isSearching = false);
    // Handle error
  }
}
```

### 3. Search Results Display

#### Results List
```dart
ListView.builder(
  padding: EdgeInsets.all(AdaptiveSize.w(16)),
  itemCount: _searchResults.length,
  itemBuilder: (context, index) {
    final article = _searchResults[index];
    return NewsArticleCard(
      article: article,
      onTap: () => _navigateToArticle(article),
    );
  },
)
```

#### No Results State
```dart
if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
  Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.search_off,
          size: AdaptiveSize.w(48),
          color: Colors.grey[400],
        ),
        SizedBox(height: AdaptiveSize.h(16)),
        Text(
          'No articles found',
          style: GoogleFonts.poppins(
            fontSize: AdaptiveSize.sp(16),
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: AdaptiveSize.h(8)),
        Text(
          'Try different keywords',
          style: GoogleFonts.poppins(
            fontSize: AdaptiveSize.sp(14),
            color: Colors.grey[400],
          ),
        ),
      ],
    ),
  )
```

### 4. Search Performance

#### Debouncing
```dart
Timer? _debounceTimer;

void _handleSearch(String query) {
  _debounceTimer?.cancel();
  _debounceTimer = Timer(const Duration(milliseconds: 500), () {
    _performSearch(query);
  });
}
```

#### Caching
```dart
class SearchCache {
  final Map<String, List<Article>> _cache = {};
  final Duration _cacheDuration = const Duration(minutes: 5);
  final Map<String, DateTime> _cacheTimestamps = {};

  List<Article>? getResults(String query) {
    final timestamp = _cacheTimestamps[query];
    if (timestamp == null) return null;
    
    if (DateTime.now().difference(timestamp) > _cacheDuration) {
      _cache.remove(query);
      _cacheTimestamps.remove(query);
      return null;
    }
    
    return _cache[query];
  }

  void cacheResults(String query, List<Article> results) {
    _cache[query] = results;
    _cacheTimestamps[query] = DateTime.now();
  }
}
```

### 5. Search UX Guidelines

#### Visual Feedback
- Show loading indicator during search
- Display clear button when search has input
- Provide immediate visual feedback for user actions
- Show error states when search fails

#### Search Suggestions
```dart
class SearchSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AdaptiveSize.w(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AdaptiveSize.w(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: AdaptiveSize.w(8),
            offset: Offset(0, AdaptiveSize.h(2)),
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              Icons.history,
              size: AdaptiveSize.w(20),
              color: Colors.grey[600],
            ),
            title: Text(
              suggestions[index],
              style: GoogleFonts.poppins(
                fontSize: AdaptiveSize.sp(14),
                color: Colors.black87,
              ),
            ),
            onTap: () => onSuggestionTap(suggestions[index]),
          );
        },
      ),
    );
  }
}
```

### 6. Search Error Handling

#### Error States
```dart
if (_searchError != null)
  Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: AdaptiveSize.w(48),
          color: Colors.red[400],
        ),
        SizedBox(height: AdaptiveSize.h(16)),
        Text(
          'Search failed',
          style: GoogleFonts.poppins(
            fontSize: AdaptiveSize.sp(16),
            color: Colors.red[600],
          ),
        ),
        SizedBox(height: AdaptiveSize.h(8)),
        Text(
          _searchError!,
          style: GoogleFonts.poppins(
            fontSize: AdaptiveSize.sp(14),
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: AdaptiveSize.h(16)),
        ElevatedButton(
          onPressed: _retrySearch,
          child: Text('Try Again'),
        ),
      ],
    ),
  )
```

## App Guidelines

### 1. Quick Start Guide

#### Getting Started
- Tap the search bar to begin exploring articles
- Swipe up on the indicator to load the first category
- Use the category selector to switch between news topics
- Tap any article to read the full content

#### Search Tips
- Type keywords to find specific articles
- Use quotes for exact phrase matches
- Add category names to filter results
- Clear search to return to all articles

### 2. Navigation Guide

#### Main Features
```dart
// Navigation structure
BottomNavigationBar(
  items: [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.video_library),
      label: 'Media',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ],
)
```

#### Gesture Controls
- Swipe up: Load first category
- Swipe down: Refresh content
- Tap: Select category or article
- Long press: Save article for later

### 3. Article Interaction

#### Reading Articles
- Tap article card to open full content
- Swipe left/right to navigate between articles
- Use the share button to share articles
- Bookmark articles for later reading

#### Article Features
```dart
// Article interaction options
Row(
  children: [
    IconButton(
      icon: Icon(Icons.bookmark_border),
      onPressed: () => _saveArticle(article),
    ),
    IconButton(
      icon: Icon(Icons.share),
      onPressed: () => _shareArticle(article),
    ),
    IconButton(
      icon: Icon(Icons.open_in_new),
      onPressed: () => _openInBrowser(article),
    ),
  ],
)
```

### 4. Media Center Guide

#### Video Features
- Browse video clips by category
- Watch full-screen videos
- Save videos for offline viewing
- Share videos with friends

#### Media Controls
```dart
// Video player controls
VideoPlayer(
  controller: _videoController,
  child: Stack(
    children: [
      Center(
        child: _videoController.value.isPlaying
            ? IconButton(
                icon: Icon(Icons.pause),
                onPressed: () => _videoController.pause(),
              )
            : IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () => _videoController.play(),
              ),
      ),
    ],
  ),
)
```

### 5. Settings and Preferences

#### Customization Options
- Dark/Light mode toggle
- Font size adjustment
- Notification preferences
- Data usage settings

#### Settings Implementation
```dart
// Settings options
ListTile(
  leading: Icon(Icons.dark_mode),
  title: Text('Dark Mode'),
  trailing: Switch(
    value: _isDarkMode,
    onChanged: (value) => _toggleDarkMode(value),
  ),
),
ListTile(
  leading: Icon(Icons.text_fields),
  title: Text('Font Size'),
  trailing: DropdownButton<String>(
    value: _selectedFontSize,
    items: ['Small', 'Medium', 'Large']
        .map((size) => DropdownMenuItem(
              value: size,
              child: Text(size),
            ))
        .toList(),
    onChanged: (value) => _changeFontSize(value),
  ),
),
```

### 6. Help and Support

#### Common Issues
- Search not working? Try clearing the search bar
- Articles not loading? Check your internet connection
- Videos not playing? Update the app to latest version
- App crashing? Clear app cache and restart

#### Support Options
```dart
// Help and support options
ListTile(
  leading: Icon(Icons.help_outline),
  title: Text('Help Center'),
  onTap: () => _openHelpCenter(),
),
ListTile(
  leading: Icon(Icons.feedback),
  title: Text('Send Feedback'),
  onTap: () => _sendFeedback(),
),
ListTile(
  leading: Icon(Icons.bug_report),
  title: Text('Report Issue'),
  onTap: () => _reportIssue(),
),
```

### 7. Accessibility Features

#### Available Options
- Screen reader support
- High contrast mode
- Text scaling
- Reduced motion

#### Accessibility Implementation
```dart
// Accessibility settings
ListTile(
  leading: Icon(Icons.accessibility),
  title: Text('Accessibility'),
  subtitle: Text('Customize app accessibility'),
  onTap: () => _openAccessibilitySettings(),
),
```

### 8. Data and Privacy

#### Privacy Settings
- Data collection preferences
- Location services
- Personalization options
- Account management

#### Privacy Implementation
```dart
// Privacy settings
ListTile(
  leading: Icon(Icons.privacy_tip),
  title: Text('Privacy Settings'),
  subtitle: Text('Manage your data and privacy'),
  onTap: () => _openPrivacySettings(),
),
```

## Setup Instructions

### 1. Development Environment Setup

#### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / VS Code with Flutter extensions
- Git
- Android/iOS emulator or physical device

#### Installing Flutter
1. **Download Flutter SDK**
   ```bash
   # For macOS
   cd ~/development
   git clone https://github.com/flutter/flutter.git -b stable
   ```

2. **Add Flutter to PATH**
   ```bash
   # For macOS
   export PATH="$PATH:`pwd`/flutter/bin"
   ```

3. **Verify Installation**
   ```bash
   flutter doctor
   ```

4. **Install Android Studio**
   - Download from [Android Studio website](https://developer.android.com/studio)
   - Install Flutter and Dart plugins
   - Configure Android SDK

5. **Install VS Code (Optional)**
   - Download from [VS Code website](https://code.visualstudio.com/)
   - Install Flutter and Dart extensions
   - Configure Flutter SDK path

### 2. Project Setup

#### Clone Repository
```bash
git clone https://github.com/yourusername/kagi_project.git
cd kagi_project
```

#### Install Dependencies
```bash
flutter pub get
```

#### Configure Environment
1. **Create Environment File**
   ```bash
   cp .env.example .env
   ```

2. **Update Environment Variables**
   - Open `.env` file
   - Add your API keys and configuration
   ```env
   NEWS_API_KEY=your_api_key_here
   VIDEO_API_KEY=your_video_api_key_here
   ```

#### Configure AdaptiveSize
1. **Update Screen Breakpoints**
   ```dart
   // In lib/widgets/adaptive_size.dart
   static const double mobileBreakpoint = 600;
   static const double tabletBreakpoint = 900;
   static const double desktopBreakpoint = 1200;
   ```

2. **Configure Font Sizes**
   ```dart
   // In lib/widgets/adaptive_size.dart
   static const double baseFontSize = 16;
   static const double headingFontSize = 24;
   ```

### 3. Platform-Specific Setup

#### Android Setup
1. **Configure Android SDK**
   - Open Android Studio
   - Go to Tools > SDK Manager
   - Install required SDK versions

2. **Update Android Manifest**
   ```xml
   <!-- In android/app/src/main/AndroidManifest.xml -->
   <uses-permission android:name="android.permission.INTERNET"/>
   <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
   ```

3. **Configure Gradle**
   ```gradle
   // In android/app/build.gradle
   android {
       compileSdkVersion 33
       defaultConfig {
           minSdkVersion 21
           targetSdkVersion 33
       }
   }
   ```

#### iOS Setup
1. **Install Xcode**
   - Download from App Store
   - Install required iOS SDK

2. **Configure Info.plist**
   ```xml
   <!-- In ios/Runner/Info.plist -->
   <key>NSAppTransportSecurity</key>
   <dict>
       <key>NSAllowsArbitraryLoads</key>
       <true/>
   </dict>
   ```

3. **Update Podfile**
   ```ruby
   # In ios/Podfile
   platform :ios, '12.0'
   ```

### 4. Running the App

#### Development Mode
```bash
# For Android
flutter run -d android

# For iOS
flutter run -d ios
```

#### Release Mode
```bash
# For Android
flutter build apk --release

# For iOS
flutter build ios --release
```

### 5. Testing Setup

#### Unit Tests
```bash
flutter test
```

#### Widget Tests
```bash
flutter test test/widget_test.dart
```

#### Integration Tests
```bash
flutter test integration_test/app_test.dart
```

### 6. Common Issues and Solutions

#### Flutter Doctor Issues
- If `flutter doctor` shows issues:
  - Run `flutter doctor --android-licenses`
  - Install missing components
  - Update environment variables

#### Build Issues
- Clean project:
  ```bash
  flutter clean
  flutter pub get
  ```
- Reset iOS pods:
  ```bash
  cd ios
  pod deintegrate
  pod install
  ```

#### Emulator Issues
- Create new emulator:
  ```bash
  flutter emulators --create --name pixel_4
  flutter emulators --launch pixel_4
  ```

### 7. Development Workflow

#### Code Style
```bash
# Format code
flutter format .

# Analyze code
flutter analyze
```

#### Version Control
```bash
# Create feature branch
git checkout -b feature/new-feature

# Commit changes
git add .
git commit -m "Add new feature"

# Push changes
git push origin feature/new-feature
```

#### Continuous Integration
- Configure GitHub Actions
- Set up automated testing
- Enable code coverage reports

## Getting Started

### Prerequisites
- Flutter SDK
- Dart SDK
- Android Studio / VS Code
- Android/iOS emulator or physical device

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

### Configuration
- Update API endpoints in NewsService
- Configure AdaptiveSize parameters if needed
- Set up video player configurations

## Code Structure

```
lib/
├── constants.dart
├── main.dart
├── models/
│   └── category.dart
├── services/
│   └── news_service.dart
├── view/
│   ├── homePage.dart
│   ├── media_page.dart
│   └── news_article_card.dart
├── viewModels/
│   └── news_service_viewmodel.dart
└── widgets/
    └── adaptive_size.dart
```

## Code Guidelines

### 1. Naming Conventions

#### Files and Directories
- Use lowercase with underscores for file names: `news_article_card.dart`
- Use PascalCase for class names: `NewsArticleCard`
- Use camelCase for variables and methods: `loadArticles()`
- Use UPPER_CASE for constants: `MAX_ARTICLES`

#### Widget Naming
```dart
// Good
class NewsArticleCard extends StatelessWidget
class CategorySelector extends StatefulWidget

// Bad
class newsArticleCard extends StatelessWidget
class category_selector extends StatefulWidget
```

### 2. Code Structure

#### Widget Organization
```dart
class ExampleWidget extends StatelessWidget {
  // 1. Constants
  static const double padding = 16.0;
  
  // 2. Constructor
  const ExampleWidget({Key? key}) : super(key: key);
  
  // 3. Build method
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

#### Stateful Widget Structure
```dart
class ExampleStatefulWidget extends StatefulWidget {
  const ExampleStatefulWidget({Key? key}) : super(key: key);

  @override
  State<ExampleStatefulWidget> createState() => _ExampleStatefulWidgetState();
}

class _ExampleStatefulWidgetState extends State<ExampleStatefulWidget> {
  // 1. Variables
  late AnimationController _controller;
  
  // 2. initState
  @override
  void initState() {
    super.initState();
    _initializeController();
  }
  
  // 3. dispose
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  // 4. Helper methods
  void _initializeController() {
    // Implementation
  }
  
  // 5. Build method
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

### 3. Adaptive Design Guidelines

#### Using AdaptiveSize
```dart
// Good
padding: EdgeInsets.all(AdaptiveSize.w(16))
fontSize: AdaptiveSize.sp(14)

// Bad
padding: EdgeInsets.all(16)
fontSize: 14
```

#### Responsive Layouts
```dart
// Use LayoutBuilder for responsive layouts
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return DesktopLayout();
    } else {
      return MobileLayout();
    }
  },
)
```

### 4. State Management

#### ViewModel Implementation
```dart
class NewsViewModel extends ChangeNotifier {
  // 1. Private variables
  List<Article> _articles = [];
  bool _isLoading = false;
  
  // 2. Getters
  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  
  // 3. Methods
  Future<void> loadArticles() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _articles = await _newsService.getArticles();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### 5. Error Handling

#### API Calls
```dart
Future<void> fetchData() async {
  try {
    final response = await _api.getData();
    // Handle success
  } catch (e) {
    // Log error
    debugPrint('Error fetching data: $e');
    // Show user-friendly error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to load data')),
    );
  }
}
```

### 6. Performance Optimization

#### Image Loading
```dart
// Use cached_network_image for better performance
CachedNetworkImage(
  imageUrl: article.imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

#### List Optimization
```dart
ListView.builder(
  itemCount: articles.length,
  itemBuilder: (context, index) {
    return NewsArticleCard(article: articles[index]);
  },
)
```

### 7. Documentation

#### Widget Documentation
```dart
/// A widget that displays a news article card with image, title, and description.
/// 
/// This widget is used to display individual news articles in a list format.
/// It includes an image, title, description, and source information.
/// 
/// Example:
/// ```dart
/// NewsArticleCard(
///   title: 'Breaking News',
///   description: 'Description here',
///   imageUrl: 'https://example.com/image.jpg',
/// )
/// ```
class NewsArticleCard extends StatelessWidget {
  // Implementation
}
```

### 8. Testing Guidelines

#### Widget Testing
```dart
void main() {
  testWidgets('NewsArticleCard displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NewsArticleCard(
          title: 'Test Title',
          description: 'Test Description',
        ),
      ),
    );
    
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
  });
}
```

## Best Practices Implemented

1. **Code Organization**
   - Clear separation of concerns
   - Modular component design
   - Consistent naming conventions

2. **Performance**
   - Efficient state management
   - Optimized image loading
   - Lazy loading of content

3. **User Experience**
   - Smooth animations
   - Responsive feedback
   - Intuitive navigation

4. **Maintainability**
   - Clean code structure
   - Comprehensive documentation
   - Reusable components

## Future Enhancements

1. **Planned Features**
   - Offline support
   - Push notifications
   - User preferences
   - Dark mode

2. **Improvements**
   - Enhanced search capabilities
   - More media integration
   - Performance optimizations
   - Additional customization options

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- All contributors to the project
- Open source community for various packages used

## Support

For support, please open an issue in the GitHub repository or contact the development team.
