import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kagi_project/adaptiveSize.dart';
import 'package:kagi_project/constants.dart';

class AppGuidelinesPage extends StatelessWidget {
  const AppGuidelinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    AdaptiveSize.init(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomColors.primary,
        title: Text(
          'App Guidelines',
          style: GoogleFonts.comicNeue(
            fontSize: AdaptiveSize.sp(17),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Getting Started',
              icon: Icons.play_circle_outline,
              content: [
                'Tap the search bar to begin exploring articles',
                'Swipe up on the indicator to load the first category',
                'Use the category selector to switch between news topics',
                'Tap any article to read the full content',
              ],
            ),
            _buildSection(
              title: 'Search Tips',
              icon: Icons.search,
              content: [
                'Type keywords to find specific articles',
                'Use quotes for exact phrase matches',
                'Add category names to filter results',
                'Clear search to return to all articles',
              ],
            ),
            _buildSection(
              title: 'Navigation Guide',
              icon: Icons.navigation,
              content: [
                'Swipe up: Load first category',
                'Swipe down: Refresh content',
                'Tap: Select category or article',
                'Long press: Save article for later',
              ],
            ),
            _buildSection(
              title: 'Article Features',
              icon: Icons.article,
              content: [
                'Tap article card to open full content',
                'Swipe left/right to navigate between articles',
                'Use the share button to share articles',
                'Bookmark articles for later reading',
              ],
            ),
            _buildSection(
              title: 'Media Center',
              icon: Icons.video_library,
              content: [
                'Browse video clips by category',
                'Watch full-screen videos',
                'Save videos for offline viewing',
                'Share videos with friends',
              ],
            ),
            _buildSection(
              title: 'Settings & Preferences',
              icon: Icons.settings,
              content: [
                'Dark/Light mode toggle',
                'Font size adjustment',
                'Notification preferences',
                'Data usage settings',
              ],
            ),
            SizedBox(height: AdaptiveSize.h(20)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<String> content,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(AdaptiveSize.w(16)),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: CustomColors.primary,
                  size: AdaptiveSize.w(24),
                ),
                SizedBox(width: AdaptiveSize.w(12)),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: AdaptiveSize.sp(18),
                    fontWeight: FontWeight.w600,
                    color: CustomColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          ...content.map((item) => Padding(
            padding: EdgeInsets.all(AdaptiveSize.w(16)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: AdaptiveSize.w(20),
                ),
                SizedBox(width: AdaptiveSize.w(12)),
                Expanded(
                  child: Text(
                    item,
                    style: GoogleFonts.poppins(
                      fontSize: AdaptiveSize.sp(14),
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
} 