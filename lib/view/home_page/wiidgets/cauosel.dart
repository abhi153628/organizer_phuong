// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//! CAROUSEL USED IN THE HOMEPAGE
class AnimatedEventCarousel extends StatefulWidget {
  const AnimatedEventCarousel({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedEventCarouselState createState() => _AnimatedEventCarouselState();
}

class _AnimatedEventCarouselState extends State<AnimatedEventCarousel> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(
    viewportFraction: 0.8,
    initialPage: 1,
  );
  int _currentPage = 1;
  Timer? _autoScrollTimer;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _opacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Auto-scroll feature
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      int nextPage = (_pageController.page!.toInt() + 1) % 5;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    });

    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
        _animationController.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 200, bottom: 20),
          child: Text(
            'LAST EVENT IN THIS MONTH',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            itemCount: 5,
            itemBuilder: (context, index) {
              bool isCenter = index == _currentPage;
              return AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isCenter ? _scaleAnimation.value : 0.8,
                    child: Opacity(
                      opacity: isCenter ? _opacityAnimation.value : 0.6,
                      child: child,
                    ),
                  );
                },
                child: _buildEventCard(index, isCenter),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(int index, bool isCenter) {
    final events = [
      {
        'title': 'THE SUMMER\nFORMAL CONCERT',
        'subtitle': 'Music Festival',
        'date': '20.06.2023',
        'price': '\$127.99',
      },
      {
        'title': 'DESIGN THINKING\nWORKSHOP',
        'subtitle': 'Design Society,\nCopenhagen, Denmark',
        'date': '27.06.2023',
        'price': null,
      },
      {
        'title': 'TECH STARTUP\nCONFERENCE',
        'subtitle': 'Innovation Hub',
        'date': '15.07.2023',
        'price': '\$199.99',
      },
      {
        'title': 'ART EXHIBITION\nOPENING',
        'subtitle': 'Metropolitan Museum',
        'date': '10.08.2023',
        'price': '\$50.00',
      },
      {
        'title': 'FOOD & WINE\nFESTIVAL',
        'subtitle': 'City Park',
        'date': '22.08.2023',
        'price': '\$75.00',
      },
    ];

    final event = events[index % events.length];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCenter ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            // ignore: prefer_const_constructors
            color: isCenter ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9) : Color.fromARGB(255, 0, 0, 0),
            blurRadius: 16,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event['title']!,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 26,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            event['subtitle']!,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                event['date']!,
                style: const TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (event['price'] != null)
                Text(
                  event['price']!,
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}