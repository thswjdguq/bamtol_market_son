import 'package:get/get.dart';
import '../model/chat_room_model.dart';
import '../repository/chat_repository.dart';

class ChatController extends GetxController {
  final ChatRepository _repository = ChatRepository();
  RxList<ChatRoomModel> chatRooms = RxList<ChatRoomModel>();
  RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    loadChatRooms();
  }

  Future<void> loadChatRooms() async {
    isLoading(true);
    try {
      final loaded = await _repository.getChatRooms();
      chatRooms.assignAll(loaded);
    } finally {
      isLoading(false);
    }
  }
}
