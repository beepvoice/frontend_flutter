import "package:flutter/material.dart";
import 'package:image_picker_modern/image_picker_modern.dart';
import 'package:image_jpeg/image_jpeg.dart';
import "package:path_provider/path_provider.dart";
import "dart:io";

import "../../../models/user_model.dart";

import "../../../resources/conversation_api_provider.dart";

import "../../widgets/contact_item.dart";
import "../../widgets/top_bar.dart";
import "../../widgets/small_text_button.dart";
import "../../widgets/list_button.dart";

class NewGroupInfoView extends StatefulWidget {
  final List<User> users;

  NewGroupInfoView({@required this.users});

  @override
  State<StatefulWidget> createState() {
    return _NewGroupInfoViewState();
  }
}

class _NewGroupInfoViewState extends State<NewGroupInfoView> {
  final descriptionController = TextEditingController();
  final nameController = TextEditingController();

  File _image;

  @override
  void dispose() {
    descriptionController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TopBar(title: "New Group", children: <Widget>[
        IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        Spacer(),
        SmallTextButton(
            text: "Create",
            onClickCallback: () async {
              final conversation = await conversationApiProvider
                  .createConversation(nameController.text,
                      profile: _image, dm: true);

              for (var user in widget.users) {
                await conversationApiProvider.createConversationMember(
                    conversation.id, user.id);
              }
              Navigator.pushNamed(context, "conversation/home");
            })
      ]),
      Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <
              Widget>[
            (_image != null)
                ? CircleAvatar(radius: 50, backgroundImage: FileImage(_image))
                : CircleAvatar(radius: 50, backgroundColor: Colors.grey[300]),
            Flexible(
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 8.0),
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  color: Colors.grey[100],
                  child: TextField(
                      controller: nameController,
                      autocorrect: false,
                      cursorWidth: 2.0,
                      cursorColor: Colors.grey[600],
                      style: Theme.of(context).textTheme.title.copyWith(
                          color: Colors.grey[600], fontWeight: FontWeight.w300),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: false,
                          hintText: "Enter group name",
                          hintStyle: Theme.of(context).textTheme.title.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w300)))),
            ])),
          ])),
      Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: ListButton(
              icon: Icons.insert_photo,
              text: "Add a group photo",
              onClickCallback: () async {
                // First get the image
                var image =
                    await ImagePicker.pickImage(source: ImageSource.gallery);

                // Compress image into temp
                Directory tempDir = await getTemporaryDirectory();
                String compressedImage = await ImageJpeg.encodeJpeg(
                    image.path, "${tempDir.path}/temp_pic.jpg", 70, 500, 500);

                setState(() {
                  _image = File(compressedImage);
                });
              })),
      Expanded(
          child: Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.users
                      .map((user) => ContactItem(user: user))
                      .toList())))
    ]);
  }
}
