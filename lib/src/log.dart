/// This file contains the implementation of the Log class, which provides logging functionality for messages.
/// It also defines text decorations, colors, and backgrounds for formatting log messages.
///
/// The Log class includes methods for logging information, success, navigation, and error messages.
/// Each log message is formatted with a timestamp, message type, and message content.
///
/// The log messages are output using the `dart:developer` library, which allows for logging with different levels and zones.
/// The log messages are displayed with colored backgrounds and text, providing visual distinction between different message types.
///
/// Example usage:
///
/// ```dart
/// Log.info('This is an information message', path: '/path/to/file.dart');
/// Log.success('This is a success message', path: '/path/to/file.dart');
/// Log.navigate('This is a navigation message');
/// Log.error('This is an error message', path: '/path/to/file.dart');
/// ```
///
/// Note: This code uses ANSI escape codes for text formatting and colors, which may not be supported in all environments.
/// It is recommended to test the log output in the target environment to ensure proper display of formatted messages.
library;
// ignore_for_file: lines_longer_than_80_chars

// Importing necessary libraries
import 'dart:async';
import 'dart:developer' as developer;

// Defining text decorations
const String reset = '\x1B[0m';

class TextDecorations {
  String get bold => '\u001b[1m';
  String get underline => '\u001b[4m';
  String get reversed => '\u001b[7m';
}

// Defining text colors
class TextColors {
  String get black => '\u001b[30m';
  String get red => '\u001b[31m';
  String get green => '\u001b[32m';
  String get yellow => '\u001b[33m';
  String get blue => '\u001b[34m';
  String get magenta => '\u001b[35m';
  String get cyan => '\u001b[36m';
  String get white => '\u001b[37m';
}

// Defining text backgrounds
class TextBackgrounds {
  String get black => '\u001b[40m';
  String get red => '\u001b[41m';
  String get green => '\u001b[42m';
  String get yellow => '\u001b[43m';
  String get blue => '\u001b[44m';
  String get magenta => '\u001b[45m';
  String get cyan => '\u001b[46m';
  String get white => '\u001b[47m';
}

// Log class for logging messages
class Log {
  factory Log() => instance;
  Log._instance() : super();
  static final Log instance = Log._instance();

  // Log an information message
  static void info(dynamic msg, {String? path}) {
    final colors = TextColors();
    final backgrounds = TextBackgrounds();
    final time =
        "${DateTime.now().hour < 10 ? "0${DateTime.now().hour}" : DateTime.now().hour}.${DateTime.now().minute < 10 ? "0${DateTime.now().minute}" : DateTime.now().minute}.${DateTime.now().second < 10 ? "0${DateTime.now().second}" : DateTime.now().second}.${DateTime.now().millisecond < 10 ? "00${DateTime.now().millisecond}" : DateTime.now().millisecond < 100 && DateTime.now().millisecond > 10 ? "0${DateTime.now().millisecond}" : DateTime.now().millisecond}";

    final name = '$path, $time$reset';
    developer.log(
      '${backgrounds.white} 🫵 ${colors.black}INFO 🫵 ${colors.black}${backgrounds.yellow}  $msg  $reset',
      name: name,
      zone: Zone.root,
    );
  }

  // Log a success message
  static void success(dynamic msg, {String? path}) {
    final colors = TextColors();
    final backgrounds = TextBackgrounds();
    final time =
        "${DateTime.now().hour < 10 ? "0${DateTime.now().hour}" : DateTime.now().hour}.${DateTime.now().minute < 10 ? "0${DateTime.now().minute}" : DateTime.now().minute}.${DateTime.now().second < 10 ? "0${DateTime.now().second}" : DateTime.now().second}.${DateTime.now().millisecond < 10 ? "00${DateTime.now().millisecond}" : DateTime.now().millisecond < 100 && DateTime.now().millisecond > 10 ? "0${DateTime.now().millisecond}" : DateTime.now().millisecond}";
    final name = '$path, $time$reset';

    developer.log(
      '${backgrounds.white} ✅ ${backgrounds.green}${colors.black}  $msg  $reset',
      name: name,
      zone: Zone.root,
    );
  }

  // Log a navigation message
  static void navigate(dynamic msg, {String? path}) {
    final colors = TextColors();
    final backgrounds = TextBackgrounds();
    final time =
        "${DateTime.now().hour < 10 ? "0${DateTime.now().hour}" : DateTime.now().hour}.${DateTime.now().minute < 10 ? "0${DateTime.now().minute}" : DateTime.now().minute}.${DateTime.now().second < 10 ? "0${DateTime.now().second}" : DateTime.now().second}.${DateTime.now().millisecond < 10 ? "00${DateTime.now().millisecond}" : DateTime.now().millisecond < 100 && DateTime.now().millisecond > 10 ? "0${DateTime.now().millisecond}" : DateTime.now().millisecond}";
    final name = 'Navigation, $time$reset';

    developer.log(
      '${backgrounds.black} ➡️  ${backgrounds.white}${colors.black}  $msg  $reset',
      name: name,
      zone: Zone.root,
    );
  }

  // Log an error message
  static void error(dynamic msg, {String? path}) {
    final colors = TextColors();
    final backgrounds = TextBackgrounds();
    final time =
        "${DateTime.now().hour < 10 ? "0${DateTime.now().hour}" : DateTime.now().hour}.${DateTime.now().minute < 10 ? "0${DateTime.now().minute}" : DateTime.now().minute}.${DateTime.now().second < 10 ? "0${DateTime.now().second}" : DateTime.now().second}.${DateTime.now().millisecond < 10 ? "00${DateTime.now().millisecond}" : DateTime.now().millisecond < 100 && DateTime.now().millisecond > 10 ? "0${DateTime.now().millisecond}" : DateTime.now().millisecond}";
    final name = '$path, $time$reset';

    developer.log(
      '${backgrounds.white} 👹 ${colors.white}ERROR 👹 ${colors.white}${backgrounds.red}  $msg  $reset',
      name: name,
      zone: Zone.root,
    );
  }
}

/*  if (e.response != null) {
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
 */
// Add your pub packages here
