import 'package:flutter/material.dart';
import 'package:food_truck_mobile/firebase/auth_manager.dart';
import 'package:food_truck_mobile/icons/google_icon.dart';
import 'package:food_truck_mobile/models/user_model.dart';
import 'package:food_truck_mobile/screen/edit_profile_screen.dart';
import 'package:food_truck_mobile/screen/register_screen.dart';
import 'package:food_truck_mobile/widget/components/clickable_label.dart';
import 'package:food_truck_mobile/widget/components/input_field.dart';
import 'package:food_truck_mobile/widget/dividers/section_header_lr.dart';
import 'package:food_truck_mobile/widget/text.dart';
import 'package:provider/provider.dart';
import 'package:food_truck_mobile/helper/constants.dart';
import 'package:food_truck_mobile/models/seller_model.dart';
import 'package:food_truck_mobile/widget/components/bottom_navigation.dart';
import 'package:food_truck_mobile/widget/components/button.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// The [AccountScreen] of this app, it has two screens: User Information
/// Screen and the User Login Screen.

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController _inputEmail = TextEditingController();
  final TextEditingController _inputPassword = TextEditingController();
  bool _emailMode = true;

  @override
  void dispose() {
    _inputEmail.dispose();
    _inputPassword.dispose();
    super.dispose();
  }

  /// Build the page based on if currentUser has an instance
  @override
  Widget build(BuildContext context) {
    AuthManager auth = context.watch<AuthManager>();
    return auth.currentUser == null
        ? getLoginContent(auth)
        : getAccountProfile(auth);
  }

  /// Login State, Current Only Email/Password is supported
  Widget getLoginContent(AuthManager auth) {
    return Scaffold(
        appBar: AppBar(
          title: const TextHeadlineSmall(
            text: 'My Seller',
          ),
        ),
        bottomNavigationBar: const BottomNavigation(currentIndex: 2,),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: ListView(
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('images/UnknownUser.jpg'),
                ),
              ),
              const Center(
                child: TextTitleLarge(
                  text: 'Create an account or log in',
                  isBold: true,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
              const Center(
                child: TextTitleMedium(
                  text: 'Log in below or create.',
                  padding: EdgeInsets.zero,
                ),
              ),
              const Center(
                child: TextTitleMedium(
                  text: 'a new seller account.',
                  padding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(height: 16),
              const SectionHeaderLR(
                text: 'log in using email',
              ),
              const SizedBox(height: 8),
              InputField(
                labelText: _emailMode ? 'Email' : 'Password',
                obscureText: _emailMode ? false : true,
                prefixIcon: _emailMode
                    ? const Icon(Icons.email)
                    : const Icon(Icons.password),
                controller: _emailMode ? _inputEmail : _inputPassword,
                suffixIcon: _emailMode
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.arrow_back_outlined),
                        onPressed: () {
                          setState(() {
                            _emailMode = !_emailMode;
                            _inputEmail.clear();
                            _inputPassword.clear();
                          });
                        },
                      ),
              ),
              const SizedBox(height: 8),
              if (_emailMode)
                Button(
                  text: 'Next',
                  textColor: Constants.whiteColor,
                  takeLeastSpace: true,
                  onPressed: () {
                    setState(() {
                      if (!_checkFieldIsEmpty(_inputEmail)) {
                        _emailMode = !_emailMode;
                      }
                    });
                  },
                ),
              if (!_emailMode)
                Button(
                  text: 'Finish',
                  textColor: Constants.whiteColor,
                  takeLeastSpace: true,
                  onPressed: () {
                    setState(() {
                      if (!_checkFieldIsEmpty(_inputPassword)) {
                        auth.signInWithEmailAndPassword(
                            email: _inputEmail.text,
                            password: _inputPassword.text);
                        _emailMode = !_emailMode;
                        _inputEmail.clear();
                        _inputPassword.clear();
                      }
                    });
                  },
                ),
              const SizedBox(height: 8),
              if (_emailMode)
                Center(
                    child: ClickableLabel(
                  text: 'Register a new account with email',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const RegisterScreen()));
                  },
                )),
              if (!_emailMode)
                Center(
                  child: ClickableLabel(
                    text: 'Forgot your password?',
                    onTap: () {
                      auth.sendPasswordResetEmail(_inputEmail.text);
                    },
                  ),
                ),
            ],
          ),
        ));
  }

  /// Check if the input email or password is empty
  bool _checkFieldIsEmpty(TextEditingController controller) {
    if (controller.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Input Cannot be Empty!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          fontSize: 16.0);
      return true;
    }
    return false;
  }

  /// User Information State, Currently support retrieving data from Firebase
  /// The Implementation of this function has precondition that the current
  /// state has an currentUser instance.
  /// TODO: UI is not implemented
  Widget getAccountProfile(AuthManager auth) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Seller Account'),
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 2,),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await auth.signOut();
        },
        child: const Icon(Icons.remove),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: FutureBuilder<SellerModel?>(
          future: auth.getSellerInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                SellerModel sellerData = snapshot.data as SellerModel;
                return ListView(
                  children: [
                    const Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(
                          'images/UnknownUser.jpg',
                        ),
                      ),
                    ),
                    Center(
                      child: ClickableLabel(
                        text: 'edit',
                        onTap: () {
                          setState(() {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                      sellerModel: sellerData,
                                    )));
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      sellerData.name, // Replace with the user's name
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      sellerData.email, // Replace with the user's email
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16.0),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(sellerData.phoneNumber),
                      // Replace with the user's phone number
                      onTap: () {
                        // Handle phone number tap
                      },
                    ),
                  ],
                );
              }
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
