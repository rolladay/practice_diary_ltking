import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/color_constants.dart';
import '../constants/fonts_constants.dart';

class RankPage extends StatelessWidget {
  const RankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: primaryOrange,
        centerTitle: true,
        title: Column(
          children: [
            SizedBox(height: 8),
            Stack(
              children: [
                // Stroke Text
                Text(
                  '랭크',
                  style: appBarTitleTextStyleWithStroke,
                ),
                // Fill Text
                Text(
                  '랭크',
                  style: appBarTitleTextStyle,
                ),
              ],
            ),
          ],
        ),
        actions: [
          Image.asset(
            'assets/images/lotto_more.png',
            width: 32,
          ),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black, // 라인 색상
            height: 1.0, // 라인 두께
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('exp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            var users = snapshot.data!.docs;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['photoUrl']),
                  ),
                  title: Text(user['displayName']),
                  subtitle: Text('경험치: ${user['exp'].toString()}'),
                  trailing: Text('${index + 1}위'),
                );
              },
            );
          } else {
            return const Center(child: Text('순위가 없습니다.'));
          }
        },
      ),
    );
  }
}