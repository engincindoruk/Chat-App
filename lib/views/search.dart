import 'package:chat_app_tutorial/helper/constants.dart';
import 'package:chat_app_tutorial/services/database.dart';
import 'package:chat_app_tutorial/views/conversation_screen.dart';
import 'package:chat_app_tutorial/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchtextEditingControler = TextEditingController();

  DatabaseMethods databasemethos = new DatabaseMethods();

  QuerySnapshot searchSnapshot;

  initiateSearch() {
    databasemethos
        .getUserByEmail(searchtextEditingControler.text.trim())
        .then((val) {
      setState(() {
        searchSnapshot =
            val; //burda value  QuerySnapshot olarak dönüyo ondan bi QuerySnapshot oluşturduk alttadaki fnksiyonda onun length almış olduk
        //print(searchSnapshot.documents[0].data["name"]);
      });
    });
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.documents.length,
            shrinkWrap:
                true, //bunu koyadığımızda boyutlardan dolayı errror veriyo veriler gelmiyo
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshot.documents[index].data[
                    "name"], //istersek direk de  documents[index]["name"] yazabilriiz
                userEmail: searchSnapshot.documents[index].data["email"],
              );
            })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                          controller: searchtextEditingControler,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "search username..",
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                          ))),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0x36FFFFFF),
                              Color(0x0FFFFFFF),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Image.asset("assets/images/search_white.png")),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

//create chat room and send user to conversation screen
createChatroomAndStartConversation({BuildContext context, String userName}) {
  if (userName != Constants.myName) {
    String chatRoomId = getChatRoomId(userName, Constants.myName);

    List<String> users = [userName, Constants.myName];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomId": chatRoomId
    };
    DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => ConversationScreen(chatRoomId)));
  } else {
    print("kendine mesaj atamazsın");
  }
}

class SearchTile extends StatelessWidget {
  final String userName;
  final String userEmail;
  SearchTile({this.userName, this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userName,
                style: mediumTextStyle(),
              ),
              Text(
                userEmail,
                style: mediumTextStyle(),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConversation(
                  context: context, userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Message",
                style: mediumTextStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  //burda mesela a be ye mesaj atmak istediğinde bi oda oluşuyo ya b de a ya sonradan aratıp atmak isterse farklı bi oda oluşmasın diye yapılıyo
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
