import 'package:devcollab/Screens/Explore%20screen.dart';
import 'package:devcollab/Screens/Profilescreen.dart';
import 'package:devcollab/Screens/hackathonscreen.dart';
import 'package:devcollab/presentation/memoji/home_shell.dart';
import 'package:devcollab/providers/Request_provider.dart';
import 'package:devcollab/providers/chat_provider.dart';
import 'package:devcollab/providers/chatsprovider.dart';
import 'package:devcollab/providers/explore_provider.dart';
import 'package:devcollab/providers/hackathonprovider.dart';
import 'package:devcollab/providers/home_provider.dart';
import 'package:devcollab/providers/postproject_provider.dart';
import 'package:devcollab/providers/profileprovider.dart';
import 'package:devcollab/providers/theme_provider.dart';
import 'package:devcollab/repositories/home_repository.dart';
import 'package:devcollab/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'Screens/allproject.dart';
import 'Screens/postproject.dart';
import 'utils/app_theme.dart';
import 'Screens/Homescreen.dart';
import 'Screens/Register_Step2.dart';
import 'Screens/Registerscreen.dart';
import 'Screens/Request_screen.dart';
import 'Screens/SplashScreen.dart';
import 'Screens/allchatscreen.dart';
import 'Screens/registerstep3.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const DevCollabApp(),
    ),
  );
}

class DevCollabApp extends StatelessWidget {
  const DevCollabApp({super.key});



  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeProvider(repository: HomeRepository()),
        ),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ExploreProvider()),
        ChangeNotifierProvider(create: (_) => RequestProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ChatsProvider()),
        ChangeNotifierProvider(create: (_) => HackathonProvider()),
        ChangeNotifierProvider(create: (_) => PostProjectProvider()),
        ChangeNotifierProvider(
          create: (_) => MemojiState(),
        ),
      ],
      child: MaterialApp(
        title: 'DevCollab',
        debugShowCheckedModeBanner: false,
        theme:     AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: themeProvider.mode,
        initialRoute: '/',
        routes: {
          '/': (_) => const LoginScreen(),
          '/login':     (_) => const LoginScreen(),
          '/register':  (_) => const RegisterScreen(),
          '/register2': (_) => const RegisterScreen2(),
          '/register3': (_) => const RegisterScreen3(),
          '/explore':   (_) => const Explorescreen(),
          '/home':      (_) => const HomeScreen(),
          '/Profile':   (_) => const Profilescreen(),
          '/request':   (_) => const RequestScreen(),
          '/chat':      (_) => const AllChatsScreen(),
          '/hack':      (_) => const HackathonScreen(),
          '/postproject' : (_) => const PostProject()
        },
      ),
    );
  }
}