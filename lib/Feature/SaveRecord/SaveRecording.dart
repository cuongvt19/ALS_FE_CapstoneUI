import 'dart:io';
import 'package:capstone_ui/Bloc/authenticate/authenticate_bloc.dart';
import 'package:capstone_ui/Constant/constant.dart';
import 'package:capstone_ui/Feature/SaveRecord/feature_buttons_view_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../Bloc/create_record/create_record_bloc.dart';
import 'feature_buttons_view.dart';
import 'home_view.dart';

class SaveRecording extends StatefulWidget {
  final Function(String)? validators;
  const SaveRecording({Key? key, this.validators}) : super(key: key);

  @override
  State<SaveRecording> createState() => _SaveRecordingState();
}

class _SaveRecordingState extends State<SaveRecording> {
  late bool _isUploading;
  TextEditingController textEditingController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();
  List<bool> isSelected = [false, true];
  List<Reference> references = [];
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String valueText = '';
  String titleText = '';
  String _textSpeech = '';

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formTextKey = GlobalKey<FormState>();
  GlobalKey<FormFieldState> titleKey = GlobalKey();
  GlobalKey<FormFieldState> titleTextKey = GlobalKey();
  GlobalKey<FormFieldState> contentTextKey = GlobalKey();
  void onListen() async {
    bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'));

    if (!_isListening) {
      if (available) {
        setState(() {
          _isListening = false;
          _speech.listen(
            onResult: (val) => setState(() {
              _textSpeech = val.recognizedWords;
              titleController.text = val.recognizedWords;
            }),
          );
        });
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
        print("Stop Lítening");
      });
    }
  }

  void stopListen() {
    _speech.stop();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    isSelected = [false, true];
    _onUploadComplete();
    _isUploading = false;
    _speech = stt.SpeechToText();
    titleController.text = '';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _speech.cancel();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticateBloc, AuthenticateState>(
      builder: (context, state2) {
        return BlocConsumer<CreateRecordBloc, CreateRecordState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Center(
                  child: Scaffold(
                appBar: AppBar(
                    elevation: 0.0,
                    centerTitle: true,
                    title: Text('Tạo bản ghi', style: TextStyle(fontSize: 26)),
                    backgroundColor: greenALS,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeViewRecord()),
                              )),
                    )),
                body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Bạn sẽ tạo bản ghi bằng:',
                          style: TextStyle(
                              fontSize: 26.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: ToggleButtons(
                          fillColor: Colors.grey,
                          borderWidth: 2,
                          selectedBorderColor: greenALS,
                          selectedColor: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Văn bản',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Giọng nói',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          ],
                          onPressed: (int index) {
                            setState(() {
                              for (int i = 0; i < isSelected.length; i++) {
                                isSelected[i] = i == index;
                              }
                            });
                          },
                          isSelected: isSelected,
                        ),
                      ),
                      if (isSelected[0])
                        getGraphWidget(state2.userId.toString()),
                      //văn bản
                      if (isSelected[1])
                        getGraphWidget2(state2.userId.toString()), //giọng nói
                    ],
                  ),
                ),
              ));
            });
      },
    );
  }

  Future<void> _onUploadComplete() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    ListResult listResult =
        await firebaseStorage.ref().child('upload-voice-firebase').list();
    setState(() {
      references = listResult.items;
    });
  }

  Widget getGraphWidget(String userId) {
    return BlocConsumer<CreateRecordBloc, CreateRecordState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Expanded(
          child: Form(
            key: formTextKey,
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        style: TextStyle(fontSize: 24),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: titleTextKey,
                        textCapitalization: TextCapitalization.words,
                        maxLength: 20,
                        decoration: InputDecoration(
                            // labelText: _textSpeech,

                            labelText: 'Tên bản ghi',
                            suffixIcon: Icon(
                              Icons.description,
                              color: greenALS,
                            ),
                            border: myinputborder(),
                            enabledBorder: myinputborder(),
                            focusedBorder: myfocusborder(),
                            labelStyle: TextStyle(fontSize: 24.0),
                            contentPadding:
                                EdgeInsets.only(left: 15, top: 25, bottom: 25)),
                        validator: (val) => validateTitleText(val!),
                        onChanged: (value) {
                          setState(() {
                            titleText = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        style: TextStyle(fontSize: 24),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: contentTextKey,
                        maxLines: 2,
                        decoration: InputDecoration(
                            labelText: "Nhập nội dung",
                            border: myinputborder(),
                            enabledBorder: myinputborder(),
                            focusedBorder: myfocusborder(),
                            labelStyle: TextStyle(fontSize: 24.0),
                            contentPadding:
                                EdgeInsets.only(left: 15, top: 25, bottom: 25)),
                        validator: (val) => validateContentText(val!),
                        onChanged: (value) {
                          setState(() {
                            valueText = value;
                          });
                        },
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: FeatureButtonsViewTextFunction(
                          speakText: valueText,
                          titleText: titleText,
                          formKey: formTextKey,
                          fieldTextKey: titleTextKey,
                          fieldContentTextKey: contentTextKey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getGraphWidget2(String userId) {
    return Expanded(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                style: TextStyle(fontSize: 24),
                key: titleKey,
                maxLength: 20,
                textCapitalization: TextCapitalization.words,
                controller: titleController,
                decoration: InputDecoration(
                    labelText: 'Tên bản ghi',
                    suffixIcon: IconButton(
                      onPressed: (() {
                        onListen();
                      }),
                      icon: Icon(
                        Icons.mic,
                        size: 35,
                      ),
                    ),
                    border: myinputborder(),
                    enabledBorder: myinputborder(),
                    focusedBorder: myfocusborder(),
                    labelStyle: TextStyle(fontSize: 24.0),
                    contentPadding:
                        EdgeInsets.only(left: 15, top: 25, bottom: 25)),
                onChanged: (value) {
                  setState(() {
                    _textSpeech = value;
                  });
                },
                validator: (val) => validateTitle(val!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FeatureButtonsView(
                  onUploadComplete: _onUploadComplete,
                  titleText: _textSpeech,
                  userId: userId,
                  formKey: formKey,
                  fieldKey: titleKey),
            ),
          ],
        ),
      ),
    );
  }

  String? validateTitle(String title) {
    if (title == null || title.isEmpty) {
      return 'Vui lòng điền tên bản ghi';
    } else if (title.length > 20) {
      return 'Vui lòng nhập dưới 20 ký tự';
    }
    return null;
  }

  String? validateTitleText(String titleText) {
    if (titleText.isEmpty) {
      return 'Vui lòng điền tên bản ghi';
    } else if (titleText.length > 20) {
      return 'Vui lòng nhập dưới 20 ký tự';
    }
    return null;
  }

  String? validateContentText(String titleText) {
    if (titleText == null || titleText.isEmpty) {
      return 'Vui lòng nhập nội dung';
    }
    return null;
  }

  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 2,
        ));
  }

  OutlineInputBorder myfocusborder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: greenALS,
          width: 2,
        ));
  }

  // void validate() {
  //   if (formKey.currentState!.validate()) {
  //     print('Validated');
  //   } else {
  //     print('Not validated');
  //   }
  // }
}
