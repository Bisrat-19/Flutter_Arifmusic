import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<String> trending = ["Song 1", "Song 2", "Song 3"];
  final List<String> featuredArtists = ["Rophnan", "Artist 2", "Artist 3"];
  final List<String> newReleases = ["Shegiye", "Release 2", "Release 3"];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,         // 🔑 removes back arrow
        title: const Text(
          'Home',                                  // correct title
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.white70),
                  hintText: 'songs ,artists...',
                  hintStyle: TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            // Discover Banner
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets\images\banner.jpg',
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.4),
                    child: const Text(
                      "Discover Ethiopian Music\nStream the best Ethiopian artists and discover new music from emerging talent",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Play Featured'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white38),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Explore'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            _sectionTitle('Trending Now'),
            _songList(trending),

            const SizedBox(height: 24),
            _sectionTitle('Featured Artists'),
            _artistList(featuredArtists),

            const SizedBox(height: 24),
            _sectionTitle('New Releases'),
            _songList(newReleases),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () {},
          child: const Text('View all', style: TextStyle(color: Colors.white70)),
        ),
      ],
    );
  }

  Widget _songList(List<String> songs) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/song.jpg',
                        height: 100,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Icon(Icons.play_circle, color: Colors.white, size: 32),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  songs[index],
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  'Artist Name',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _artistList(List<String> artists) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: artists.length,
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                const SizedBox(height: 6),
                Text(
                  artists[index],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  '1.5M Followers',
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
