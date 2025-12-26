
import 'package:flutter/material.dart';
import 'package:flutter_sqflite/controllers/locale_controller.dart';
import 'package:flutter_sqflite/controllers/theme_controller.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final localController = Get.find<LocaleController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('setting'.tr),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
              'theme'.tr,
            style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Obx(
                () => SwitchListTile(
                  title:  Text(
                    themeController.isDark.value
                        ? 'dark_mode'.tr
                        :'light_mode'.tr,

                  ),
                    subtitle: Text('theme'.tr),
                    secondary: Icon(
                      themeController.isDark.value
                          ?Icons.dark_mode_outlined
                          :Icons.light_mode_outlined,
                    ),

                    value: themeController.isDark.value,
                    onChanged: (_) =>themeController.toggleTheme(),
                ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'language'.tr,
            style: const TextStyle(
              fontSize: 18,fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                Obx(
                    () => RadioListTile<String>(
                      title: const Text('English'),
                        value: 'en',
                    groupValue: localController.locale.value.languageCode,
                    onChanged: (_)=> localController.changeToEnglish(),
                    ),
                ),
                const Divider(height: 1),
                Obx(
                    ()=> RadioListTile(
                      title: const Text('العربية'),
                        value:'ar',
                        groupValue: localController.locale.value.languageCode,
                    onChanged: (_)=> localController.changeToArabic(),
                    ),
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }
}
