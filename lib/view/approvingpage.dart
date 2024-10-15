import 'package:flutter/material.dart';
import 'package:testing/view/home_page/homepage.dart';

class EventApproval extends StatelessWidget {
  const EventApproval({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                _buildHeader(),
              
                const SizedBox(height: 20,),
                // _buildPendingRequests(),
                listTile(context),
                 listTile(context),
                  listTile(context),
                   listTile(context),
                    listTile(context),
                     listTile(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'PHUONG ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'APPROVAL',
            style: TextStyle(
              color: Color(0xFF00FFA3),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildTab(String text) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text('Pending Aprovals'));
       
  }

 

  Widget listTile(BuildContext context) {
    
    
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: GestureDetector(
          onTap: () {
            // Action on tap
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('List Tile Tapped!')),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                const BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Hero(
                  tag: 'imageHero',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      'asset/amir-maleky-pbxUrGBNVc0-unsplash.jpg', // Replace with your image URL
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: const Text(
                  'IMAGINE DRAGONS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                subtitle: const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'California, Bermuda',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ),
      );}}