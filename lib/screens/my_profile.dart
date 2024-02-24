import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulms/custom_widget/theme_helper.dart';
import 'package:ulms/models/lecturerModel.dart';
import 'package:ulms/services/api_repository_implement.dart';
import 'package:ulms/services/constant.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiRepositoryImplmentation _apiRepositoryImplmentation =
      ApiRepositoryImplmentation();
  bool isLoading = true;
  String role = 'Lecturer';
  Lecturer detail = Lecturer();
  @override
  void initState() {
    _getDetails();
    super.initState();
  }

  _getDetails() async {
    await Constants.getUserRoleSharedPreference().then(
      (value) {
        setState(() {
          role = value!;
        });
      },
    );

    setState(() {
      isLoading = true;
    });
    await _apiRepositoryImplmentation.getMyDetails().then((value) {
      setState(() {
        detail = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   leading: IconButton(
      //       onPressed: () => Get.back(),
      //       icon: const Icon(Icons.arrow_back_ios_sharp)),
      //   title: Text("Profile", style: Theme.of(context).textTheme.headline4),
      //   elevation: 0.0,
      // ),
      body: isLoading
          ? Center(child: ThemeHelper().progressBar())
          : Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        /// -- IMAGE
                        Stack(
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CircleAvatar(
                                    foregroundImage:
                                        NetworkImage(detail.imageUrl!),
                                  )),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 1,
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.blue,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: isDark ? Colors.white : Colors.black,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text("${detail.title} ${detail.fullName}",
                            style: Theme.of(context).textTheme.headline4),
                        Text(detail.matricNo!,
                            style: Theme.of(context).textTheme.bodyText2),
                        const SizedBox(height: 20),

                        /// -- BUTTON
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () => Get.to(() {}),
                            style: ElevatedButton.styleFrom(
                                // backgroundColor: Colors.purple,
                                side: BorderSide.none,
                                shape: const StadiumBorder()),
                            child: const Text(
                              "EditProfile",
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Divider(),
                        const SizedBox(height: 10),

                        /// -- MENU
                        ProfileMenuWidget(
                            title: "${detail.department}",
                            icon: Icons.class_,
                            onPress: () {}),
                        ProfileMenuWidget(
                            title: "${detail.email}",
                            icon: Icons.email,
                            onPress: () {}),
                        ProfileMenuWidget(
                            title: "+${detail.phoneNo}",
                            icon: Icons.people,
                            onPress: () {}),
                        ProfileMenuWidget(
                            title: role, icon: Icons.info, onPress: () {}),
                        ProfileMenuWidget(
                            title: "Logout",
                            icon: Icons.signpost_outlined,
                            textColor: Colors.red,
                            endIcon: false,
                            onPress: () {
                              Get.defaultDialog(
                                title: "LOGOUT",
                                titleStyle: const TextStyle(fontSize: 20),
                                content: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15.0),
                                  child:
                                      Text("Are you sure, you want to Logout?"),
                                ),
                                confirm: Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        side: BorderSide.none),
                                    child: const Text("Yes"),
                                  ),
                                ),
                                cancel: OutlinedButton(
                                    onPressed: () => Get.back(),
                                    child: const Text("No")),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var iconColor = Colors.blue;

    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: iconColor.withOpacity(0.1),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title,
          style:
              Theme.of(context).textTheme.bodyText1?.apply(color: textColor)),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(Icons.ac_unit, size: 18.0, color: Colors.grey))
          : null,
    );
  }
}


                /// -- BUTTON
                // SizedBox(
                //   width: 200,
                //   child: ElevatedButton(
                //     onPressed: () => Get.to(() => const UpdateProfileScreen()),
                //     style: ElevatedButton.styleFrom(
                //         backgroundColor: tPrimaryColor,
                //         side: BorderSide.none,
                //         shape: const StadiumBorder()),
                //     child: const Text(tEditProfile,
                //         style: TextStyle(color: tDarkColor)),
                //   ),
                // ),
                // const SizedBox(height: 30),
                // const Divider(),
                // const SizedBox(height: 10),

                // /// -- MENU
                // ProfileMenuWidget(
                //     title: "Settings",
                //     icon: LineAwesomeIcons.cog,
                //     onPress: () {}),
                // ProfileMenuWidget(
                //     title: "Billing Details",
                //     icon: LineAwesomeIcons.wallet,
                //     onPress: () {}),
                // ProfileMenuWidget(
                //     title: "User Management",
                //     icon: LineAwesomeIcons.user_check,
                //     onPress: () {}),
                // const Divider(),
                // const SizedBox(height: 10),
                // ProfileMenuWidget(
                //     title: "Information",
                //     icon: LineAwesomeIcons.info,
                //     onPress: () {}),
                // ProfileMenuWidget(
                //     title: "Logout",
                //     icon: LineAwesomeIcons.alternate_sign_out,
                //     textColor: Colors.red,
                //     endIcon: false,
                //     onPress: () {
                //       Get.defaultDialog(
                //         title: "LOGOUT",
                //         titleStyle: const TextStyle(fontSize: 20),
                //         content: const Padding(
                //           padding: EdgeInsets.symmetric(vertical: 15.0),
                //           child: Text("Are you sure, you want to Logout?"),
                //         ),
                //         confirm: Expanded(
                //           child: ElevatedButton(
                //             onPressed: () =>
                //                 AuthenticationRepository.instance.logout(),
                //             style: ElevatedButton.styleFrom(
                //                 backgroundColor: Colors.redAccent,
                //                 side: BorderSide.none),
                //             child: const Text("Yes"),
                //           ),
                //         ),
                //         cancel: OutlinedButton(
                //             onPressed: () => Get.back(), child: const Text("No")),
                //       );
                //     }),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//             onPressed: () => Get.back(),
