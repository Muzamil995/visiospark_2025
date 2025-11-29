import 'dart:async';
import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../services/chat_service.dart';
import '../core/config/supabase_config.dart';
import '../core/utils/logger.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();

  List<ChatRoomModel> _chatRooms = [];
  ChatRoomModel? _currentRoom;
  List<MessageModel> _messages = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<MessageModel>? _messageSubscription;

  List<ChatRoomModel> get chatRooms => _chatRooms;
  ChatRoomModel? get currentRoom => _currentRoom;
  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadChatRooms() async {
    AppLogger.info('Loading chat rooms');
    _isLoading = true;
    notifyListeners();

    try {
      _chatRooms = await _chatService.getChatRooms();
      _error = null;
      AppLogger.success('Loaded ${_chatRooms.length} chat rooms');
    } catch (e) {
      AppLogger.error('Load chat rooms failed', e);
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<ChatRoomModel?> startDirectChat(String otherUserId) async {
    AppLogger.info('Starting direct chat with: $otherUserId');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final room = await _chatService.getOrCreateDirectChat(otherUserId);
      if (room != null) {
        if (!_chatRooms.any((r) => r.id == room.id)) {
          _chatRooms.insert(0, room);
        }
        _currentRoom = room;
        AppLogger.success('Direct chat started: ${room.id}');
      }
      _isLoading = false;
      notifyListeners();
      return room;
    } catch (e) {
      AppLogger.error('Start direct chat failed', e);
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<ChatRoomModel?> createGroupChat({
    required String name,
    required List<String> memberIds,
  }) async {
    AppLogger.info('Creating group chat: $name');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final room = await _chatService.createGroupChat(
        name: name,
        memberIds: memberIds,
      );
      if (room != null) {
        _chatRooms.insert(0, room);
        _currentRoom = room;
        AppLogger.success('Group chat created: ${room.id}');
      }
      _isLoading = false;
      notifyListeners();
      return room;
    } catch (e) {
      AppLogger.error('Create group chat failed', e);
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> openChatRoom(ChatRoomModel room) async {
    AppLogger.info('Opening chat room: ${room.id}');
    _currentRoom = room;
    _messages = [];
    notifyListeners();

    await loadMessages();
    _subscribeToMessages();
    await _chatService.markMessagesAsRead(room.id);
  }

  Future<void> loadMessages() async {
    if (_currentRoom == null) return;

    AppLogger.debug('Loading messages for room: ${_currentRoom!.id}');
    _isLoading = true;
    notifyListeners();

    try {
      _messages = await _chatService.getMessages(_currentRoom!.id);
      _error = null;
      AppLogger.info('Loaded ${_messages.length} messages');
    } catch (e) {
      AppLogger.error('Load messages failed', e);
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void _subscribeToMessages() {
    if (_currentRoom == null) return;

    AppLogger.debug('Subscribing to messages: ${_currentRoom!.id}');
    _messageSubscription?.cancel();
    _messageSubscription = _chatService
        .subscribeToMessages(_currentRoom!.id)
        .listen((message) {
      if (!_messages.any((m) => m.id == message.id)) {
        AppLogger.debug('New message received: ${message.id}');
        _messages.add(message);
        notifyListeners();
      }
    });
  }

  Future<bool> sendMessage({
    required String content,
    String messageType = 'text',
    String? fileUrl,
  }) async {
    if (_currentRoom == null) return false;

    AppLogger.info('Sending message to room: ${_currentRoom!.id}');
    try {
      final message = await _chatService.sendMessage(
        roomId: _currentRoom!.id,
        content: content,
        messageType: messageType,
        fileUrl: fileUrl,
      );

      if (message != null) {
        _messages.add(message);
        AppLogger.success('Message sent: ${message.id}');
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      AppLogger.error('Send message failed', e);
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void closeChatRoom() {
    AppLogger.info('Closing chat room');
    _messageSubscription?.cancel();
    _messageSubscription = null;
    _chatService.unsubscribe();
    _currentRoom = null;
    _messages = [];
    notifyListeners();
  }

  String getRoomDisplayName(ChatRoomModel room) {
    return room.getDisplayName(SupabaseConfig.currentUserId ?? '');
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _chatService.unsubscribe();
    super.dispose();
  }
}
