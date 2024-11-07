import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/view_modal/wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Preload assets here
      await Future.wait<void>([
        // Preload images
        // precacheImage(const AssetImage(' asset/abstral-official-aClNr1q61Cg-unsplash.jpg'), context),
        // precacheImage(const AssetImage('asset/ali-kanibelli-VeX_ZAqYg3I-unsplash.jpg'), context),
        // precacheImage(const AssetImage('asset/amir-maleky-pbxUrGBNVc0-unsplash.jpg'), context),
        // precacheImage(const AssetImage('asset/benjamin-lehman-sWVu4iFkhk8-unsplash.jpg'), context),
        // precacheImage(const AssetImage('asset/hoach-le-dinh-4GuylznlPk8-unsplash.jpg'), context),
        // precacheImage(const AssetImage('asset/pablo-de-la-fuente-UPexcwb9S94-unsplash.jpg'), context),
        // precacheImage(const AssetImage('asset/william-recinos-qtYhAQnIwSE-unsplash.jpg'), context),
        // precacheImage(const AssetImage('asset/zachrie-friesen-H_wGRt781Vk-unsplash.jpg'), context),
        
        // Preload Lottie animations
        _precacheLottieFile(context,'assets/animation1.json'),
        _precacheLottieFile(context,'assets/animation2.json'),
        
        // Add artificial delay if needed
        Future.delayed(const Duration(seconds: 2)),
      ]);

      // Load Google Fonts separately
      // await _loadGoogleFonts();
      
    } catch (e) {
      print('Error loading assets: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Navigate to Wrapper
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Wrapper()),
        );
      }
    }
  }

  Future<void> _loadGoogleFonts() async {
  
      // Load each font individually to avoid type inference issues
      //  GoogleFonts.getFont('Lato');
      //  GoogleFonts.getFont('Rubik');
      //  GoogleFonts.getFont('Great Vibes');
      //  GoogleFonts.getFont('ABeeZee');
      //  GoogleFonts.getFont('Philosopher');
      //  GoogleFonts.getFont('Abel');
      //  GoogleFonts.getFont('Playfair Display');
      //  GoogleFonts.getFont('Poppins');
      //  GoogleFonts.getFont('Montserrat');
      //  GoogleFonts.getFont('IBM Plex Sans');

  }

 Future<void> _precacheLottieFile(BuildContext context, String assetPath) async {
  try {
    // Preload the Lottie JSON data
    await DefaultAssetBundle.of(context).loadString(assetPath);

  } catch (e) {

  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your splash screen logo or animation
            Lottie.asset(
              'asset/Animation - 1729398055158.json',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Text(
                'Loading!',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}