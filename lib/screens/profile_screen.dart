import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitup/models/user_model.dart';
import 'package:fitup/providers/AuthenticationService.dart';
import 'package:fitup/providers/user_provider.dart';
import 'package:fitup/utils/firebase_helper.dart';
import 'package:fitup/utils/image_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();

  String email;
  String profilePicUrl;
  User firebaseUser;
  UserModel currentUser;

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _oldPasswordController.dispose();
    super.dispose();
  }

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
          padding: EdgeInsets.only(
              top: 50.0.h, left: 40.w, right: 40.w, bottom: 15.h),
          child: Column(
            children: [
              SizedBox(
                height: 115.h,
                width: 115.h,
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
                        bottom: 0.h,
                        right: -25.w,
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

                              // Update firebaseuser
                              Provider.of<User>(context, listen: false)
                                  .updatePhotoURL(result);

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
                          padding: EdgeInsets.all(15.0.h),
                          shape: const CircleBorder(),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              // TextField(
              //   decoration: const InputDecoration(hintText: 'Username'),
              //   controller: _username,
              // ),
              TextField(
                decoration: InputDecoration(
                    hintText: Provider.of<UserProvider>(context).user.email),
                controller: _emailController,
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Old Password'),
                obscureText: true,
                controller: _oldPasswordController,
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'New Password'),
                obscureText: true,
                controller: _newPasswordController,
              ),

              SizedBox(
                height: 150.h,
              ),
              SizedBox(
                height: 40.h,
                width: 150.w,
                child: TextButton(
                  onPressed: () async {
                    // Change Password
                    if (_oldPasswordController.text.length >= 8 &&
                        _newPasswordController.text.length > 8) {
                      await Provider.of<Auth>(context, listen: false)
                          .changePassword(_oldPasswordController.text.trim(),
                              _newPasswordController.text.trim(), context);
                    }

                    // Change Email
                    if (_emailController.text != email) {
                      if (_oldPasswordController.text.length <= 8) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "Old password is required to change email")));
                      } else {
                        try {
                          String result =
                              await Provider.of<Auth>(context, listen: false)
                                  .changeEmail(_oldPasswordController.text,
                                      _emailController.text, context);
                          if (result != "Error") {
                            Provider.of<UserProvider>(context, listen: false)
                                .updateEmailAddress(_emailController.text);
                          }
                        } catch (err) {
                          debugPrint(err.toString());
                        }
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
