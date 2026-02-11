import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/chat_user.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import 'chat_screen.dart';

// 🎯 CREATE GROUP SCREEN - Skype-style group creation
// Allows users to create a new group with selected members

class CreateGroupScreen extends StatefulWidget {
  final String currentUserId;

  const CreateGroupScreen({
    super.key,
    required this.currentUserId,
  });

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _searchController = TextEditingController();
  
  final List<ChatUser> _selectedMembers = [];
  File? _groupImage;
  bool _isSearching = false;
  
  @override
  void dispose() {
    _groupNameController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    
    if (pickedFile != null) {
      setState(() {
        _groupImage = File(pickedFile.path);
      });
    }
  }

  void _searchUsers(String query) {
    if (query.trim().length >= 2) {
      setState(() => _isSearching = true);
      context.read<ChatBloc>().add(SearchUsersEvent(query: query.trim()));
    }
  }

  void _addMember(ChatUser user) {
    if (!_selectedMembers.any((m) => m.id == user.id) && 
        user.id != widget.currentUserId) {
      setState(() {
        _selectedMembers.add(user);
        _searchController.clear();
        _isSearching = false;
      });
    }
  }

  void _removeMember(ChatUser user) {
    setState(() {
      _selectedMembers.removeWhere((m) => m.id == user.id);
    });
  }

  void _createGroup() {
    if (_formKey.currentState!.validate() && _selectedMembers.isNotEmpty) {
      context.read<ChatBloc>().add(CreateGroupEvent(
        name: _groupNameController.text.trim(),
        memberIds: _selectedMembers.map((m) => m.id).toList(),
        creatorId: widget.currentUserId,
        description: _descriptionController.text.trim().isNotEmpty 
            ? _descriptionController.text.trim() 
            : null,
        imagePath: _groupImage?.path,
      ));
    } else if (_selectedMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one member to the group'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0078D4),
        foregroundColor: Colors.white,
        title: const Text('New Group'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _selectedMembers.isNotEmpty ? _createGroup : null,
            child: Text(
              'Create',
              style: TextStyle(
                color: _selectedMembers.isNotEmpty 
                    ? Colors.white 
                    : Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is GroupCreated) {
            // Navigate to the new group chat
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<ChatBloc>(),
                  child: ChatScreen(
                    room: state.group,
                    currentUserId: widget.currentUserId,
                  ),
                ),
              ),
            );
          } else if (state is ChatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Stack(
          children: [
            _buildGroupForm(),
            // Loading overlay
            BlocBuilder<ChatBloc, ChatState>(
              buildWhen: (previous, current) => 
                  current is GroupLoading || previous is GroupLoading,
              builder: (context, state) {
                if (state is GroupLoading) {
                  return Container(
                    color: Colors.black54,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 16),
                          Text(
                            'Creating group...',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupForm() {
    return Column(
          children: [
            // Group info section
            Container(
              color: const Color(0xFF0078D4).withOpacity(0.05),
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group image picker
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0078D4).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(36),
                          image: _groupImage != null
                              ? DecorationImage(
                                  image: FileImage(_groupImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _groupImage == null
                            ? const Icon(
                                Icons.camera_alt,
                                color: Color(0xFF0078D4),
                                size: 32,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Group name and description
                    Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _groupNameController,
                            decoration: const InputDecoration(
                              hintText: 'Group name',
                              border: UnderlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a group name';
                              }
                              if (value.trim().length < 2) {
                                return 'Name must be at least 2 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              hintText: 'Description (optional)',
                              border: UnderlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Selected members chips
            if (_selectedMembers.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Members (${_selectedMembers.length})',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedMembers.map((member) {
                        return Chip(
                          avatar: CircleAvatar(
                            backgroundColor: const Color(0xFF0078D4),
                            child: Text(
                              member.username[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          label: Text(member.username),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () => _removeMember(member),
                          backgroundColor: Colors.grey[100],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            
            const Divider(height: 1),
            
            // Search field
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search users by name or email',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _isSearching = false);
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  if (value.length >= 2) {
                    _searchUsers(value);
                  } else {
                    setState(() => _isSearching = false);
                  }
                },
              ),
            ),
            
            // Search results or suggestions
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading && _isSearching) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0078D4),
                      ),
                    );
                  }
                  
                  if (state is UsersSearchResult && _isSearching) {
                    final users = state.users
                        .where((u) => 
                            u.id != widget.currentUserId &&
                            !_selectedMembers.any((m) => m.id == u.id))
                        .toList();
                    
                    if (users.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_search,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No users found',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF0078D4).withOpacity(0.2),
                            child: Text(
                              user.username[0].toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xFF0078D4),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(user.username),
                          subtitle: Text(
                            user.email,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.add_circle,
                              color: Color(0xFF0078D4),
                            ),
                            onPressed: () => _addMember(user),
                          ),
                          onTap: () => _addMember(user),
                        );
                      },
                    );
                  }
                  
                  // Default state - show instructions
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group_add,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Search and add members',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Type at least 2 characters to search',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
  }
}
