import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(QuizApp());

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 94, 39, 243),
        primaryColor: Colors.blueAccent,
      ),
      debugShowCheckedModeBanner: false,
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _score = 0;
  int _questionIndex = 0;
  int _timeLeft = 30;
  bool _isTimeOver = false;
  Timer _timer = Timer(Duration.zero, () {});

  final List<Map<String, Object>> _questions = [
    {
      'question': 'Who is the all-time leading scorer in NBA history?',
      'answers': [
        {'text': 'Stephen Curry', 'isCorrect': false},
        {'text': 'LeBron James', 'isCorrect': true},
        {'text': 'Kevin Durant', 'isCorrect': false},
        {'text': 'Kyrie Irving', 'isCorrect': false},
      ]
    },
    {
      'question': 'Which player is known as "His Airness"?',
      'answers': [
        {'text': 'Trae young', 'isCorrect': false},
        {'text': 'LeBron James', 'isCorrect': false},
        {'text': 'Michael Jordan', 'isCorrect': true},
        {'text': 'Stephen Curry', 'isCorrect': false},
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        setState(() => _isTimeOver = true);
        _timer.cancel();
      }
    });
  }

  void _answerQuestion(bool isCorrect) {
    if (isCorrect) setState(() => _score++);
    if (_questionIndex < _questions.length - 1) {
      setState(() => _questionIndex++);
    } else {
      setState(() => _isTimeOver = true);
      _timer.cancel();
    }
  }

  void _restartQuiz() {
    setState(() {
      _score = 0;
      _questionIndex = 0;
      _timeLeft = 30;
      _isTimeOver = false;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearProgressIndicator(
                value: _timeLeft / 30,
                backgroundColor: Colors.black,
                valueColor: const AlwaysStoppedAnimation(Colors.white),
              ),
              const SizedBox(height: 20),
              if (_isTimeOver)
                Column(
                  children: [
                    const Text(
                      'Time Over!',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Your Score: $_score',
                      style: const TextStyle(fontSize: 24, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 24),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        fixedSize: const Size(200, 50),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: _restartQuiz,
                      child: const Text('Restart Quiz'),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Text(
                      'Time Left: $_timeLeft',
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _questions[_questionIndex]['question'] as String,
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ...(_questions[_questionIndex]['answers']
                            as List<Map<String, Object>>)
                        .map((answer) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(200, 50),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => _answerQuestion(
                                    answer['isCorrect'] as bool),
                                child: Text(answer['text'] as String),
                              ),
                            ))
                        .toList(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }
}
