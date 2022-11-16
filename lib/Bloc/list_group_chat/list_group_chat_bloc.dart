import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../Model/getListPost_model.dart';
import '../../Model/groupChat_model.dart';
import '../../services/api_groupchat.dart';

part 'list_group_chat_event.dart';
part 'list_group_chat_state.dart';

class ListGroupChatBloc extends Bloc<ListGroupChatEvent, ListGroupChatState> {
 final GroupChatService _GroupChatService;
 
 
  ListGroupChatBloc(this._GroupChatService) : super(GroupChatBlocInitial()) {
    on<LoadListGroupChatEvent>((event, emit) async {
      // TODO: implement event handler
      // PostByIdReQuestModel PostByIdReQuestModel = PostByIdReQuestModel(userId: userId)
      final list2= await _GroupChatService.getAllGroupChat(event.userId);
      emit(GroupChatLoadedState(list2));
    });
    on<LoadListGroupChatByUserIdEvent>((event, emit) async {
      // TODO: implement event handler
      // PostByIdReQuestModel PostByIdReQuestModel = PostByIdReQuestModel(userId: userId)
      final list1= await _GroupChatService.getAllGroupChatUserJoin(event.userId);
      emit(GroupChatHasJoinLoadedState(list1));
    });
    
}
}
