import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kagi_project/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'news_article_card.dart';
import '../services/news_service.dart';
import '../models/category.dart';
import '../adaptiveSize.dart';
import 'media_page.dart';
import 'app_guidelines_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final NewsService _newsService = NewsService();
  List<Category> _categories = [];
  List<Map<String, dynamic>> _articles = [];
  Category? _selectedCategory;
  bool _isLoading = false;
  bool _isSwipingUp = false;
  double _swipeProgress = 0.0;
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    
    _bounceAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _swipeProgress -= details.primaryDelta! / MediaQuery.of(context).size.height;
      _swipeProgress = _swipeProgress.clamp(0.0, 1.0);
      if (_swipeProgress > 0.3) {
        _isSwipingUp = true;
      }
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_swipeProgress > 0.3 && _categories.isNotEmpty) {
      setState(() {
        _swipeProgress = 1.0;
      });
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _isSwipingUp = false;
            _swipeProgress = 0.0;
          });
          _loadArticles(_categories[0]);
        }
      });
    } else {
      setState(() {
        _isSwipingUp = false;
        _swipeProgress = 0.0;
      });
    }
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _newsService.getCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading categories: $e')),
        );
      }
    }
  }

  Future<void> _loadArticles(Category category) async {
    print(category.file);
    setState(() {
      _isLoading = true;
      _selectedCategory = category;
    });

    try {
      final articles = await _newsService.getArticlesByCategory(category.file);
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading articles: $e')),
        );
      }
    }
  }

  List<Map<String, dynamic>> get _filteredArticles {
    if (_searchQuery.isEmpty) return _articles;
    return _articles.where((article) {
      final title = article['title']?.toString().toLowerCase() ?? '';
      return title.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize AdaptiveSize with the current context
    AdaptiveSize.init(context);

    return Scaffold(
      backgroundColor: CustomColors.primary,
      appBar: AppBar(
        backgroundColor: CustomColors.primary,
        title: Text(
          'Kagi\'s News',
          style: GoogleFonts.comicNeue(
            fontSize: AdaptiveSize.sp(17),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _selectedCategory != null
                ? () => _loadArticles(_selectedCategory!)
                : _loadCategories,
            color: Colors.white,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Categories Section
              Container(
                height: AdaptiveSize.h(80),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: AdaptiveSize.w(8), vertical: AdaptiveSize.w(16)),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory?.file == category.file;
                    
                    return GestureDetector(
                      onTap: () => _loadArticles(category),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: AdaptiveSize.w(16)),
                        margin: EdgeInsets.symmetric(horizontal: AdaptiveSize.w(4)),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color.fromARGB(255, 130, 192, 188).withOpacity(0.5): Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(AdaptiveSize.w(20)),
                        ),
                        child: Center(
                          child: Text(
                            category.name,
                            style: GoogleFonts.poppins(
                              fontSize: AdaptiveSize.sp(15),
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: Colors.white,
                          ),
                        ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Search Section - Only show when category is selected
              if (_selectedCategory != null)
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: AdaptiveSize.w(16), vertical: AdaptiveSize.h(8)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AdaptiveSize.w(12)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search in ${_selectedCategory?.name}...',
                          prefixIcon: Icon(Icons.search, color: CustomColors.primary),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_searchQuery.isNotEmpty)
                                IconButton(
                                  icon: Icon(Icons.clear, color: CustomColors.primary),
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                ),
                              IconButton(
                                icon: Icon(Icons.help_outline, color: CustomColors.primary),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AppGuidelinesPage()),
                                  );
                                },
                              ),
                            ],
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AdaptiveSize.w(16),
                            vertical: AdaptiveSize.h(12),
                          ),
                        ),
                        style: GoogleFonts.poppins(
                          fontSize: AdaptiveSize.sp(14),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MediaPage()),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: AdaptiveSize.w(16)),
                        padding: EdgeInsets.symmetric(
                          horizontal: AdaptiveSize.w(16),
                          vertical: AdaptiveSize.h(12),
                        ),
                        decoration: BoxDecoration(
                          color: CustomColors.primary,
                          borderRadius: BorderRadius.circular(AdaptiveSize.w(12)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.video_library,
                              color: Colors.white,
                              size: AdaptiveSize.w(20),
                            ),
                            SizedBox(width: AdaptiveSize.w(8)),
                            Text(
                              'View Media Center',
                              style: GoogleFonts.poppins(
                                fontSize: AdaptiveSize.sp(14),
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
              ),
              // Articles Section
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: AdaptiveSize.h(20)),
                  width: double.infinity,
                  decoration: BoxDecoration(
                 
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
            Colors.white,
               Colors.white,
                          const Color.fromARGB(255, 186, 215, 215).withOpacity(0.8),
         
            ],
          ),
        
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AdaptiveSize.w(100)),
                    ),
                  ),
                  child: _isLoading
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: AdaptiveSize.h(200),
                              width: AdaptiveSize.w(200),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFF6D5F7),
                                    Color(0xFFFBE9D7),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.newspaper,
                                  size: AdaptiveSize.w(60),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: AdaptiveSize.h(40)),
                            Text(
                              'Loading News...',
                              style: GoogleFonts.poppins(
                                fontSize: AdaptiveSize.sp(18),
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: AdaptiveSize.h(20)),
                            Text(
                              'Stay tuned for the latest updates',
                              style: GoogleFonts.poppins(
                                fontSize: AdaptiveSize.sp(14),
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        )
                      : _articles.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onVerticalDragUpdate: (details) {
                                    if (details.primaryDelta! < 0) {
                                      setState(() {
                                        _swipeProgress -= (details.primaryDelta! / 100);
                                        _swipeProgress = _swipeProgress.clamp(0.0, 1.0);
                                        if (_swipeProgress > 0.15) {
                                          _isSwipingUp = true;
                                        }
                                      });
                                    }
                                  },
                                  onVerticalDragEnd: (details) {
                                    if ((_swipeProgress > 0.15 || details.primaryVelocity! < -500) && _categories.isNotEmpty) {
                                      setState(() {
                                        _isSwipingUp = true;
                                        _swipeProgress = 1.0;
                                      });
                                      Future.delayed(const Duration(milliseconds: 1000), () {
                                        if (mounted) {
                                          setState(() {
                                            _isSwipingUp = false;
                                            _swipeProgress = 0.0;
                                          });
                                          _loadArticles(_categories[0]);
                                        }
                                      });
                                    } else {
                                      setState(() {
                                        _isSwipingUp = false;
                                        _swipeProgress = 0.0;
                                      });
                                    }
                                  },
                                  onTap: () {
                                    if (_categories.isNotEmpty) {
                                      setState(() {
                                        _isSwipingUp = true;
                                        _swipeProgress = 1.0;
                                      });
                                      Future.delayed(const Duration(milliseconds: 1000), () {
                                        if (mounted) {
                                          setState(() {
                                            _isSwipingUp = false;
                                            _swipeProgress = 0.0;
                                          });
                                          _loadArticles(_categories[0]);
                                        }
                                      });
                                    }
                                  },
                                  child: AnimatedBuilder(
                                    animation: _bounceAnimation,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(0, -_bounceAnimation.value),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(AdaptiveSize.w(16)),
                                              decoration: BoxDecoration(
                                                color: Colors.teal.withOpacity(0.1),
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.1),
                                                    blurRadius: AdaptiveSize.w(8),
                                                    offset: Offset(0, AdaptiveSize.h(4)),
                                                  ),
                                                ],
                                              ),
                                              child: Icon(
                                                Icons.touch_app,
                                                color: Colors.white,
                                                size: AdaptiveSize.w(40),
                                              ),
                                            ),
                                            SizedBox(height: AdaptiveSize.h(12)),
                                            Text(
                                              'Tap or Swipe up',
                                              style: GoogleFonts.poppins(
                                                fontSize: AdaptiveSize.sp(16),
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: AdaptiveSize.h(20)),
                                Text(
                                  _selectedCategory == null
                                      ? "What kind of news are you into?\nChoose a section!"
                                      : 'No articles found',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: AdaptiveSize.sp(16),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: AdaptiveSize.h(20)),
                              itemCount: _filteredArticles.length,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      NewsArticleCard(
                                        title: _filteredArticles[index]['title'] ?? 'No title',
                                        subtitle: _filteredArticles[index]['description'] ?? 'No description',
                                        imageUrl: _filteredArticles[index]['image'],
                                        source: _filteredArticles[index]['source'] ?? 'Unknown source',
                                        publishedAt: DateTime.parse(_filteredArticles[index]['date'] ?? ""),
                                        onTap: () async {
                                          await launchUrl(Uri.parse(_filteredArticles[index]['link'] ?? ""));
                                          Navigator.pushNamed(context, '/article-detail');
                                        },
                                      ),
                                    ],
                                  );
                                }
                                return NewsArticleCard(
                                  title: _filteredArticles[index]['title'] ?? 'No title',
                                  subtitle: _filteredArticles[index]['description'] ?? 'No description',
                                  imageUrl: _filteredArticles[index]['image'],
                                  source: _filteredArticles[index]['source'] ?? 'Unknown source',
                                  publishedAt: DateTime.parse(_filteredArticles[index]['date'] ?? ""),
                                  onTap: () async {
                                    await launchUrl(Uri.parse(_filteredArticles[index]['link'] ?? ""));
                                    Navigator.pushNamed(context, '/article-detail');
                                  },
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
          if (_isSwipingUp)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _swipeProgress,
              child: Container(
                color: CustomColors.primary,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(AdaptiveSize.w(16)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: AdaptiveSize.w(8),
                              offset: Offset(0, AdaptiveSize.h(4)),
                            ),
                          ],
                        ),
                        child: CircularProgressIndicator(
                          color: CustomColors.primary,
                          strokeWidth: AdaptiveSize.w(3),
                        ),
                      ),
                      SizedBox(height: AdaptiveSize.h(24)),
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
            ),
        ],
      ),
    );
  }
}

class ArticleSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> articles;

  ArticleSearchDelegate(this.articles);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredArticles = articles.where((article) {
      final title = article['title']?.toString().toLowerCase() ?? '';
      return title.contains(query.toLowerCase());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AdaptiveSize.w(16),
            vertical: AdaptiveSize.h(8),
          ),
          child: Text(
            'Search Results',
            style: GoogleFonts.poppins(
              fontSize: AdaptiveSize.sp(20),
              fontWeight: FontWeight.w600,
              color: CustomColors.primary,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredArticles.length,
            itemBuilder: (context, index) {
              final article = filteredArticles[index];
              return NewsArticleCard(
                title: article['title'] ?? 'No title',
                subtitle: article['description'] ?? 'No description',
                source: article['source']['name'] ?? 'Unknown source',
                publishedAt: article['publishedAt'] ?? '',
                onTap: () {
                  if (article['url'] != null) {
                    launchUrl(Uri.parse(article['url']));
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredArticles = articles.where((article) {
      final title = article['title']?.toString().toLowerCase() ?? '';
      return title.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredArticles.length,
      itemBuilder: (context, index) {
        final article = filteredArticles[index];
        return ListTile(
          title: Text(article['title'] ?? ''),
          onTap: () {
            query = article['title'] ?? '';
            showResults(context);
          },
        );
      },
    );
  }
}

class AdditionalInfoSection extends StatefulWidget {
  const AdditionalInfoSection({super.key});

  @override
  State<AdditionalInfoSection> createState() => _AdditionalInfoSectionState();
}

class _AdditionalInfoSectionState extends State<AdditionalInfoSection> {
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;
  bool _isVideoInitialized = false;
  int _selectedInfoIndex = 0;

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

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.network(
      _additionalInfo[_selectedInfoIndex]['videoUrl'],
    );

    await _videoController.initialize();
    
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: false,
      looping: false,
      aspectRatio: 16 / 9,
      showControls: true,
    );

    setState(() {
      _isVideoInitialized = true;
    });
  }

  void _changeInfo(int index) {
    setState(() {
      _selectedInfoIndex = index;
      _isVideoInitialized = false;
    });
    _initializeVideo();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AdaptiveSize.w(16), vertical: AdaptiveSize.h(8)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AdaptiveSize.w(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(AdaptiveSize.w(16)),
            child: Text(
              'Additional Information',
              style: GoogleFonts.poppins(
                fontSize: AdaptiveSize.sp(16),
                fontWeight: FontWeight.w600,
                color: CustomColors.primary,
              ),
            ),
          ),
          Container(
            height: AdaptiveSize.h(40),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AdaptiveSize.w(16)),
              itemCount: _additionalInfo.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _changeInfo(index),
                  child: Container(
                    margin: EdgeInsets.only(right: AdaptiveSize.w(8)),
                    padding: EdgeInsets.symmetric(
                      horizontal: AdaptiveSize.w(12),
                      vertical: AdaptiveSize.h(8),
                    ),
                    decoration: BoxDecoration(
                      color: _selectedInfoIndex == index
                          ? CustomColors.primary.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AdaptiveSize.w(20)),
                    ),
                    child: Text(
                      _additionalInfo[index]['title'],
                      style: GoogleFonts.poppins(
                        fontSize: AdaptiveSize.sp(12),
                        fontWeight: _selectedInfoIndex == index
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: _selectedInfoIndex == index
                            ? CustomColors.primary
                            : Colors.grey[700],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isVideoInitialized)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AdaptiveSize.w(16),
                    vertical: AdaptiveSize.h(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _additionalInfo[_selectedInfoIndex]['videoTitle'],
                        style: GoogleFonts.poppins(
                          fontSize: AdaptiveSize.sp(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AdaptiveSize.h(4)),
                      Text(
                        _additionalInfo[_selectedInfoIndex]['videoDescription'],
                        style: GoogleFonts.poppins(
                          fontSize: AdaptiveSize.sp(12),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: AdaptiveSize.h(200),
                  margin: EdgeInsets.symmetric(horizontal: AdaptiveSize.w(16)),
                  child: Chewie(controller: _chewieController),
                ),
              ],
            ),
          Padding(
            padding: EdgeInsets.all(AdaptiveSize.w(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _additionalInfo[_selectedInfoIndex]['description'],
                  style: GoogleFonts.poppins(
                    fontSize: AdaptiveSize.sp(14),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: AdaptiveSize.h(8)),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(_additionalInfo[_selectedInfoIndex]['title']),
                        content: Text(_additionalInfo[_selectedInfoIndex]['details']),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: CustomColors.primary,
                        size: AdaptiveSize.w(16),
                      ),
                      SizedBox(width: AdaptiveSize.w(8)),
                      Text(
                        'Learn more about this topic',
                        style: GoogleFonts.poppins(
                          fontSize: AdaptiveSize.sp(14),
                          color: CustomColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VideoClipsSection extends StatefulWidget {
  const VideoClipsSection({super.key});

  @override
  State<VideoClipsSection> createState() => _VideoClipsSectionState();
}

class _VideoClipsSectionState extends State<VideoClipsSection> {
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
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AdaptiveSize.w(16), vertical: AdaptiveSize.h(8)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AdaptiveSize.w(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(AdaptiveSize.w(16)),
            child: Text(
              'Video Clips',
              style: GoogleFonts.poppins(
                fontSize: AdaptiveSize.sp(16),
                fontWeight: FontWeight.w600,
                color: CustomColors.primary,
              ),
            ),
          ),
          Container(
            height: AdaptiveSize.h(200),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AdaptiveSize.w(16)),
              itemCount: _videoClips.length,
              itemBuilder: (context, index) {
                final clip = _videoClips[index];
                return GestureDetector(
                  onTap: () {
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
                                    videoPlayerController: VideoPlayerController.network(clip['videoUrl']),
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
                                      clip['title'],
                                      style: GoogleFonts.poppins(
                                        fontSize: AdaptiveSize.sp(16),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: AdaptiveSize.h(8)),
                                    Text(
                                      clip['description'],
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
                  },
                  child: Container(
                    width: AdaptiveSize.w(200),
                    margin: EdgeInsets.only(right: AdaptiveSize.w(16)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AdaptiveSize.w(12)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(AdaptiveSize.w(12)),
                          ),
                          child: Image.network(
                            clip['thumbnail'],
                            height: AdaptiveSize.h(120),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(AdaptiveSize.w(12)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(AdaptiveSize.w(12)),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                clip['title'],
                                style: GoogleFonts.poppins(
                                  fontSize: AdaptiveSize.sp(14),
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: AdaptiveSize.h(4)),
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
          SizedBox(height: AdaptiveSize.h(16)),
        ],
      ),
    );
  }
}