import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitup/models/user_model.dart';
import 'package:fitup/providers/AuthenticationService.dart';
import 'package:fitup/providers/user_provider.dart';
import 'package:fitup/utils/firebase_helper.dart';
import 'package:fitup/utils/image_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _oldPassword = TextEditingController();

  String email;
  String profilePicUrl;
  User firebaseUser;
  UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    // String username = Provider.of<User>(context, listen: false).displayName;
    firebaseUser = Provider.of<User>(context);
    Provider.of<UserProvider>(context).signIn(firebaseUser);
    currentUser = Provider.of<UserProvider>(context).user;
    profilePicUrl = Provider.of<UserProvider>(context).user.profilePic;
    return SafeArea(
      child: SizedBox(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 50.0, left: 40, right: 40, bottom: 15),
          child: Column(
            children: [
              SizedBox(
                height: 115,
                width: 115,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    CircleAvatar(
                      backgroundImage: profilePicUrl == null
                          ? const AssetImage(
                              "assets/images/empty_profile_pic.png")
                          : NetworkImage(profilePicUrl),
                    ),
                    Positioned(
                        bottom: 0,
                        right: -25,
                        child: RawMaterialButton(
                          onPressed: () async {
                            try {
                              // SELECT IMAGE
                              String path = await ImagePickerHelper()
                                  .getImageFrom(ImageSource.gallery);
                              // Upload Image
                              String result = await FirebaseHelper()
                                  .uploadProfilePicFile(
                                      path, currentUser.userID);

                              // Update image
                              if (result != "Error") {
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .updateProfilePic(result);

                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Successfully uploaded Image")));

                                // setState(() {});
                              }
                            } catch (err) {
                              debugPrint(err.toString());
                            }
                          },
                          elevation: 2.0,
                          fillColor: const Color(0xFFF5F6F9),
                          child: const Icon(
                            LineIcons.camera,
                            color: Colors.blue,
                          ),
                          padding: const EdgeInsets.all(15.0),
                          shape: const CircleBorder(),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              // TextField(
              //   decoration: const InputDecoration(hintText: 'Username'),
              //   controller: _username,
              // ),
              TextField(
                decoration: InputDecoration(
                    hintText: Provider.of<UserProvider>(context).user.email),
                controller: _email,
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'New Password'),
                obscureText: true,
                controller: _newPassword,
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Old Password'),
                obscureText: true,
                controller: _oldPassword,
              ),
              const SizedBox(
                height: 150,
              ),
              SizedBox(
                height: 40,
                width: 150,
                child: TextButton(
                  onPressed: () async {
                    // Change Password
                    if (_oldPassword.text.length >= 8 &&
                        _newPassword.text.length > 8) {
                      await Provider.of<Auth>(context, listen: false)
                          .changePassword(_oldPassword.text.trim(),
                              _newPassword.text.trim(), context);
                    }

                    // Change Email
                    if (_email.text != email) {
                      try {
                        Provider.of<User>(context, listen: false)
                            .updateEmail(_email.text);
                        Provider.of<UserProvider>(context, listen: false)
                            .updateEmailAddress(_email.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Successfully changed Email Address")));
                      } on FirebaseAuthException {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "invalid-email / email-already-in-use / need to login again")));
                      }
                    }
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
