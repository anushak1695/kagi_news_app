import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kagi_project/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../adaptiveSize.dart';

class NewsArticleCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final String source;
  final VoidCallback onTap;
  final DateTime publishedAt;

  const NewsArticleCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    required this.source,
    required this.onTap,
    required this.publishedAt,
  });

  @override
  State<NewsArticleCard> createState() => _NewsArticleCardState();
}

class _NewsArticleCardState extends State<NewsArticleCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _rotationAnimation = Tween<double>(
      begin: -0.2,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AdaptiveSize.init(context);
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: AdaptiveSize.w(25)),
                      child: Container(
                        padding: EdgeInsets.all(AdaptiveSize.w(4)),
                        decoration: BoxDecoration(
                          color: CustomColors.primary,
                          borderRadius: BorderRadius.circular(AdaptiveSize.w(40)),
                          boxShadow: [
                            BoxShadow(
                              color: CustomColors.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.newspaper,
                          size: AdaptiveSize.w(20),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: AdaptiveSize.w(16),
                          vertical: AdaptiveSize.h(8),
                        ),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AdaptiveSize.w(8)),
                        ),
                        child: InkWell(
                          onTap: widget.onTap,
                          borderRadius: BorderRadius.circular(AdaptiveSize.w(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.imageUrl != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(AdaptiveSize.w(12)),
                                  ),
                                  child: widget.imageUrl == null || widget.imageUrl!.isEmpty
                                      ? Container(
                                          height: AdaptiveSize.h(150),
                                          width: double.infinity,
                                          color: Colors.grey[200],
                                          child: Center(
                                            child: Icon(
                                              Icons.image,
                                              size: AdaptiveSize.w(40),
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        )
                                      : Image.network(
                                          widget.imageUrl!,
                                          height: AdaptiveSize.h(150),
                                          width: double.infinity,
                                          fit: BoxFit.fill,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              height: AdaptiveSize.h(150),
                                              width: double.infinity,
                                              color: Colors.grey[200],
                                              child: Center(
                                                child: Icon(
                                                  Icons.image,
                                                  size: AdaptiveSize.w(40),
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              Padding(
                                padding: EdgeInsets.all(AdaptiveSize.w(16)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.title,
                                      style: TextStyle(
                                        fontSize: AdaptiveSize.sp(14),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: AdaptiveSize.h(4)),
                                    Text(
                                      widget.subtitle,
                                      style: GoogleFonts.poppins(
                                        fontSize: AdaptiveSize.sp(14),
                                        color: Colors.grey[600],
                                        height: 1.4,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: AdaptiveSize.h(8)),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.source,
                                              size: AdaptiveSize.w(20),
                                              color: CustomColors.primary,
                                            ),
                                            SizedBox(width: AdaptiveSize.w(8)),
                                            Text(
                                              widget.source,
                                              style: GoogleFonts.poppins(
                                                fontSize: AdaptiveSize.sp(12),
                                                color: CustomColors.primary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Text(
                                          _formatDate(widget.publishedAt),
                                          style: GoogleFonts.poppins(
                                            fontSize: AdaptiveSize.sp(12),
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
} 