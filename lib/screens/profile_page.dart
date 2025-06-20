import 'package:flutter/material.dart';
import '../utils/app_colors.dart'; // Pastikan import ini benar
import '../utils/app_strings.dart'; // Pastikan import ini benar

// --- Renamed to ProfileSettingsScreen as discussed ---
class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool _appNotifications = true; // State for the toggle switch

  // --- Dialog Functions ---

  // Show "Edit Profile" Dialog
  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          // Using Dialog for more custom layout
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  // Back button
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                const SizedBox(height: 10),
                // Profile Picture Area - FIXED
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primaryGreen,
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, color: Colors.white, size: 30),
                        Text("Change Picture",
                            style:
                                TextStyle(color: Colors.white, fontSize: 10)),
                      ],
                    ),
                    // TODO: Add InkWell/GestureDetector for tap here
                  ],
                ),
                const SizedBox(height: 25),
                // Edit Fields
                _buildEditableField("Edit Name", "Buto Green"),
                const SizedBox(height: 15),
                _buildEditableField("Edit Email", "butogreen@pg.co"),
                const SizedBox(height: 30), // Space before button

                // --- SAVE CHANGES BUTTON ADDED ---
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement Save Profile Logic
                    print("Save Changes Tapped!");
                    Navigator.of(context).pop(); // Close dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  child: const Text("Save Changes",
                      style: TextStyle(color: Colors.white)),
                ),
                // --- END OF BUTTON ---
              ],
            ),
          ),
        );
      },
    );
  }

  // Show "Change Password" Dialog (Already had button)
  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 10),
                    const Text("Change Password",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),
                _buildPasswordField("Enter Old Password"),
                const SizedBox(height: 15),
                _buildPasswordField("Enter New Password"),
                const SizedBox(height: 15),
                _buildPasswordField("Re-Enter New Password"),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    print("Change Password Tapped!");
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  child: const Text("Change Password",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show "Log-out" Dialog (Already had navigation)
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: const Center(child: Text("Are You Sure?")),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.greyText),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  child: const Text("Cancel",
                      style: TextStyle(color: AppColors.darkText)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    print("Logging out...");
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (Route<dynamic> route) => false);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.redWarning),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  child: const Text("Log-out",
                      style: TextStyle(color: AppColors.redWarning)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          AppStrings.profileSettings,
          style: TextStyle(color: AppColors.darkText, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListView(
        // Using ListView as it's cleaner for settings
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        children: <Widget>[
          _buildProfileHeader(), // <-- ADDED MISSING HEADER CALL
          const SizedBox(height: 30),
          _buildSectionTitle(AppStrings.account),
          _buildSettingsOption(
            AppStrings.editProfile,
            onTap: () => _showEditProfileDialog(context),
          ),
          _buildSettingsOption(
            AppStrings.editPassword,
            onTap: () => _showChangePasswordDialog(context),
          ),
          _buildSectionTitle(AppStrings.notifications),
          _buildNotificationOption(AppStrings.appNotifications),
          _buildSectionTitle(AppStrings.others),
          _buildSettingsOption(
            AppStrings.help,
            onTap: () {/* TODO: Implement Help */},
          ),
          const SizedBox(height: 40),
          _buildLogoutOption(onTap: () => _showLogoutDialog(context)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- Helper Widgets (Defined ONCE within the State class) ---

  Widget _buildProfileHeader() {
    return const Row(
      children: [
        CircleAvatar(radius: 30, backgroundColor: AppColors.primaryGreen),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Buto Green",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText)),
            Text("butogreen@pg.co",
                style: TextStyle(fontSize: 14, color: AppColors.greyText)),
          ],
        ),
      ],
    );
  }

  Widget _buildEditableField(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style:
                    const TextStyle(color: AppColors.greyText, fontSize: 12)),
            Text(value,
                style:
                    const TextStyle(color: AppColors.darkText, fontSize: 16)),
          ],
        ),
        const Icon(Icons.edit, size: 20, color: AppColors.greyText),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText),
      ),
    );
  }

  Widget _buildSettingsOption(String title, {VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(fontSize: 15)),
          trailing: onTap != null
              ? const Icon(Icons.arrow_forward_ios,
                  size: 16, color: AppColors.greyText)
              : null,
          contentPadding: EdgeInsets.zero,
          onTap: onTap,
        ),
        const Divider(height: 1, color: AppColors.divider),
      ],
    );
  }

  Widget _buildNotificationOption(String title) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(fontSize: 15)),
          trailing: Switch(
            value: _appNotifications,
            onChanged: (bool value) {
              setState(() {
                _appNotifications = value;
              });
            },
            activeColor: AppColors.primaryGreen,
          ),
          contentPadding: EdgeInsets.zero,
        ),
        const Divider(height: 1, color: AppColors.divider),
      ],
    );
  }

  Widget _buildLogoutOption({VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          AppStrings.logout,
          style: TextStyle(fontSize: 15, color: AppColors.redWarning),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hint) {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        isDense: true,
      ),
    );
  }
}
