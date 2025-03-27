import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maestro/features/search/widgets/shimmers/search_shimmer_loader.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/formatters/formatter.dart';
import '../items/user_message_item.dart';

class UserMessageList extends StatefulWidget {
  final int initialIndex;
  final Stream<List<Map<String, dynamic>>> messageStream;

  const UserMessageList({super.key, required this.initialIndex, required this.messageStream});

  @override
  State<UserMessageList> createState() => _UserMessageListState();
}

class _UserMessageListState extends State<UserMessageList> {
  late Future<Map<String, dynamic>> userDataFuture;

  Future<Map<String, dynamic>> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      log('No user logged in');
      throw Exception(S.of(context).noUserLoggedIn);
    }

    var userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
    if (!userDoc.exists) {
      log('User does not exist in Firestore');
      throw Exception('Пользователь не найден');
    }
    return userDoc.data()!;
  }

  Future<UserEntity> _fetchUserEntity(String userId) async {
    if (userId.isEmpty) {
      log('Error: userId is empty');
      throw Exception("Invalid userId");
    }

    try {
      final userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      if (userDoc.exists) {
        log('Fetched data: ${userDoc.data()}');
        return UserEntity.fromFirestore(userDoc);
      } else {
        log('User not found with ID: $userId');
        throw Exception("User not found");
      }
    } catch (e) {
      log('Error fetching user: $e');
      throw Exception("Error fetching user: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    userDataFuture = _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: widget.messageStream,
      builder: (context, snapshot) {
        log('Stream Snapshot: ${snapshot.data}');

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
        } else if (snapshot.hasError) {
          log('Error loading messages: ${snapshot.error}');
          return Center(child: Text(S.of(context).errorLoadingMessages));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          log('No data or empty data received');
          return Center(child: Text('Сообщения не найдены'));
        } else {
          final messages = snapshot.data!;

          return FutureBuilder<Map<String, dynamic>>(
            future: userDataFuture,
            builder: (context, userDataSnapshot) {
              if (userDataSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
              } else if (userDataSnapshot.hasError) {
                log('Error loading current user data: ${userDataSnapshot.error}');
                return Center(child: Text(S.of(context).errorLoadingProfile));
              } else if (!userDataSnapshot.hasData) {
                return Center(child: Text(S.of(context).errorLoadingProfile));
              } else {
                final currentUserData = userDataSnapshot.data!;

                return ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      log('Message $index: ${messages[index]}');
                      final isCurrentUserSender = FirebaseAuth.instance.currentUser?.uid == messages[index]['fromId'];
                      final userId = isCurrentUserSender ? messages[index]['toId'] : messages[index]['fromId'];

                      return FutureBuilder<UserEntity>(
                        future: _fetchUserEntity(userId.toString()),
                        builder: (context, userSnapshot) {
                          log('User Snapshot State: ${userSnapshot.connectionState}, Error: ${userSnapshot.error}');

                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return SearchShimmerLoader(itemCount: 10);
                          } else if (userSnapshot.hasError) {
                            log('Error loading profile: ${userSnapshot.error}');
                            return Center(child: Text(S.of(context).errorLoadingProfile));
                          } else if (!userSnapshot.hasData) {
                            return Center(child: Text('Пользователь не найден'));
                          } else {
                            final userEntity = userSnapshot.data!;
                            final isCurrentUser = userEntity.id == currentUserData['id'];

                            return UserMessageItem(
                              message: messages[index]['message'] ?? '',
                              sent: (messages[index]['sent'] is DateTime) ? Formatter.formatTime(messages[index]['sent'] as DateTime) : messages[index]['sent'] ?? '',
                              user: userEntity,
                              userName: isCurrentUser ? currentUserData['name'] : userEntity.name,
                              initialIndex: widget.initialIndex,
                            );
                          }
                        },
                      );
                    },
                  ),
                );
              }
            }
          );
        }
      },
    );
  }
}
