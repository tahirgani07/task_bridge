import 'package:flutter/material.dart';
import 'package:task_bridge/models/database/database.dart';
import 'package:task_bridge/models/quiz_model/quiz_model.dart';
import 'package:task_bridge/others/my_alerts/show_alert.dart';
import 'package:task_bridge/others/my_colors.dart';
import 'package:task_bridge/screens/authentication/auth_manager.dart';

class QuizScreen extends StatefulWidget {
  final String uid;
  final List<String> tags;
  final String language;
  QuizScreen({
    required this.uid,
    required this.tags,
    required this.language,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = [];
  List<String> _selectedOptions = [];
  int noOfQuestions = 6;
  bool loading = true;

  @override
  void initState() {
    for (int i = 0; i < noOfQuestions; i++) {
      _selectedOptions.add("");
    }

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    _questions = await Database().getRandomQuesions(
      tags: widget.tags,
      language: widget.language,
      noOfQuestions: noOfQuestions,
    );
    setState(() {
      loading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          _onBackBtnPress();
          return false;
        },
        child: Scaffold(
          backgroundColor: MyColor.subtleBg,
          body: Column(
            children: [
              loading
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            forceElevated: true,
                            automaticallyImplyLeading: false,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            floating: false,
                            expandedHeight: 80,
                            flexibleSpace: FlexibleSpaceBar(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Quiz",
                                  ),
                                  InkWell(
                                    onTap: _submitQuiz,
                                    child: Material(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(3),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 4,
                                        ),
                                        child: Text(
                                          "Submit",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: MyColor.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              centerTitle: true,
                            ),
                            backgroundColor: MyColor.primaryColor,
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: List.generate(
                                  _questions.length,
                                  (ind) {
                                    Question q = _questions[ind];
                                    return Column(
                                      children: [
                                        // Questions
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Q${ind + 1}. ",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  "${q.question}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        _getOptionField(
                                            value: q.op1, index: ind),
                                        _getOptionField(
                                            value: q.op2, index: ind),
                                        _getOptionField(
                                            value: q.op3, index: ind),
                                        _getOptionField(
                                            value: q.op4, index: ind),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Container(
                                height: 50,
                                child: ElevatedButton(
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  onPressed: _submitQuiz,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _submitQuiz() async {
    ShowAlert.showLoadingDialog(context);
    int score = _getNoOfCorrect();
    double rating = QuizModel.calculateRatingFromScore(score, noOfQuestions);
    // print(score);
    // print(rating);
    await Database().updateRating(widget.uid, rating);
    ShowAlert.dismissLoadingDialog(context);
    Navigator.of(context).popUntil((route) => false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AuthManager(),
      ),
    );
  }

  int _getNoOfCorrect() {
    int score = 0;
    for (int i = 0; i < noOfQuestions; i++) {
      if (_selectedOptions[i] == _questions[i].answer) score++;
    }
    return score;
  }

  _onBackBtnPress() {
    ShowAlert.showWarningDialog(
        context: context,
        message: "No changes will be saved",
        secondaryBtnTitle: "Cancel",
        primaryBtnTitle: "OK",
        primaryBtnFunction: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
  }

  _getOptionField({
    required String value,
    required int index,
  }) {
    if (value.isEmpty) return SizedBox();
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Radio<String>(
          value: value,
          groupValue: _selectedOptions[index],
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _selectedOptions[index] = val;
              });
            }
          },
        ),
        Flexible(
            child: Text(
          "$value",
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[900],
          ),
        )),
      ],
    );
  }
}
