import 'package:flutter/material.dart';
import 'package:lift_app/app/di.dart';
import 'package:lift_app/data/mapper/mappers.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/domain/usecases/messages_usecases/create_chat_usecase.dart';
import 'package:lift_app/domain/usecases/messages_usecases/send_message_usecase.dart';
import 'package:lift_app/presentations/home/drawer/drawer_view_model.dart';
import 'package:lift_app/presentations/utils/socket.dart';

import '../../../domain/usecases/messages_usecases/get_messages_usecase.dart';

class MessagesViewModel extends ChangeNotifier {
  final CreateChatUsecase _createChatUsecase = instance<CreateChatUsecase>();
  final SendMessageUsecase _sendMessageUsecase = instance<SendMessageUsecase>();
  final GetMessagesUsecase _getMessagesUsecase = instance<GetMessagesUsecase>();
  List<MessageObjectModel> messagesList = [];
  ChatObjectModel chatObjectModel =
      ChatObjectModel(EMPTY, EMPTY, [], EMPTY, EMPTY, EMPTY);

  bool isGetData = false;
  Future<void> createChat(CreateChatRequest createChatRequest) async {
    (await _createChatUsecase.execute(createChatRequest))
        .fold((failure) => throw failure, (data) async {
      chatObjectModel = data.chatModel;
      SocketImplementation.createChatEmit(
          userId: CommonData.passengerDataModal.id);
    });
  }

  Future<void> sendMessage(SendMessageRequest sendMessageRequest) async {
    (await _sendMessageUsecase.execute(sendMessageRequest))
        .fold((failure) => throw failure, (data) async {
      messagesList.add(MessageObjectModel(
          data.sendMessageObjectModel.sendMessageId,
          data.sendMessageObjectModel.senderId,
          data.sendMessageObjectModel.chatId,
          data.sendMessageObjectModel.content));
      SocketImplementation.newMessageEmit(
          userList: data.sendMessageObjectModel.usersList);
      notifyListeners();
    });
  }

  Future<void> getMessages(GetMessagesRequest getMessagesRequest) async {
    (await _getMessagesUsecase.execute(getMessagesRequest))
        .fold((failure) => throw failure, (data) async {
      messagesList = data.messageObjectModelList;
    });
  }
}
