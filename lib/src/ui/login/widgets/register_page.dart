import "package:flutter/material.dart";
import "package:image_picker_modern/image_picker_modern.dart";
import "package:flutter_svg/flutter_svg.dart";
import "dart:io";

import "../../widgets/text_button.dart";
import "../../../resources/user_api_provider.dart";

import "input.dart";

typedef void HomeCallback();

class RegisterPage extends StatefulWidget {
  final HomeCallback homeCallback;

  RegisterPage({@required this.homeCallback});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final String phoneSvg = "assets/phoneno.svg";

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  File _image;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: SvgPicture.asset(phoneSvg,
                    height: MediaQuery.of(context).size.height / 5)),
            Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Let's get you up and running.",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).accentTextTheme.display3),
                  Text("Enter your info to create your very own Beep account.",
                      style: Theme.of(context)
                          .accentTextTheme
                          .title
                          .copyWith(fontWeight: FontWeight.w400)),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: (_image != null)
                          ? CircleAvatar(
                              radius: 50, backgroundImage: FileImage(_image))
                          : CircleAvatar(
                              radius: 50, backgroundColor: Colors.grey[300])),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Input(
                          controller: firstNameController,
                          hintText: "First name")),
                  Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Input(
                          controller: lastNameController,
                          hintText: "Last name")),
                ])
          ]))),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: TextButton(
                text: "Set profile picture",
                onClickCallback: () async {
                  var image =
                      await ImagePicker.pickImage(source: ImageSource.gallery);

                  setState(() => _image = image);
                }),
          ),
          Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: TextButton(
                  text: "Continue",
                  onClickCallback: () async {
                    final firstName = firstNameController.text;
                    final lastName = lastNameController.text;

                    // Creating the new user
                    await userApiProvider.updateUser(
                        firstName, lastName, "", "", _image);
                    widget.homeCallback();
                  })),
        ]));
  }
}
