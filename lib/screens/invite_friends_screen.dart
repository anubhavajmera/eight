import 'package:contacts_service/contacts_service.dart';
import 'package:eight/screens/size_config.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class InviteFriendsScreen extends StatefulWidget {
  @override
  _InviteFriendsScreenState createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  Iterable<Contact> _contacts;
  List<String> inviteList = new List<String>();

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  Future<void> getContacts() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      final Iterable<Contact> contacts = await ContactsService.getContacts();
      setState(() {
        _contacts = contacts;
      });
    }
  }

  //Check contacts permission
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 30, top: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Invite",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 35),
            ),
            _contacts != null
                ? Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight * 0.6,
                    child: ListView.builder(
                        itemCount: _contacts?.length ?? 0,
                        itemBuilder: (context, index) {
                          Contact contact = _contacts?.elementAt(index);
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                (contact.avatar != null &&
                                        contact.avatar.isNotEmpty)
                                    ? CircleAvatar(
                                        radius: 25.0,
                                        backgroundImage:
                                            MemoryImage(contact.avatar),
                                      )
                                    : CircleAvatar(
                                        radius: 25.0,
                                        child: Text(contact.initials()),
                                        backgroundColor:
                                            Theme.of(context).accentColor,
                                      ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  width: SizeConfig.screenWidth * 0.5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        contact.displayName ?? '',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        contact.phones.length > 0
                                            ? contact.phones.first.value
                                                .toString()
                                            : '',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Colors.black45),
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    inviteList.add(
                                        contact.phones.first.value.toString());
                                    print(inviteList);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFf7f4fc),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(Icons.add),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  )
                : Center(child: const CircularProgressIndicator()),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 130,
                    height: 50,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                          Color(0xFF010000),
                          Color(0xFFcc0025),
                        ])),
                    child: Text(
                      "Done",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
