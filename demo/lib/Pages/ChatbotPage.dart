import 'dart:convert';

import 'package:demo/Pages/MovieDetails.dart';
import 'package:demo/config/api_config.dart';
import 'package:demo/utils/get_gernes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatbotPage extends StatefulWidget {
  final List<dynamic> movies;

  const ChatbotPage({required this.movies, super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  static const _storageKey = 'movie_chat_channels';
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  List<_ChatChannel> _channels = [];
  int _activeChannel = 0;
  bool _loading = true;
  bool _sending = false;

  _ChatChannel get _active => _channels[_activeChannel];

  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadChannels() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.getString(_storageKey);
    if (saved != null) {
      final decoded = jsonDecode(saved) as List<dynamic>;
      _channels = decoded.map((item) => _ChatChannel.fromJson(item)).toList();
    }
    if (_channels.isEmpty) {
      _channels = [_ChatChannel(name: 'New conversation')];
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _saveChannels() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _storageKey,
      jsonEncode(_channels.map((channel) => channel.toJson()).toList()),
    );
  }

  void _newChannel() {
    setState(() {
      _channels.add(_ChatChannel(name: 'New conversation'));
      _activeChannel = _channels.length - 1;
    });
    _saveChannels();
  }

  void _deleteChannel(int index) {
    if (_channels.length == 1) {
      _channels[0] = _ChatChannel(name: 'New conversation');
      _activeChannel = 0;
    } else {
      _channels.removeAt(index);
      _activeChannel = _activeChannel.clamp(0, _channels.length - 1);
    }
    setState(() {});
    _saveChannels();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _sending) return;
    _messageController.clear();
    setState(() {
      _active.messages.add(_ChatMessage(role: 'user', content: text));
      _sending = true;
      if (_active.name == 'New conversation') {
        _active.name = text.length > 28 ? '${text.substring(0, 28)}...' : text;
      }
    });
    await _saveChannels();
    _scrollToBottom();

    try {
      final response = await http
          .post(
            Uri.parse('https://router.huggingface.co/v1/chat/completions'),
            headers: {
              'Authorization': 'Bearer ${ApiConfig.huggingFaceApiKey}',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': 'Qwen/Qwen3.8-27B:featherless-ai',
              'messages': [
                {'role': 'system', 'content': _systemPrompt},
                ..._active.messages.map((message) => message.toJson()),
              ],
              'temperature': 0.7,
            }),
          )
          .timeout(const Duration(seconds: 45));
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(body['error'] ?? 'The AI service returned an error.');
      }
      final content = body['choices'][0]['message']['content'] as String;
      _active.messages.add(_ChatMessage(role: 'assistant', content: content));
    } catch (error) {
      _active.messages.add(
        _ChatMessage(
          role: 'assistant',
          content: 'I could not reach the movie assistant. ${error.toString()}',
        ),
      );
    } finally {
      await _saveChannels();
      if (mounted) setState(() => _sending = false);
      _scrollToBottom();
    }
  }

  String get _systemPrompt {
    final catalog = widget.movies
        .map((movie) {
          final genres = getGenres(movie['genre_ids'] ?? []).join(', ');
          return '${movie['title']} | ${movie['release_date']} | $genres | '
              'rating ${movie['vote_average']} | ${movie['overview']}';
        })
        .join('\n');
    return '''You are a helpful movie recommendation assistant. Only recommend movies from this catalog. Use the conversation history to understand the user's preferences. Be concise and explain why each recommendation fits. Whenever you recommend a catalog movie, include its exact title in the format [[MOVIE: exact title]]. Do not invent movies.

CATALOG:
$catalog''';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  List<Map<String, dynamic>> _recommendedMovies(String content) {
    final matches = RegExp(r'\[\[MOVIE:\s*(.*?)\]\]', caseSensitive: false)
        .allMatches(content)
        .map((match) => match.group(1)!.trim().toLowerCase())
        .toSet();
    return widget.movies
        .where(
          (movie) => matches.contains(movie['title'].toString().toLowerCase()),
        )
        .cast<Map<String, dynamic>>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(218, 0, 0, 0),
      appBar: AppBar(
        title: Text(_active.name),
        backgroundColor: Colors.purple,
        leading: const BackButton(),
        actions: [
          IconButton(
            tooltip: 'New channel',
            onPressed: _newChannel,
            icon: const Icon(Icons.add_comment_outlined),
          ),
          Builder(
            builder: (context) => IconButton(
              tooltip: 'Open chat channels',
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: SafeArea(
          child: Column(
            children: [
              const ListTile(
                leading: Icon(Icons.forum_outlined, color: Colors.white),
                title: Text(
                  'Chat channels',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _channels.length,
                  itemBuilder: (context, index) => ListTile(
                    selected: index == _activeChannel,
                    selectedTileColor: Colors.purple.withValues(alpha: 0.35),
                    leading: const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white70,
                    ),
                    title: Text(
                      _channels[index].name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      tooltip: 'Delete channel',
                      onPressed: () => _deleteChannel(index),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.white70,
                      ),
                    ),
                    onTap: () {
                      setState(() => _activeChannel = index);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: OutlinedButton.icon(
                  onPressed: _newChannel,
                  icon: const Icon(Icons.add),
                  label: const Text('New channel'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _active.messages.isEmpty
                ? const Center(
                    child: Text(
                      'Ask me what to watch tonight.',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: _active.messages.length,
                    itemBuilder: (context, index) {
                      final message = _active.messages[index];
                      final isUser = message.role == 'user';
                      final recommendations = isUser
                          ? <Map<String, dynamic>>[]
                          : _recommendedMovies(message.content);
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 680),
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser
                                ? Colors.purple[700]
                                : Colors.grey[850],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.content.replaceAll(
                                  RegExp(r'\[\[MOVIE:.*?\]\]'),
                                  '',
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  height: 1.35,
                                ),
                              ),
                              if (recommendations.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: recommendations
                                      .map(_movieLink)
                                      .toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (_sending) const LinearProgressIndicator(minHeight: 2),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Ask for a recommendation...',
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: 'Send message',
                    onPressed: _sending ? null : _sendMessage,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _movieLink(Map<String, dynamic> movie) {
    return ActionChip(
      avatar: const Icon(Icons.local_movies_outlined, size: 18),
      label: Text(movie['title'].toString()),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MovieDetails(
            name: movie['title'],
            url: movie['poster_path'],
            description: movie['overview'],
            year: movie['release_date'],
            rating: (movie['vote_average'] as num).toStringAsFixed(1),
            genres: movie['genre_ids'],
            movie: movie,
          ),
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String role;
  final String content;

  _ChatMessage({required this.role, required this.content});

  Map<String, String> toJson() => {'role': role, 'content': content};

  factory _ChatMessage.fromJson(Map<String, dynamic> json) => _ChatMessage(
    role: json['role'] as String,
    content: json['content'] as String,
  );
}

class _ChatChannel {
  String name;
  final List<_ChatMessage> messages;

  _ChatChannel({required this.name, List<_ChatMessage>? messages})
    : messages = messages ?? [];

  Map<String, dynamic> toJson() => {
    'name': name,
    'messages': messages.map((message) => message.toJson()).toList(),
  };

  factory _ChatChannel.fromJson(Map<String, dynamic> json) => _ChatChannel(
    name: json['name'] as String,
    messages: (json['messages'] as List<dynamic>)
        .map((message) => _ChatMessage.fromJson(message))
        .toList(),
  );
}
