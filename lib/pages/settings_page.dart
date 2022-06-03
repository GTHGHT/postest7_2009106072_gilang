import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/settings_notifier.dart';
import '../utils/theme_notifier.dart';

class SettingsPage extends StatelessWidget {
  final Map<String, String> _languageMap = const {
    "en": "English",
    "id": "Indonesia",
    "de": "Deutsch",
    "sp": "Español",
    "pt": "Português",
    "ja": "日本",
  };

  const SettingsPage({Key? key}) : super(key: key);

  String getThemeModeString(ThemeMode mode) {
    if (mode == ThemeMode.system) {
      return "Pengaturan Sistem";
    } else if (mode == ThemeMode.dark) {
      return "Gelap";
    } else {
      return "Terang";
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final cityWidget = context
        .watch<SettingsNotifier>()
        .editCity
        ? ListTile(
      key: const ValueKey(1),
      tileColor: Theme
          .of(context)
          .bottomAppBarColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      title: TextField(
        decoration: InputDecoration(
          hintText: "Kota",
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onSubmitted: (value) {
          context
              .read<SettingsNotifier>()
              .city = value;
          context
              .read<SettingsNotifier>()
              .editCity = false;
          showSnackBar(context, "Kota berubah menjadi $value");
        },
      ),
      trailing: SizedBox(
        width: 52,
        height: 52,
        child: ElevatedButton(
          child: const Icon(
            Icons.location_pin,
          ),
          onPressed: () {
            context
                .read<SettingsNotifier>()
                .city = "Samarinda";
            context
                .read<SettingsNotifier>()
                .editCity = false;
          },
        ),
      ),
    )
        : ListTile(
      key: const ValueKey(2),
      tileColor: Theme
          .of(context)
          .bottomAppBarColor,
      contentPadding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Kota"),
          Text(context
              .watch<SettingsNotifier>()
              .city),
        ],
      ),
      trailing: SizedBox(
        width: 40,
        child: TextButton(
          onPressed: () {
            context
                .read<SettingsNotifier>()
                .editCity = true;
          },
          child: const Icon(
            Icons.edit,
            color: Colors.grey,
          ),
        ),
      ),
    );

    return ListView(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(-0.5, 0),
              end: const Offset(0, 0),
            ).animate(animation);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: offsetAnimation,
                child: child,
              ),
            );
          },
          child: cityWidget,
        ),
        ExpansionPanelList(
          animationDuration: const Duration(milliseconds: 500),
          expandedHeaderPadding: const EdgeInsets.all(10),
          expansionCallback: (index, value) =>
              context.read<SettingsNotifier>().changeIsOpen(index, !value),
          children: [
            ExpansionPanel(
              canTapOnHeader: true,
              headerBuilder: (_, __) =>
                  ExpansionPanelHeader(
                    leadingString: "Tema",
                    trailingString: getThemeModeString(
                      context
                          .watch<ThemeNotifier>()
                          .themeMode,
                    ),
                  ),
              isExpanded: context
                  .watch<SettingsNotifier>()
                  .isOpen[0],
              body: Column(
                children: [
                  ListTileRadio(
                    titleString: "Menggunakan Pengaturan Sistem",
                    onTap: () {
                      context
                          .read<ThemeNotifier>()
                          .changeTheme(ThemeMode.system);
                      showSnackBar(context,
                          "Tema berubah menjadi Menggunakan Pengaturan Sistem");
                    },
                    groupValue: context
                        .watch<ThemeNotifier>()
                        .themeMode,
                    value: ThemeMode.system,
                  ),
                  ListTileRadio(
                    titleString: "Terang",
                    onTap: () {
                      context
                          .read<ThemeNotifier>()
                          .changeTheme(ThemeMode.light);
                      showSnackBar(context, "Tema berubah menjadi Terang");
                    },
                    groupValue: context
                        .watch<ThemeNotifier>()
                        .themeMode,
                    value: ThemeMode.light,
                  ),
                  ListTileRadio(
                    titleString: "Gelap",
                    onTap: () {
                      context.read<ThemeNotifier>().changeTheme(ThemeMode.dark);
                      showSnackBar(context, "Tema berubah menjadi Terang");
                    },
                    groupValue: context
                        .watch<ThemeNotifier>()
                        .themeMode,
                    value: ThemeMode.dark,
                  ),
                ],
              ),
            ),
            ExpansionPanel(
              canTapOnHeader: true,
              headerBuilder: (_, __) =>
                  ExpansionPanelHeader(
                    leadingString: "Sistem Pengukuran",
                    trailingString: context
                        .watch<SettingsNotifier>()
                        .isMetric
                        ? "Metrik"
                        : "Imperial",
                  ),
              isExpanded: context
                  .watch<SettingsNotifier>()
                  .isOpen[1],
              body: ListTile(
                leading: Checkbox(
                  value: context
                      .watch<SettingsNotifier>()
                      .isMetric,
                  onChanged: (bool? value) {
                    context
                        .read<SettingsNotifier>()
                        .isMetric = value ?? false;
                    showSnackBar(context,
                        "Sistem Pengukuran berubah menjadi ${value ?? false
                            ? 'Metrik'
                            : 'Imperial'}");
                  },
                ),
                title: const Text("Menggunakan Metrik?"),
                onTap: () {
                  context
                      .read<SettingsNotifier>()
                      .isMetric =
                  !(context
                      .read<SettingsNotifier>()
                      .isMetric);
                },
              ),
            ),
            ExpansionPanel(
              canTapOnHeader: true,
              headerBuilder: (_, __) =>
                  ExpansionPanelHeader(
                    leadingString: "Bahasa",
                    trailingString: context
                        .watch<SettingsNotifier>()
                        .language,
                  ),
              isExpanded: context
                  .watch<SettingsNotifier>()
                  .isOpen[2],
              body: Column(
                children: _languageMap.values.map((String e) {
                  return ListTileRadio(
                    titleString: e,
                    groupValue: context
                        .watch<SettingsNotifier>()
                        .language,
                    value: e,
                    onTap: () {
                      context
                          .read<SettingsNotifier>()
                          .language = e;
                      showSnackBar(context, "Bahasa berubah menjadi $e");
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ListTileRadio extends StatelessWidget {
  final String titleString;
  final VoidCallback onTap;
  final Object groupValue;
  final Object value;

  const ListTileRadio({
    Key? key,
    required this.titleString,
    required this.onTap,
    required this.groupValue,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(titleString),
      onTap: onTap,
      leading: Radio(
        value: value,
        groupValue: groupValue,
        onChanged: (value) {
          onTap();
        },
      ),
    );
  }
}

class ExpansionPanelHeader extends StatelessWidget {
  final String leadingString;
  final String trailingString;

  const ExpansionPanelHeader({
    Key? key,
    required this.leadingString,
    required this.trailingString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            leadingString,
            style: Theme
                .of(context)
                .textTheme
                .subtitle1,
          ),
          Text(
            trailingString,
            style: Theme
                .of(context)
                .textTheme
                .subtitle1,
          ),
        ],
      ),
    );
  }
}