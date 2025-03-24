import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../items/user_message_item.dart';

class UserMessageList extends StatelessWidget {
  final int initialIndex;
  final Stream<List<Map<String, dynamic>>> messageStream;

  const UserMessageList({super.key, required this.initialIndex, required this.messageStream});

  Future<UserEntity> _fetchUserEntity(String userId) async {
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
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: messageStream,
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

          return ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                log('Message $index: ${messages[index]}');

                return FutureBuilder<UserEntity>(
                  future: _fetchUserEntity(messages[index]['fromId'] as String),  // Ensure we're passing just a String
                  builder: (context, userSnapshot) {
                    log('User Snapshot State: ${userSnapshot.connectionState}, Error: ${userSnapshot.error}');

                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (userSnapshot.hasError) {
                      log('Error loading profile: ${userSnapshot.error}');
                      return Center(child: Text(S.of(context).errorLoadingProfile));
                    } else if (!userSnapshot.hasData) {
                      return Center(child: Text('Пользователь не найден'));
                    } else {
                      final userEntity = userSnapshot.data!;
                      return UserMessageItem(
                        message: messages[index]['message'] ?? '',
                        sent: (messages[index]['sent'] is DateTime)
                            ? (messages[index]['sent'] as DateTime).toString()
                            : messages[index]['sent'] ?? '',
                        user: userEntity,
                        userName: messages[index]['name'] ?? 'Unknown',
                        initialIndex: initialIndex,
                      );
                    }
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}
