import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  static const routeName = '/quiz';

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int questionIndex = 0;
  int score = 0;
  bool isAnswered = false;

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          category,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(category)
            .doc((questionIndex + 1).toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).secondaryHeaderColor,
              ),
            );
          }
          final documents = snapshot.data!.data();
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  documents!['question'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ...documents['options'].keys.toList().map(
                  (option) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: ListTile(
                        title: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          if (!isAnswered) {
                            if (option == documents['correctAnswer']) {
                              score++;
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Correct',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: const Text(
                                      'You got it right!',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Wrong',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: const Text(
                                      'You got it wrong!',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            setState(() {
                              isAnswered = true;
                            });
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isAnswered) {
            if (questionIndex < 4) {
              setState(() {
                questionIndex++;
                isAnswered = false;
              });
            } else {
              Navigator.of(context).pushReplacementNamed(
                ResultScreen.routeName,
                arguments: score,
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Please select an option.',
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 1),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        child: const Icon(Icons.arrow_forward_ios),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
