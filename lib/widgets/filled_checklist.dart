import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pszczoly_v3/models/question.dart';
import 'package:pszczoly_v3/models/question_answer.dart';
import 'package:pszczoly_v3/providers/hive_list_provider.dart';
import 'package:pszczoly_v3/data/checklist_questions_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilledChecklistDisplay extends ConsumerStatefulWidget {
  const FilledChecklistDisplay({super.key, required this.checklistId});

  final String checklistId;

  @override
  ConsumerState createState() => ChecklistState();
}

class ChecklistState extends ConsumerState<FilledChecklistDisplay> {

  late List<QuestionAnswer> questionAnswerForAChecklist;

  @override
  Widget build(BuildContext context) {
    Future<List<Map<String, dynamic>>> questionAnswersList = ref
        .read(databaseProvider)
        .getQuestionAnswersForChecklist(widget.checklistId);

    final Map<String, QuestionAnswer> defaultAnswerMap = {
      'N/A': QuestionAnswer(
        questionId: 'N/A',
        answerType: null,
        checklistId: 'N/A',
        answer: AppLocalizations.of(context)!.noData,
        questionAnswerId: 'N/A',
      ),
    };

    String formatAnswer(QuestionAnswer qa) {
      print('Processing answer: ${qa.answerType}, ${qa.answer}');
      switch (qa.answerType) {
        case 'ResponseType.yesNo':
          return qa.answer == 'true' ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no;
        case 'ResponseType.percentage':
          return '${double.parse(qa.answer)}%';
        default:
          return qa.answer;
      }
    }

    return FutureBuilder(
      future: questionAnswersList,
      builder: (context, snapshot) {
        final checklistQuestions1 = getChecklistQuestions(context);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.emptyChecklist,
              textAlign: TextAlign.center,
            ),
          );
        } else {
          questionAnswerForAChecklist = snapshot.data!
              .map((row) => QuestionAnswer(
                    questionId: row['questionId'] as String,
                    answerType: row['answerType'] as dynamic,
                    checklistId: row['checklistId'] as String,
                    answer: row['answer'] as dynamic,
                    questionAnswerId: row['questionAnswerId'] as String,
                  ))
              .toList();
        }

        return ListView.builder(itemCount: checklistQuestions1.length, itemBuilder: (context, index) {
          Question currentQuestion = checklistQuestions1[index];
          QuestionAnswer? currentAnswer = questionAnswerForAChecklist.firstWhere(
                (answer) => answer.questionId == currentQuestion.id,
            orElse: () => defaultAnswerMap['N/A']!,
          );
          return ListTile(
            title: Text(currentQuestion.text),
            subtitle: Text(formatAnswer(currentAnswer), style: TextStyle(color: currentAnswer.answer == AppLocalizations.of(context)!.noData ? Colors.grey[300] : null),),
          );
        });
        //Second approach - displaying only the answered questions - need to choose which one id preffered
        // return ListView.builder(
        //   itemCount: min(
        //       checklistQuestions1.length, questionAnswerForAChecklist.length),
        //   itemBuilder: (context, index) {
        //     QuestionAnswer currentAnswer = questionAnswerForAChecklist[index];
        //     Question currentQuestion = checklistQuestions1.firstWhere(
        //         (question) => question.id == currentAnswer.questionId);
        //     return ListTile(
        //       title: Text(currentQuestion.text,
        //           style: const TextStyle(fontWeight: FontWeight.bold)),
        //       subtitle: Text(currentAnswer.answer),
        //     );
        //   },
        // );
      },
    );
  }
}
