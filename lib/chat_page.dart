import 'dart:ffi';

import 'package:chat_app/my_page.dart';
import 'package:chat_app/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/main.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  final textEditingController = TextEditingController();

  Future<void> sendPost(String text) async {
    final user = FirebaseAuth.instance.currentUser!;
    final posterId = user.uid;
    final posterName = user.displayName!;
    final posterImageUrl = user.photoURL!;

    // 先ほど作った postsReference からランダムなIDのドキュメントリファレンスを作成します
    // doc の引数を空にするとランダムなIDが採番されます
    final newDocumentReference = postsReference.doc();

    final newPost = Post(
        posterName: posterName,
        createdAt: Timestamp.now(),
        text: text,
        like: null,
        posterId: posterId,
        posterImageUrl: posterImageUrl,
        postedImagePath: null,
        reference: newDocumentReference);

    // 先ほど作った newDocumentReference のset関数を実行するとそのドキュメントに
    // データが保存されます。
    // 引数として Post インスタンスを渡します。
    // 通常は Map しか受け付けませんが、withConverter を使用したことにより
    // Post インスタンスを受け取れるようになります。
    newDocumentReference.set(newPost);
  }

  @override
  void initState() {
    super.initState();
    // 初期スクロール位置の設定
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Form のキーを生成
    final _formKey = GlobalKey<FormState>();

    return SafeArea(
      child: GestureDetector(
        onDoubleTap: () {
          // キーボードを閉じたい時
          primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Chat'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const MyPage();
                        },
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      FirebaseAuth.instance.currentUser!.photoURL!,
                    ),
                  ),
                ),
              )
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot<Post>>(
                  // stream プロパティに snapshots() を与えると、
                  // コレクションの中のドキュメントをリアルタイムで監視することができます。
                  stream: postsReference.orderBy('createdAt').snapshots(),
                  // ここで受け取っている snapshot に stream で流れてきたデータが入っています。
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      // スクロール位置を最下部に設定
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                      });
                    }
                    // docs には Collection に保存されたすべてのドキュメントが入ります。
                    // 取得までには時間がかかるのではじめは null が入っています。
                    // null の場合は空配列が代入されるようにしています。
                    final docs = snapshot.data?.docs ?? [];
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        // data() に Post インスタンスが入っています。
                        // これは withConverter を使ったことにより得られる恩恵です。
                        // 何もしなければこのデータ型は Map になります。
                        final post = docs[index].data();
                        return PostWidget(post: post);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: textEditingController,
                          maxLines: null,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            fillColor: Colors.amber[50],
                            filled: true,
                          ),
                          onSaved: (text) {
                            textEditingController.text = text!;
                          },
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: textEditingController,
                        builder: (context, TextEditingValue value, _) {
                          return IconButton(
                            onPressed: value.text.isNotEmpty
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      sendPost(textEditingController.text);
                                      textEditingController.clear();
                                    }
                                  }
                                : null,
                            icon: Icon(Icons.send),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostWidget extends StatefulWidget {
  const PostWidget({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  // Form のキーを生成
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.post.posterImageUrl,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.post.posterName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat('MM/dd HH:mm')
                          .format(widget.post.createdAt.toDate()),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: FirebaseAuth.instance.currentUser?.uid ==
                                  widget.post.posterId
                              ? Colors.amber[100]
                              : Colors.blue[100],
                        ),
                        child: Text(widget.post.text),
                      ),
                    ),
                    if (FirebaseAuth.instance.currentUser?.uid ==
                        widget.post.posterId)
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              TextEditingController _textEditingController =
                                  TextEditingController(text: widget.post.text);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('編集'),
                                    content: Form(
                                      key: _formKey,
                                      child: TextFormField(
                                        controller: _textEditingController,
                                        autofocus: true,
                                        maxLines: null, // 複数行の入力を許可
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                          ),
                                          fillColor: Colors.amber[50],
                                          filled: true,
                                        ),
                                        onSaved: (updateText) {
                                          _textEditingController.text =
                                              updateText!;
                                        },
                                      ),
                                    ),
                                    actions: [
                                      ValueListenableBuilder(
                                        valueListenable: _textEditingController,
                                        builder: (context,
                                            TextEditingValue value, _) {
                                          return IconButton(
                                            onPressed: value.text.isNotEmpty
                                                ? () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      _formKey.currentState!
                                                          .save();
                                                      widget.post.reference
                                                          .update({
                                                        'text':
                                                            _textEditingController
                                                                .text
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  }
                                                : null,
                                            icon: Icon(Icons.send),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('確認'),
                                      content: Text('削除してよろしいですか？'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            // ダイアログを閉じる
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            widget.post.reference.delete();
                                            // ダイアログを閉じる
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  });
                              // post.reference.delete();
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
