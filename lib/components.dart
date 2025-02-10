import 'package:caspernet/bloc/theme/theme_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    ThemeBloc themeBloc = BlocProvider.of<ThemeBloc>(context);
    return AppBar(
      title: Text(widget.title),
      //   backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      actions: [
        IconButton(
          onPressed: () {
            themeBloc.add(ToggleThemeEvent());
          },
          icon: Icon(
            themeBloc.state.themeMode == ThemeMode.light
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
        ),
      ],
    );
  }
}
