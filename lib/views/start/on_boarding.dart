import 'package:flutter/material.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/onboarding1.png',
      'title': 'Kemewahan dan Kenyamanan,\nDalam Satu Sentuhan.',
      'subtitle': 'Valonia, pesan hotel terbaik hanya dalam\nhitungan detik.',
    },
    {
      'image': 'assets/images/onboarding2.png',
      'title': 'Pesan dengan Mudah,\nMenginap dengan Gaya.',
      'subtitle': 'Pesan hotel dengan mudah dan nikmati\npengalaman menginap penuh gaya.',
    },
  ];

  void _nextPage() {
    if (_currentIndex < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/get_started');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    onboardingData[index]['image']!,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          onboardingData[index]['title']!,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: screenHeight * 0.028,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          onboardingData[index]['subtitle']!,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: screenHeight * 0.018,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 100), // spacer biar teks nggak mentok
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          // Bagian indikator + button dibuat fixed di bawah
          Positioned(
            bottom: 30,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Icon(
                        _currentIndex == index
                            ? Icons.circle
                            : Icons.circle_outlined,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _nextPage,
                  child: const Text(
                    'Selanjutnya',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
