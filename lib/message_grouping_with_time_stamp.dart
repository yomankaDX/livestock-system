import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageGroupingWithTimeStamp extends StatefulWidget {
  MessageGroupingWithTimeStamp({Key? key}) : super(key: key);

  @override
  State<MessageGroupingWithTimeStamp> createState() =>
      _MessageGroupingWithTimeStampState();
}

class _MessageGroupingWithTimeStampState
    extends State<MessageGroupingWithTimeStamp> {
  //message controller
  final messageController = TextEditingController();
  // Query dbRf = FirebaseDatabase.instance.ref().child("Sensors");

  //scroll controller
  ScrollController _scrollController = new ScrollController();

  List<MessageModel> messagesList = [
    MessageModel(
        timeStamp: DateTime.now().microsecondsSinceEpoch,
        tempreture: "74%",
        humidity: "25",
        heartbeat: "0 bmp",
        magnitude: "42",
        location: "http://maps.google.com/maps?q=loc:2.051927,45.324057",
        isMe: false),
  ];

  // function to convert time stamp to date
  static DateTime returnDateAndTimeFormat(String time) {
    var dt = DateTime.fromMicrosecondsSinceEpoch(int.parse(time.toString()));
    var originalDate = DateFormat('MM/dd/yyyy').format(dt);
    return DateTime(dt.year, dt.month, dt.day);
  }

  //function to return message time in 24 hours format AM/PM
  static String messageTime(String time) {
    var dt = DateTime.fromMicrosecondsSinceEpoch(int.parse(time.toString()));
    String difference = '';
    difference = DateFormat('jm').format(dt).toString();
    return difference;
  }

  // function to return date if date changes based on your local date and time
  static String groupMessageDateAndTime(String time) {
    var dt = DateTime.fromMicrosecondsSinceEpoch(int.parse(time.toString()));
    var originalDate = DateFormat('MM/dd/yyyy').format(dt);

    final todayDate = DateTime.now();

    final today = DateTime(todayDate.year, todayDate.month, todayDate.day);
    final yesterday =
        DateTime(todayDate.year, todayDate.month, todayDate.day - 1);
    String difference = '';
    final aDate = DateTime(dt.year, dt.month, dt.day);

    if (aDate == today) {
      difference = "Today";
    } else if (aDate == yesterday) {
      difference = "Yesterday";
    } else {
      difference = DateFormat.yMMMd().format(dt).toString();
    }

    return difference;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: [
          TextButton(
            child: Text(
              'Cancel ',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            onLongPress: () {},
          ),
        ],
        backgroundColor: Colors.white12,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '+252618301038 ',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ListView.builder(
                    controller: _scrollController,
                    reverse: false,
                    shrinkWrap: false,
                    physics: const ClampingScrollPhysics(), // ← can't
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      bool isSameDate = true;
                      String? newDate = '';

                      final DateTime date = returnDateAndTimeFormat(
                          messagesList[index].timeStamp.toString());

                      if (index == 0 && messagesList.length == 1) {
                        newDate = groupMessageDateAndTime(
                                messagesList[index].timeStamp.toString())
                            .toString();
                      } else if (index == messagesList.length - 1) {
                        newDate = groupMessageDateAndTime(
                                messagesList[index].timeStamp.toString())
                            .toString();
                      } else {
                        final DateTime date = returnDateAndTimeFormat(
                            messagesList[index].timeStamp.toString());
                        final DateTime prevDate = returnDateAndTimeFormat(
                            messagesList[index + 1].timeStamp.toString());
                        isSameDate = date.isAtSameMomentAs(prevDate);

                        if (kDebugMode) {
                          print("$date $prevDate $isSameDate");
                        }
                        newDate = isSameDate
                            ? ''
                            : groupMessageDateAndTime(messagesList[index - 1]
                                    .timeStamp
                                    .toString())
                                .toString();
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment: messagesList[index].isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            if (newDate.isNotEmpty)
                              Center(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 220, 216, 223),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(newDate),
                                      ))),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: CustomPaint(
                                painter: MessageBubble(
                                    color: messagesList[index].isMe
                                        ? const Color(0xffE3D4EE)
                                        : const Color(0xffDAF0F3),
                                    alignment: messagesList[index].isMe
                                        ? Alignment.topRight
                                        : Alignment.topLeft,
                                    tail: true),
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * .10,
                                  ),
                                  margin: messagesList[index].isMe
                                      ? const EdgeInsets.fromLTRB(7, 7, 17, 7)
                                      : const EdgeInsets.fromLTRB(17, 7, 7, 7),
                                  child: Column(
                                    children: [
                                      Padding(
                                          padding: messagesList[index].isMe
                                              ? const EdgeInsets.only(
                                                  left: 4, right: 4, bottom: 10)
                                              : const EdgeInsets.only(
                                                  left: 4,
                                                  right: 4,
                                                  bottom: 10),
                                          child: Container(
                                            child: Text(
                                              messagesList[index].tempreture,
                                              textAlign: TextAlign.left,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5!
                                                  .copyWith(
                                                      fontSize: 15,
                                                      color: messagesList[index]
                                                              .isMe
                                                          ? const Color(
                                                              0xff705982)
                                                          : const Color(
                                                              0xff677D81)),
                                            ),
                                          )),

                                      Container(
                                        child: Text(
                                          messagesList[index].humidity,
                                          textAlign: TextAlign.left,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(
                                                  fontSize: 15,
                                                  color: messagesList[index]
                                                          .isMe
                                                      ? const Color(0xff705982)
                                                      : const Color(
                                                          0xff677D81)),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          messagesList[index].heartbeat,
                                          textAlign: TextAlign.left,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(
                                                  fontSize: 15,
                                                  color: messagesList[index]
                                                          .isMe
                                                      ? const Color(0xff705982)
                                                      : const Color(
                                                          0xff677D81)),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          messagesList[index].magnitude,
                                          textAlign: TextAlign.left,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(
                                                  fontSize: 15,
                                                  color: messagesList[index]
                                                          .isMe
                                                      ? const Color(0xff705982)
                                                      : const Color(
                                                          0xff677D81)),
                                        ),
                                      ),
                                      // Container(
                                      //   child: Text(
                                      //     messagesList[index].location,
                                      //     textAlign: TextAlign.left,
                                      //     style: Theme.of(context)
                                      //         .textTheme
                                      //         .headline5!
                                      //         .copyWith(
                                      //             fontSize: 15,
                                      //             color: messagesList[index]
                                      //                     .isMe
                                      //                 ? const Color(0xff705982)
                                      //                 : const Color(
                                      //                     0xff677D81)),
                                      //   ),
                                      // ),
                                      // Container(
                                      //     height: double.infinity,
                                      //     child: FirebaseAnimatedList(
                                      //         query: dbRf,
                                      //         itemBuilder: ((context, snapshot,
                                      //             animation, index) {
                                      //           Map Sensors =
                                      //               snapshot.value as Map;
                                      //           Sensors[Key] = snapshot.key;
                                      //           return messagesList();
                                      //         }))),

                                      Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Text(
                                            messageTime(messagesList[index]
                                                    .timeStamp
                                                    .toString())
                                                .toString(),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 10),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 60,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: messageController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 8,
                          minLines: 1,
                          decoration: InputDecoration(
                            hintText: 'Send a message...',
                            hintStyle: TextStyle(color: Colors.black),
                            // fillColor: Colors.white,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1),
                                borderRadius: BorderRadius.circular(25)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          MessageModel model = MessageModel(
                              timeStamp: DateTime.now().microsecondsSinceEpoch,
                              tempreture: messageController.text.toString(),
                              humidity: messageController.text.toString(),
                              heartbeat: messageController.text.toString(),
                              magnitude: messageController.text.toString(),
                              location: messageController.text.toString(),
                              isMe: true);
                          // since we are reversing the list so we are inserting date at 0 index to append the list
                          messagesList.insert(0, model);
                          messageController.clear();
                          setState(() {});
                          _scrollController.animateTo(
                            _scrollController.position.minScrollExtent,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 500),
                          );
                        },
                        child: const CircleAvatar(
                          child: Icon(Icons.send),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// model for messages
class MessageModel {
  int timeStamp;
  String tempreture;
  String humidity;
  String heartbeat;
  String magnitude;
  String location;
  bool isMe;
  MessageModel(
      {required this.timeStamp,
      required this.tempreture,
      required this.isMe,
      required this.humidity,
      required this.heartbeat,
      required this.magnitude,
      required this.location});
}

// creating bubble
class MessageBubble extends CustomPainter {
  final Color color;
  final Alignment alignment;
  final bool tail;

  MessageBubble({
    required this.color,
    required this.alignment,
    required this.tail,
  });

  final double _radius = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    var h = size.height;
    var w = size.width;
    if (alignment == Alignment.topRight) {
      if (tail) {
        var path = Path();

        /// starting point
        path.moveTo(_radius * 2, 0);

        /// top-left corner
        path.quadraticBezierTo(0, 0, 0, _radius * 1.5);

        /// left line
        path.lineTo(0, h - _radius * 1.5);

        /// bottom-left corner
        path.quadraticBezierTo(0, h, _radius * 2, h);

        /// bottom line
        path.lineTo(w - _radius * 3, h);

        /// bottom-right bubble curve
        path.quadraticBezierTo(
            w - _radius * 1.5, h, w - _radius * 1.5, h - _radius * 0.6);

        /// bottom-right tail curve 1
        path.quadraticBezierTo(w - _radius * 1, h, w, h);

        /// bottom-right tail curve 2
        path.quadraticBezierTo(
            w - _radius * 0.8, h, w - _radius, h - _radius * 1.5);

        /// right line
        path.lineTo(w - _radius, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w - _radius, 0, w - _radius * 3, 0);

        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      } else {
        var path = Path();

        /// starting point
        path.moveTo(_radius * 2, 0);

        /// top-left corner
        path.quadraticBezierTo(0, 0, 0, _radius * 1.5);

        /// left line
        path.lineTo(0, h - _radius * 1.5);

        /// bottom-left corner
        path.quadraticBezierTo(0, h, _radius * 2, h);

        /// bottom line
        path.lineTo(w - _radius * 3, h);

        /// bottom-right curve
        path.quadraticBezierTo(w - _radius, h, w - _radius, h - _radius * 1.5);

        /// right line
        path.lineTo(w - _radius, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w - _radius, 0, w - _radius * 3, 0);

        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      }
    } else {
      if (tail) {
        var path = Path();

        /// starting point
        path.moveTo(_radius * 3, 0);

        /// top-left corner
        path.quadraticBezierTo(_radius, 0, _radius, _radius * 1.5);

        /// left line
        path.lineTo(_radius, h - _radius * 1.5);
        // bottom-right tail curve 1
        path.quadraticBezierTo(_radius * .8, h, 0, h);

        /// bottom-right tail curve 2
        path.quadraticBezierTo(
            _radius * 1, h, _radius * 1.5, h - _radius * 0.6);

        /// bottom-left bubble curve
        path.quadraticBezierTo(_radius * 1.5, h, _radius * 3, h);

        /// bottom line
        path.lineTo(w - _radius * 2, h);

        /// bottom-right curve
        path.quadraticBezierTo(w, h, w, h - _radius * 1.5);

        /// right line
        path.lineTo(w, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w, 0, w - _radius * 2, 0);
        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      } else {
        var path = Path();

        /// starting point
        path.moveTo(_radius * 3, 0);

        /// top-left corner
        path.quadraticBezierTo(_radius, 0, _radius, _radius * 1.5);

        /// left line
        path.lineTo(_radius, h - _radius * 1.5);

        /// bottom-left curve
        path.quadraticBezierTo(_radius, h, _radius * 3, h);

        /// bottom line
        path.lineTo(w - _radius * 2, h);

        /// bottom-right curve
        path.quadraticBezierTo(w, h, w, h - _radius * 1.5);

        /// right line
        path.lineTo(w, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w, 0, w - _radius * 2, 0);
        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

/// {@template custom_rect_tween}
/// Linear RectTween with a [Curves.easeOut] curve.
///
/// Less dramatic that the regular [RectTween] used in [Hero] animations.
/// {@endtemplate}
class CustomRectTween extends RectTween {
  /// {@macro custom_rect_tween}
  CustomRectTween({
    required Rect begin,
    required Rect end,
  }) : super(begin: begin, end: end);

  @override
  Rect lerp(double t) {
    final elasticCurveValue = Curves.easeOut.transform(t);
    return Rect.fromLTRB(
      lerpDouble(begin!.left, end!.left, elasticCurveValue)!,
      lerpDouble(begin!.top, end!.top, elasticCurveValue)!,
      lerpDouble(begin!.right, end!.right, elasticCurveValue)!,
      lerpDouble(begin!.bottom, end!.bottom, elasticCurveValue)!,
    );
  }
}
