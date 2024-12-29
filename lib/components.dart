import 'package:caspernet/themeconfig.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const MyAppBar({
    required this.title,
    super.key,
  });

  @override
  MyAppBarState createState() => MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class MyAppBarState extends State<MyAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      actions: [
        Consumer<ThemeModeProvider>(
            builder: (themeContext, ThemeModeProvider themeModeProvider, _) {
          return IconButton(
            onPressed: () {
              themeContext.read<ThemeModeProvider>().toggleTheme();
            },
            icon: Icon(
              Theme.of(themeContext).brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
          );
        }),
      ],
    );
  }
}
