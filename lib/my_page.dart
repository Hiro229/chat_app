import 'package:chat_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Page'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL!),
              radius: 40,
            ),
            Text(
              user.displayName!,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ユーザーID：',
                  style: TextStyle(fontSize: 20),
                ),
                Expanded(
                  child: Text(
                    user.uid,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '登録日：',
                  style: TextStyle(fontSize: 20),
                ),
                Expanded(
                  child: Text(
                    '${user.metadata.creationTime!}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
// Google からサインアウト
                await GoogleSignIn().signOut();
                // Firebase からサインアウト
                await FirebaseAuth.instance.signOut();
                // ログインページに遷移
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return const SignInPage();
                }), (route) => false);
              },
              child: Text('ログアウト'),
            ),
          ],
        ),
      ),
    );
  }
}
