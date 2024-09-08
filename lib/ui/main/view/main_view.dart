import 'package:chatappwithflutter/ui/chat/cubit/cubit/chat_cubit_cubit.dart';
import 'package:chatappwithflutter/ui/main/cubit/main_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatappwithflutter/core/components/custom_row_button.dart';
import 'package:chatappwithflutter/model/user_model.dart';
import 'package:chatappwithflutter/ui/chat/view/chat_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          if (state is MainLoaded) {
            return Column(
              children: [
                const SizedBox(height: 10),
                _buildRowIcon(),
                _buildSegmentedButton(context),
                const SizedBox(height: 10),
                Expanded(child: _listCardWidget(state.users, context)),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
    );
  }

  Widget _buildRowIcon() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            iconSize: 30,
            onPressed: () {},
            color: Colors.blue,
            icon: const Icon(Icons.menu),
          ),
          IconButton(
            iconSize: 30,
            onPressed: () {},
            color: Colors.blue,
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedButton(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CustomSegmentedButton(
            items: const [
              'All',
              'Unread',
              'Read',
              'Pined',
            ],
            onValueChanged: (value) {
              context.read<MainCubit>().filterUsers(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _listCardWidget(List<UserModel> userList, BuildContext context) {
    return ListView.builder(
      itemCount: userList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Card(
            color: Colors.amber[100],
            borderOnForeground: true,
            shadowColor: Colors.green,
            child: ListTile(
              onTap: () {
                context
                    .read<ChatCubitCubit>()
                    .initializeChat(userList[index].userId);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatView(
                        fullName: userList[index].nameSurname,
                        receiverId: userList[index].userId,
                        chatId: context.read<ChatCubitCubit>().currentChatId),
                  ),
                );
              },
              leading: const SizedBox(
                width: 70,
                height: 70,
                child: Icon(Icons.person),
              ),
              title: Text(userList[index].nameSurname),
              subtitle: Text(userList[index].status),
              trailing: const Text('3.40 PM'),
            ),
          ),
        );
      },
    );
  }
}
