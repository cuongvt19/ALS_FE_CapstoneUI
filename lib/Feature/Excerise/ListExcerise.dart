import 'dart:math';
import 'package:capstone_ui/Bloc/authenticate/authenticate_bloc.dart';
import 'package:capstone_ui/Bloc/categoryExercise/category_exercise_bloc.dart';
import 'package:capstone_ui/Bloc/session/session_bloc.dart';
import 'package:capstone_ui/Constant/constant.dart';
import 'package:capstone_ui/Feature/CategoryExercise/CustomCategoryList.dart';
import 'package:capstone_ui/Feature/Excerise/ListExerciseByName.dart';
import 'package:capstone_ui/Feature/Session/session_detail_screen.dart';
import 'package:capstone_ui/Feature/Session/session_exercise.dart';
import 'package:capstone_ui/Feature/Session/sessions_screen.dart';
import 'package:capstone_ui/Model/session_model.dart';
import 'package:capstone_ui/services/api_CategoryExercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../Components/BottomNavBar/bottom_nav_bar.dart';
import 'view_all_exercise.dart';

class ListExcerise extends StatefulWidget {
  const ListExcerise({Key? key}) : super(key: key);

  @override
  State<ListExcerise> createState() => _ListExceriseState();
}

class _ListExceriseState extends State<ListExcerise> {
  String outputText = 'Tìm kiếm';
  final SpeechToText speech = SpeechToText();
  bool _hasSpeech = false;
  String _currentLocaleId = 'vi_VN';
  var categoriesOfExercise;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    context.read<SessionBloc>().add(SessionEvent.getSessionHistory(
        context.read<AuthenticateBloc>().state.userId));
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => CategoryExerciseBlocBloc(
                  RepositoryProvider.of<CategoryExerciseService>(context))
                ..add(LoadCategoryExerciseEvent())),
        ],
        child: Scaffold(
          bottomNavigationBar: MyBottomNavBar(
              // ignore: unnecessary_this
              // index: this.index,
              ),
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: greenALS,
            title: Text(
              'Bài tập',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                ),
                SizedBox(
                  child: Row(
                    children: [
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          showSearch(
                              context: context,
                              delegate: SearchExercise(hintText: 'Tìm kiếm'));
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: size.height / 15,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(22)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  child: Text(
                                    outputText,
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                                Icon(Icons.search)
                              ],
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ButtonCreateEx(),
                      SizedBox(
                        width: 5,
                      ),
                      GetSessionsButton(),
                    ],
                  ),
                ),
                WidgetEx1(), // Lich su
                Expanded(
                  child: BlocBuilder<SessionBloc, SessionState>(
                      builder: (context, state) {
                    if (state.history != null) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.history!.length,
                        itemBuilder: (context, index) {
                          return buildCardHistory(
                              state.history![index], context);
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
                ),
                WidgetEx2(), //Phan Loai/Xem tat ca
                Expanded(
                  child: BlocBuilder<CategoryExerciseBlocBloc,
                      CategoryExerciseBlocState>(builder: (context, state) {
                    if (state is CategoryExerciseLoadedState) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.list.length,
                        itemBuilder: (context, index) {
                          // setState(() {
                          //   categoriesOfExercise=state.list;
                          // });
                          return CustomCategoryList(state.list[index], context);
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
                ),
              ],
            ),
          ),
        ));

    ;
  }
}

class WidgetEx2 extends StatelessWidget {
  const WidgetEx2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Phân loại',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ViewAll()));
            },
            child: Text(
              'Xem tất cả',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetEx1 extends StatelessWidget {
  const WidgetEx1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Lịch sử luyện tập',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonCreateEx extends StatelessWidget {
  const ButtonCreateEx({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SessionExercise()));
          },
          label: Text(
            'Tạo buổi tập',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: Icon(Icons.add),
          style: ElevatedButton.styleFrom(
            primary: greenALS,
            padding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

class GetSessionsButton extends StatelessWidget {
  const GetSessionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: BlocBuilder<AuthenticateBloc, AuthenticateState>(
            builder: (context, state) {
              return Container(
                child: ElevatedButton(
                  child: Text(
                    "Buổi tập của bạn",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    context
                        .read<SessionBloc>()
                        .add(SessionEvent.getSessionsByUserId(state.userId));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SessionsScreen()));
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

Widget buildCardHistory(
  GetSessionHistoryResponseModel history,
  BuildContext context,
) =>
    Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          //vertical: 20 / 2,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.15,
          decoration: BoxDecoration(
            color: greenALS.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SessionDetail(details: history.sessionDetail!)));
              },
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.33,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tập Luyện",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.003,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_outlined,
                              color: Colors.black45,
                              size: 25,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            Text(
                              //state.details!.length.toString() + ' exercises',
                              history.sessionDetail!.length.toString() +
                                  " Bài tập",
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 18),
                            )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005,
                        ),
                        Text(
                          "Kết thúc vào ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          DateFormat.yMd()
                              .format(history.endTime!.toLocal())
                              .toString(),
                        ),
                        Text(
                          DateFormat.jm()
                              .format(history.endTime!.toLocal())
                              .toString(),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Text(
                          "Thời lượng ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          history.endTime!
                                  .difference(history.startTime!)
                                  .inHours
                                  .toString()
                                  .padLeft(2, "0") +
                              ":" +
                              history.endTime!
                                  .difference(history.startTime!)
                                  .inMinutes
                                  .remainder(60)
                                  .toString()
                                  .padLeft(2, "0") +
                              ":" +
                              history.endTime!
                                  .difference(history.startTime!)
                                  .inSeconds
                                  .remainder(60)
                                  .toString()
                                  .padLeft(2, "0"),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

class SpeechStatusWidget extends StatelessWidget {
  const SpeechStatusWidget({
    Key? key,
    required this.speech,
  }) : super(key: key);
  final SpeechToText speech;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: [
          Center(
            child: speech.isListening
                ? Text(
                    "Đang nghe...",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.white),
                  )
                : Text(
                    '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }
}
