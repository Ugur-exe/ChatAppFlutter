import 'package:chatappwithflutter/core/components/custom_row_button.dart';
import 'package:chatappwithflutter/core/router.dart';
import 'package:chatappwithflutter/model/user_model.dart';
import 'package:chatappwithflutter/view/chat_view.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<User> userlist = [
    User(
        email: 'ugurkolcak@gmail.com',
        nameSurname: 'Uğur Kolçak',
        userId: '123'),
    User(
        email: 'ugurkolcak@gmail.com',
        nameSurname: 'Mert Pehlivan',
        userId: '123'),
    User(
        email: 'ugurkolcak@gmail.com',
        nameSurname: 'Emirhan Alıcı',
        userId: '123'),
    User(
      email: 'ugurkolcak@gmail.com',
      nameSurname: 'Emirhan Albayrak',
      userId: '123',
    ),
  ];
  List<User> filteredUserList = [];
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    // Başlangıçta tüm kullanıcıları göster
    filteredUserList = userlist;
  }

  void _onFilterChanged(String value) {
    setState(() {
      selectedFilter = value;
      if (value == 'All') {
        filteredUserList = userlist;
      } else if (value == 'Unread') {
        filteredUserList = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        const SizedBox(height: 10),
        _buildRowIcon(),
        _buildSegmentedButton(),
        const SizedBox(height: 10),
        Expanded(child: _listCardWidget()),
      ],
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

  Widget _buildSegmentedButton() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CustomSegmentedButton(
            items: [
              'All',
              'Unread',
              'Read',
              'Pined',
            ],
            onValueChanged: _onFilterChanged,
          ),
        ],
      ),
    );
  }

  Widget _listCardWidget() {
    return ListView.builder(
      itemCount: filteredUserList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatView(
                  fullName: filteredUserList[index].nameSurname,
                ),
              ),
            );
          },
          child: Card(
            child: ListTile(
              leading: SizedBox(
                width: 70,
                height: 70,
                child: Icon(Icons.person),
              ),
              title: Text(filteredUserList[index].nameSurname),
              subtitle: Text('Of course, we just added that to...'),
              trailing: Text('3.40 PM'),
            ),
          ),
        );
      },
    );
  }
}
