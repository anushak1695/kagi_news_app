import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kagi_project/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../adaptiveSize.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  final List<Map<String, dynamic>> _additionalInfo = [
    {
      'title': 'Breaking News Analysis',
      'description': 'Get in-depth analysis of the latest breaking news stories with expert commentary.',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'details': 'Our team of expert analysts provides comprehensive coverage of breaking news events, offering unique insights and perspectives that help you understand the bigger picture.',
      'videoTitle': 'Latest Breaking News Analysis',
      'videoDescription': 'Watch our expert panel discuss the most important news stories of the day.'
    },
    {
      'title': 'Market Updates',
      'description': 'Stay informed about the latest market trends and financial news.',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      'details': 'Get real-time updates on stock markets, cryptocurrency trends, and global financial news. Our experts break down complex financial concepts into easy-to-understand insights.',
      'videoTitle': 'Daily Market Analysis',
      'videoDescription': 'Expert analysis of today\'s market movements and what they mean for investors.'
    },
    {
      'title': 'Technology News',
      'description': 'Explore the latest developments in technology and innovation.',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      'details': 'From AI breakthroughs to the latest gadgets, we cover all aspects of technology news. Stay ahead of the curve with our comprehensive tech coverage.',
      'videoTitle': 'Tech Innovation Showcase',
      'videoDescription': 'Discover the latest technological advancements and their impact on our daily lives.'
    }
  ];

  final List<Map<String, dynamic>> _videoClips = [
    {
      'title': 'Latest News Highlights',
      'description': 'Watch the most important news stories of the day',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'thumbnail': 'https://picsum.photos/200/150?random=1',
    },
    {
      'title': 'Sports News',
      'description': 'Catch up with the latest sports updates',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      'thumbnail': 'https://picsum.photos/200/150?random=2',
    },
    {
      'title': 'Technology Updates',
      'description': 'Latest tech news and innovations',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      'thumbnail': 'https://picsum.photos/200/150?random=3',
    },
    {
      'title': 'Business News',
      'description': 'Market updates and business insights',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'thumbnail': 'https://picsum.photos/200/150?random=4',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    // Initialize AdaptiveSize
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AdaptiveSize.init(context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: CustomColors.primary,
        title: Text(
          'Media Center',
          style: GoogleFonts.poppins(
            fontSize: AdaptiveSize.sp(18),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              child: Text(
                'Featured Content',
                style: GoogleFonts.poppins(
                  fontSize: AdaptiveSize.sp(14),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Video Clips',
                style: GoogleFonts.poppins(
                  fontSize: AdaptiveSize.sp(14),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFeaturedContent(),
          _buildVideoClips(),
        ],
      ),
    );
  }

  Widget _buildFeaturedContent() {
    return ListView.builder(
      padding: EdgeInsets.all(AdaptiveSize.w(16)),
      itemCount: _additionalInfo.length,
      itemBuilder: (context, index) {
        final info = _additionalInfo[index];
        return Card(
          margin: EdgeInsets.only(bottom: AdaptiveSize.h(16)),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AdaptiveSize.w(12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AdaptiveSize.w(12)),
                  ),
                  child: Image.network(
                    'https://picsum.photos/800/450?random=${index + 10}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AdaptiveSize.w(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info['title'],
                      style: GoogleFonts.poppins(
                        fontSize: AdaptiveSize.sp(18),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AdaptiveSize.h(8)),
                    Text(
                      info['description'],
                      style: GoogleFonts.poppins(
                        fontSize: AdaptiveSize.sp(14),
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: AdaptiveSize.h(16)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            _showVideoDialog(info);
                          },
                          icon: Icon(Icons.play_circle_outline),
                          label: Text('Watch Video'),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            _showDetailsDialog(info);
                          },
                          icon: Icon(Icons.info_outline),
                          label: Text('More Info'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVideoClips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AdaptiveSize.w(16),
            vertical: AdaptiveSize.h(8),
          ),
          child: Text(
            'Latest Articles',
            style: GoogleFonts.poppins(
              fontSize: AdaptiveSize.sp(20),
              fontWeight: FontWeight.w600,
              color: CustomColors.primary,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(AdaptiveSize.w(16)),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: AdaptiveSize.w(16),
              mainAxisSpacing: AdaptiveSize.h(16),
            ),
            itemCount: _videoClips.length,
            itemBuilder: (context, index) {
              final clip = _videoClips[index];
              return GestureDetector(
                onTap: () => _showVideoDialog(clip),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Image.network(
                            clip['thumbnail'],
                            height: AdaptiveSize.h(120),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(AdaptiveSize.w(8)),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: AdaptiveSize.w(24),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(AdaptiveSize.w(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              clip['title'],
                              style: GoogleFonts.poppins(
                                fontSize: AdaptiveSize.sp(14),
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: AdaptiveSize.h(8)),
                            Text(
                              clip['description'],
                              style: GoogleFonts.poppins(
                                fontSize: AdaptiveSize.sp(12),
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showVideoDialog(Map<String, dynamic> content) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              Expanded(
                child: Chewie(
                  controller: ChewieController(
                    videoPlayerController: VideoPlayerController.network(content['videoUrl']),
                    autoPlay: true,
                    looping: false,
                    aspectRatio: 16 / 9,
                    showControls: true,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AdaptiveSize.w(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content['title'],
                      style: GoogleFonts.poppins(
                        fontSize: AdaptiveSize.sp(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AdaptiveSize.h(8)),
                    Text(
                      content['description'],
                      style: GoogleFonts.poppins(
                        fontSize: AdaptiveSize.sp(14),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailsDialog(Map<String, dynamic> content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(content['title']),
        content: Text(content['details']),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
} 