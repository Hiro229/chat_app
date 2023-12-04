import 'package:chat_app/chat_page.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  // Flutterのウィジェットや他の機能を使用する前に、Flutterのフレームワークを初期化
  WidgetsFlutterBinding.ensureInitialized();
  // Firebaseを初期化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // MyApp ウィジェットをアプリのルートウィジェットとして実行
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // GoogleSignIn() ではなく FirebaseAuth の currentUser　で比較する
    if (FirebaseAuth.instance.currentUser == null) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const SignInPage(),
      );
    } else {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const ChatPage(),
      );
    }
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Googleでサインインするための非同期関数
  Future<void> signInWithGoogle() async {
    // Googleサインインのインスタンスを作成し、ユーザーがサインインするのを待つ
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: ['profile', 'email']).signIn();

    // サインインしたユーザーの認証情報を取得
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Firebaseの認証用にGoogleの資格情報を作成
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // 作成した資格情報でFirebaseにサインイン
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google sign in'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Chat App",
              style: TextStyle(fontSize: 20, color: Colors.black87),
            ),
            const Text(
              "Please login",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
                onPressed: () async {
                  await signInWithGoogle();
                  print(FirebaseAuth.instance.currentUser?.displayName);

                  // ログインに成功したらチャットページに遷移する
                  if (mounted) {
                    // 前のページに戻らせないようにする
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                      return const ChatPage();
                    }), (route) => false);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Image.asset(
                        'images/google_logo_icon.png',
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Text(
                      'Google sign in',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final postsReference = FirebaseFirestore.instance
    .collection('posts')
    .withConverter<Post>(// <> ここに変換したい型名をいれる
        fromFirestore: ((snapshot, _) {
  // 第二引数は使わないのでその場合は _ で不使用であることを示す
  return Post.fromFirestore(snapshot);
}), toFirestore: ((value, _) {
  return value.toMap();
}));