//             icon: const Icon(LineAwesomeIcons.angle_left)),
//         title: Text(tProfile, style: Theme.of(context).textTheme.headline4),
//         actions: [
//           IconButton(
//               onPressed: () {},
//               icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(tDefaultSize),
//           child: Column(
//             children: [
//               /// -- IMAGE
//               Stack(
//                 children: [
//                   SizedBox(
//                     width: 120,
//                     height: 120,
//                     child: ClipRRect(
//                         borderRadius: BorderRadius.circular(100),
//                         child: const Image(image: AssetImage(tProfileImage))),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       width: 35,
//                       height: 35,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(100),
//                           color: tPrimaryColor),
//                       child: const Icon(
//                         LineAwesomeIcons.alternate_pencil,
//                         color: Colors.black,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Text(tProfileHeading,
//                   style: Theme.of(context).textTheme.headline4),
//               Text(tProfileSubHeading,
//                   style: Theme.of(context).textTheme.bodyText2),
//               const SizedBox(height: 20),

//               /// -- BUTTON
//               SizedBox(
//                 width: 200,
//                 child: ElevatedButton(
//                   onPressed: () => Get.to(() => const UpdateProfileScreen()),
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: tPrimaryColor,
//                       side: BorderSide.none,
//                       shape: const StadiumBorder()),
//                   child: const Text(tEditProfile,
//                       style: TextStyle(color: tDarkColor)),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               const Divider(),
//               const SizedBox(height: 10),

//               /// -- MENU
//               ProfileMenuWidget(
//                   title: "Settings",
//                   icon: LineAwesomeIcons.cog,
//                   onPress: () {}),
//               ProfileMenuWidget(
//                   title: "Billing Details",
//                   icon: LineAwesomeIcons.wallet,
//                   onPress: () {}),
//               ProfileMenuWidget(
//                   title: "User Management",
//                   icon: LineAwesomeIcons.user_check,
//                   onPress: () {}),
//               const Divider(),
//               const SizedBox(height: 10),
//               ProfileMenuWidget(
//                   title: "Information",
//                   icon: LineAwesomeIcons.info,
//                   onPress: () {}),
//               ProfileMenuWidget(
//                   title: "Logout",
//                   icon: LineAwesomeIcons.alternate_sign_out,
//                   textColor: Colors.red,
//                   endIcon: false,
//                   onPress: () {
//                     Get.defaultDialog(
//                       title: "LOGOUT",
//                       titleStyle: const TextStyle(fontSize: 20),
//                       content: const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 15.0),
//                         child: Text("Are you sure, you want to Logout?"),
//                       ),
//                       confirm: Expanded(
//                         child: ElevatedButton(
//                           onPressed: () =>
//                               AuthenticationRepository.instance.logout(),
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.redAccent,
//                               side: BorderSide.none),
//                           child: const Text("Yes"),
//                         ),
//                       ),
//                       cancel: OutlinedButton(
//                           onPressed: () => Get.back(), child: const Text("No")),
//                     );
//                   }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ProfileMenuWidget extends StatelessWidget {
//   const ProfileMenuWidget({
//     Key? key,
//     required this.title,
//     required this.icon,
//     required this.onPress,
//     this.endIcon = true,
//     this.textColor,
//   }) : super(key: key);

