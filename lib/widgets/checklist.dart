import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pszczoly_v3/models/filled_checklist.dart';
import 'package:pszczoly_v3/models/question.dart';
import 'package:pszczoly_v3/models/question_answer.dart';
import 'package:pszczoly_v3/providers/hive_list_provider.dart';
import 'package:pszczoly_v3/providers/simple_providers.dart';
import 'package:pszczoly_v3/widgets/percentage_slider.dart';

class Checklist extends ConsumerStatefulWidget {
  Checklist({Key? key, this.hiveId, this.checklistDate})
      : checklistId = generateUniqueId(),
        super(key: key);

  final hiveId;
  final checklistDate;

  factory Checklist.newInstance() {
    return Checklist(key: UniqueKey());
  }

  final String checklistId;
  final List<QuestionAnswer> questionAnswerList = [];

  void addOrUpdateQuestionAnswer(QuestionAnswer questionAnswer) {
    final existingIndex = questionAnswerList
        .indexWhere((qa) => qa.questionId == questionAnswer.questionId);
    if (existingIndex != -1) {
      questionAnswerList[existingIndex] = questionAnswer;
    } else {
      questionAnswerList.add(questionAnswer);
    }
  }

  @override
  ConsumerState createState() => ChecklistState();
}

class ChecklistState extends ConsumerState<Checklist> {

  @override
  Widget build(BuildContext context) {
    final checklistQuestions = ref.watch(questionsProvider);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: checklistQuestions.length,
            itemBuilder: (context, index) {
              return buildQuestionCard(checklistQuestions[index]);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cofnij')),
            ElevatedButton(
                onPressed: () {
                  ref.read(databaseProvider).insertChecklist(
                      FilledChecklist(
                              hiveId: widget.hiveId,
                              checklistDate: widget.checklistDate,
                              checklistId: widget.checklistId,
                  ).toJson());
                  for (QuestionAnswer qa in widget.questionAnswerList) {
                    ref.read(databaseProvider).insertQuestionAnswer(qa.toJson());
                  }
                  ref.read(databaseProvider).printTables();
                  Navigator.of(context).pop();
                },
                child: const Text('Zapisz')),
          ],
        ),
      ],
    );
  }

  Widget buildQuestionCard(Question question) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              question.text.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ),
          buildResponseWidget(question),
        ],
      ),
    );
  }

  Widget buildResponseWidget(Question question) {
    switch (question.responseType) {
      case ResponseType.yesNo:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Switch(
            //   value: question.response,
            //   onChanged: (value) {
            //     setState(() {
            //       question.response = value;
            //     });
            //   },
            // ),
            Radio(
              value: true,
              groupValue: question.response,
              onChanged: (value) {
                setState(() {
                  question.response = value;
                });
                widget.addOrUpdateQuestionAnswer(QuestionAnswer(
                    checklistId: widget.checklistId,
                    questionId: question.id,
                    answerType: question.responseType,
                    answer: question.response));
              },
            ),
            const Text('Tak'),
            Radio(
              value: false,
              groupValue: question.response,
              onChanged: (value) {
                setState(() {
                  question.response = value;
                });
                widget.addOrUpdateQuestionAnswer(QuestionAnswer(
                    checklistId: widget.checklistId,
                    questionId: question.id,
                    answerType: question.responseType,
                    answer: question.response));
              },
            ),
            const Text('Nie'),
          ],
        );
      case ResponseType.text:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: const TextStyle(height: 1),
            decoration: InputDecoration(
              hintText: 'Odpowiedź',
              hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey.withOpacity(0.1),
              // Adjust color as needed
              border: InputBorder.none,
              // Remove the default border
            ),
            onChanged: (String value) {
              setState(() {
                question.response = value;
              });
              widget.addOrUpdateQuestionAnswer(QuestionAnswer(
                  checklistId: widget.checklistId,
                  questionId: question.id,
                  answerType: question.responseType,
                  answer: question.response));
            },
          ),
        );
      case ResponseType.percentage:
        return PercentageSlider();
      default:
        return Container(); // Return an empty container for unknown type
    }
  }
}
