import 'package:chatapp_firebase/pages/chat_page.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ChatPage(
              groupId: widget.groupId,
              groupName: widget.groupName,
              userName: widget.userName,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.5, color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(10),),
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            widget.groupName,
            //group title
            style: const TextStyle(color:Colors.black, fontWeight: FontWeight.bold),
          ),
          //Subtitle
          subtitle: Text(
            "Únete a la conversación como ${widget.userName}",
            style: const TextStyle(color:Color(0xFF808084),fontSize: 13),
          ),
        ),
      ),
    );
  }
}
