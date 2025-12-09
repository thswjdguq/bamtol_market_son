import '../model/chat_room_model.dart';

class ChatRepository {
  final List<ChatRoomModel> _rooms = [
    ChatRoomModel(
      id: '1',
      partnerName: '김제주',
      lastMessage: '네 내일 가능합니다',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
    ),
    ChatRoomModel(
      id: '2',
      partnerName: '이한라',
      lastMessage: '가격 깎아주세요',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  Future<List<ChatRoomModel>> getChatRooms() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_rooms);
  }
}
