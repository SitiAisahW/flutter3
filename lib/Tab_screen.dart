import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Main Screen with Tabs
class TabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('SMK Negeri 4 - Mobile Apps'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Beranda'),
              Tab(icon: Icon(Icons.person), text: 'Users'),
              Tab(icon: Icon(Icons.person), text: 'Profil'),
            ],
            labelColor: Color.fromARGB(255, 0, 0, 0),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color.fromRGBO(59, 114, 167, 0.034),
            indicatorWeight: 4.0,
          ),
          backgroundColor: Color.fromARGB(255, 153, 179, 228), // Soft galaxy purple for the app bar
        ),
        body: TabBarView(
          children: [
            BerandaTab(),
            UsersTab(),
            ProfilTab(),
          ],
        ),
      ),
    );
  }
}

// Layout for Home Tab
class BerandaTab extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.school, 'label': 'School'},
    {'icon': Icons.book, 'label': 'Courses'},
    {'icon': Icons.event, 'label': 'Events'},
    {'icon': Icons.notifications, 'label': 'Notifications'},
    {'icon': Icons.assignment, 'label': 'Assignments'},
    {'icon': Icons.chat, 'label': 'Chat'},
    {'icon': Icons.settings, 'label': 'Settings'},
    {'icon': Icons.help, 'label': 'Help'},
    {'icon': Icons.map, 'label': 'Map'},
    {'icon': Icons.calendar_today, 'label': 'Calendar'},
    {'icon': Icons.contact_phone, 'label': 'Contact'},
    {'icon': Icons.info, 'label': 'Info'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the appropriate screen on tap
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlaceholderScreen(item['label'])),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 156, 175, 228), // Soft pink for the bubble background
                    borderRadius: BorderRadius.circular(12), // Rounded rectangle box
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(item['icon'], size: 40.0, color: Colors.white), // White icon color
                ),
                SizedBox(height: 8.0),
                Text(
                  item['label'],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Colors.black87),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Layout for Users Tab
class UsersTab extends StatelessWidget {
  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        backgroundColor: Color.fromARGB(255, 149, 195, 238), // Matching soft galaxy purple for the app bar
      ),
      body: FutureBuilder<List<User>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 128, 185, 223),
                    child: Text(user.firstName[0], style: TextStyle(color: Colors.white)),
                  ),
                  title: Text(user.firstName),
                  subtitle: Text(user.email),
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

// Layout for Profile Tab
class ProfilTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/profile_picture.jpg'), // Ensure the path is correct
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'Siti Aisah',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 211, 91, 165)),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              'Email: siti aisah@example.com',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
          SizedBox(height: 30),
          Text(
            'Biodata',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 182, 83, 129)),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person, color: Color.fromARGB(255, 207, 79, 132)),
            title: Text('Nama Lengkap'),
            subtitle: Text('Siti Aisah'),
          ),
          ListTile(
            leading: Icon(Icons.cake, color: Color.fromARGB(255, 202, 106, 159)),
            title: Text('Tanggal Lahir'),
            subtitle: Text('23 Februari 2007'),
          )
        ],
      ),
    );
  }
}

// Placeholder screen for each menu item
class PlaceholderScreen extends StatelessWidget {
  final String title;

  PlaceholderScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Color.fromARGB(255, 137, 172, 204),
      ),
      body: Center(
        child: Text(
          '$title Page',
          style: TextStyle(fontSize: 24.0, color: Colors.black54),
        ),
      ),
    );
  }
}

// User Model
class User {
  final String firstName;
  final String email;
  User({required this.firstName, required this.email});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'],
      email: json['email'],
    );
  }
}