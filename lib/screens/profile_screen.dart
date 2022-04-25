import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitup/models/user_model.dart';
import 'package:fitup/providers/auth_provider.dart';
import 'package:fitup/providers/user_provider.dart';
import 'package:fitup/apis/firebase_api.dart';
import 'package:fitup/controller/image_picker_helper.dart';
import 'package:fitup/widgets/snack_bar_widget.dart';
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
  GlobalKey<FormState> formKeyEmail = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyPassword = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();

  String email;
  String profilePicUrl;
  User firebaseUser;
  UserModel currentUser;

  String profileState = "Change Email";

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _oldPasswordController.dispose();
    super.dispose();
  }

  void changePassword() async {
    if (formKeyPassword.currentState.validate()) {
      try {
        await Provider.of<AuthProvider>(context, listen: false).changePassword(
            _oldPasswordController.text.trim(),
            _newPasswordController.text.trim(),
            context);
      } catch (err) {
        debugPrint(err.toString());
      }
    }
  }

  void changeEmail() async {
    if (formKeyEmail.currentState.validate()) {
      try {
        String result = await Provider.of<AuthProvider>(context, listen: false)
            .changeEmail(
                _oldPasswordController.text, _emailController.text, context);
        if (result != "Error") {
          Provider.of<UserProvider>(context, listen: false)
              .updateEmailAddress(_emailController.text);
        }
      } catch (err) {
        debugPrint(err.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    firebaseUser = Provider.of<User>(context);
    Provider.of<UserProvider>(context).signIn(firebaseUser);
    currentUser = Provider.of<UserProvider>(context).user;
    profilePicUrl = Provider.of<UserProvider>(context).user.profilePic;
    return SafeArea(
      child: SizedBox(
        child: Padding(
          padding: EdgeInsets.only(
              top: 50.0.h, left: 40.w, right: 40.w, bottom: 15.h),
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                profilePicture(),
                SizedBox(
                  height: 50.h,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      selectWhatToChangeButton("Change Email"),
                      selectWhatToChangeButton("Change Password"),
                    ]),
                SizedBox(
                  height: 50.h,
                ),
                if (profileState == "Change Email")
                  Form(
                    key: formKeyEmail,
                    child: Column(
                      children: [
                        emailTextField(),
                        oldPasswordTextField(),
                      ],
                    ),
                  ),
                if (profileState == "Change Password")
                  Form(
                    key: formKeyPassword,
                    child: Column(
                      children: [
                        newPasswordTextField(),
                        oldPasswordTextField(),
                      ],
                    ),
                  ),
                SizedBox(
                  height: 100.h,
                ),
                SizedBox(
                  height: 40.h,
                  width: 150.w,
                  child: TextButton(
                    onPressed: () {
                      profileState == "Change Email"
                          ? changeEmail()
                          : changePassword();
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
      ),
    );
  }

  Widget selectWhatToChangeButton(String title) {
    return TextButton(
      onPressed: () {
        setState(() {
          profileState = title;
        });
      },
      child: Text(title),
    );
  }

  Widget emailTextField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          labelText: Provider.of<UserProvider>(context).user.email),
      controller: _emailController,
      validator: (text) {
        if (!_emailController.text.contains('@') &&
            _emailController.text.isNotEmpty) {
          return "Enter valid Email Address";
        }
        return null;
      },
    );
  }

  Widget oldPasswordTextField() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(labelText: 'Old Password'),
          obscureText: true,
          controller: _oldPasswordController,
          validator: (text) {
            if (_oldPasswordController.text.length <= 8) {
              return "Password has to contain atleast 8 chars";
            }
            return null;
          }),
    );
  }

  Widget newPasswordTextField() {
    return TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: const InputDecoration(labelText: 'New Password'),
        obscureText: true,
        controller: _newPasswordController,
        validator: (text) {
          if (_oldPasswordController.text.length <= 8) {
            return "Password has to contain atleast 8 chars";
          }
          return null;
        });
  }

  Widget profilePicture() {
    return SizedBox(
      height: 115.h,
      width: 115.h,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          CircleAvatar(
            backgroundImage: profilePicUrl == null
                ? const AssetImage("assets/images/empty_profile_pic.png")
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
                    String result = await FirebaseApi()
                        .uploadProfilePicFile(path, currentUser.userID);

                    // Update firebaseuser
                    Provider.of<User>(context, listen: false)
                        .updatePhotoURL(result);

                    // Update image
                    if (result != "Error") {
                      Provider.of<UserProvider>(context, listen: false)
                          .updateProfilePic(result);

                      ScaffoldMessenger.of(context).showSnackBar(
                          snackBarWidget("Successfully uploaded Image", false));

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
    );
  }
}
