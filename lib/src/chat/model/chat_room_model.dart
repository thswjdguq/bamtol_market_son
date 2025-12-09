class ChatRoomModel {
  final String id;
  final String partnerName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  ChatRoomModel({
    required this.id,
    required this.partnerName,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });
}
