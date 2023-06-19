import 'package:emoji_picker/emojis_widget.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController textEditingController = TextEditingController();
  bool emojiShowing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (emojiShowing)
            EmojisWidget(addEmojiToTextController: addEmojiToTextController),
          TextField(
            controller: textEditingController,
            onTap: () {
              setState(() {
                emojiShowing = false;
              });
            },
            maxLines: null,
            style: TextStyle(
              fontSize: 18,
            ),
            decoration: InputDecoration(
              
              prefixIcon: GestureDetector(
                onTap: () async {
                  if (emojiShowing) {
                    setState(() {
                      emojiShowing = false;
                    });
                    await Future.delayed(const Duration(milliseconds: 500))
                        .then(
                      (value) async {
                        await SystemChannels.textInput
                            .invokeMethod("TextInput.show");
                      },
                    );
                  } else {
                    await SystemChannels.textInput
                        .invokeMethod("TextInput.hide");
                    setState(() {
                      emojiShowing = true;
                    });
                  }
                },
                child: Icon(
                  emojiShowing ? Icons.keyboard : Icons.emoji_emotions_rounded,
                  color: Colors.blue,
                ),
              ),
              hintText: "Message",
            ),
          ),
        ],
      ),
    );
  }

  addEmojiToTextController({required Emoji emoji}) {
    setState(() {
      textEditingController.text = textEditingController.text + emoji.emoji;

      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
    });
  }
}