//   final String title;
//   final IconData icon;
//   final VoidCallback onPress;
//   final bool endIcon;
//   final Color? textColor;

//   @override
//   Widget build(BuildContext context) {
//     var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
//     var iconColor = isDark ? tPrimaryColor : tAccentColor;

//     return ListTile(
//       onTap: onPress,
//       leading: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(100),
//           color: iconColor.withOpacity(0.1),
//         ),
//         child: Icon(icon, color: iconColor),
//       ),
//       title: Text(title,
//           style:
//               Theme.of(context).textTheme.bodyText1?.apply(color: textColor)),
//       trailing: endIcon
//           ? Container(
//               width: 30,
//               height: 30,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100),
//                 color: Colors.grey.withOpacity(0.1),
//               ),
//               child: const Icon(LineAwesomeIcons.angle_right,
//                   size: 18.0, color: Colors.grey))
//           : null,
//     );
//   }
// }

// class UpdateProfileScreen extends StatelessWidget {
//   const UpdateProfileScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ProfileController());
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//             onPressed: () => Get.back(),
//             icon: const Icon(LineAwesomeIcons.angle_left)),
//         title: Text(tEditProfile, style: Theme.of(context).textTheme.headline4),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(tDefaultSize),
//           child: Column(
//             children: [
//               // -- IMAGE with ICON
//               Stack(
//                 children: [
//                   SizedBox(
//                     width: 120,
//                     height: 120,
//                     child: ClipRRect(
//                         borderRadius: BorderRadius.circular(100),
//                         child: const Image(image: AssetImage(tProfileImage))),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       width: 35,
//                       height: 35,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(100),
//                           color: tPrimaryColor),
//                       child: const Icon(LineAwesomeIcons.camera,
//                           color: Colors.black, size: 20),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 50),

//               // -- Form Fields
//               Form(
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       decoration: const InputDecoration(
//                           label: Text(tFullName),
//                           prefixIcon: Icon(LineAwesomeIcons.user)),
//                     ),
//                     const SizedBox(height: tFormHeight - 20),
//                     TextFormField(
//                       decoration: const InputDecoration(
//                           label: Text(tEmail),
//                           prefixIcon: Icon(LineAwesomeIcons.envelope_1)),
//                     ),
//                     const SizedBox(height: tFormHeight - 20),
//                     TextFormField(
//                       decoration: const InputDecoration(
//                           label: Text(tPhoneNo),
//                           prefixIcon: Icon(LineAwesomeIcons.phone)),
//                     ),
//                     const SizedBox(height: tFormHeight - 20),
//                     TextFormField(
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         label: const Text(tPassword),
//                         prefixIcon: const Icon(Icons.fingerprint),
//                         suffixIcon: IconButton(
//                             icon: const Icon(LineAwesomeIcons.eye_slash),
//                             onPressed: () {}),
//                       ),
//                     ),
//                     const SizedBox(height: tFormHeight),

//                     // -- Form Submit Button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () =>
//                             Get.to(() => const UpdateProfileScreen()),
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: tPrimaryColor,
//                             side: BorderSide.none,
//                             shape: const StadiumBorder()),
//                         child: const Text(tEditProfile,
//                             style: TextStyle(color: tDarkColor)),
//                       ),
//                     ),
//                     const SizedBox(height: tFormHeight),

//                     // -- Created Date and Delete Button
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text.rich(
//                           TextSpan(
//                             text: tJoined,
//                             style: TextStyle(fontSize: 12),
//                             children: [
//                               TextSpan(
//                                   text: tJoinedAt,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 12))
//                             ],
//                           ),
//                         ),
//                         ElevatedButton(
//                           onPressed: () {},
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor:
//                                   Colors.redAccent.withOpacity(0.1),
//                               elevation: 0,
//                               foregroundColor: Colors.red,
//                               shape: const StadiumBorder(),
//                               side: BorderSide.none),
//                           child: const Text(tDelete),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
