// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

// modified implementation of the virtual_keyboard_multi_language package:

enum PionixVirtualKeyboardKeyAction {
  Backspace,
  Return,
  Shift,
  Space,
  SwitchLanguage,
  SwitchToSpecialCharacters,
  SwitchFromSpecialCharacters,
}

class PionixVirtualKeyboardKey {
  String? text;
  String? capsText;
  final VirtualKeyboardKeyType keyType;
  final PionixVirtualKeyboardKeyAction? action;

  PionixVirtualKeyboardKey(
      {this.text, this.capsText, required this.keyType, this.action}) {
    if (text == null && action != null) {
      text = action == PionixVirtualKeyboardKeyAction.Space
          ? ' '
          : (action == PionixVirtualKeyboardKeyAction.Return ? '\n' : '');
    }
    if (capsText == null && action != null) {
      capsText = action == PionixVirtualKeyboardKeyAction.Space
          ? ' '
          : (action == PionixVirtualKeyboardKeyAction.Return ? '\n' : '');
    }
  }
}

class VirtualKeyboardPionixLayoutKeys extends VirtualKeyboardLayoutKeys {
  @override
  int getLanguagesCount() => 1;

  @override
  List<List> getLanguage(int index) {
    return _defaultEnglishLayout;
  }

  bool specialCharacters = false;

  @override
  List<List> get activeLayout => getLayout();

  void switchSpecialCharacters(sp) {
    specialCharacters = sp;
  }

  List<List> getLayout() {
    // debugPrint("getLayout: $specialCharacters");
    if (specialCharacters) {
      return _defaultSpecialCharactersLayout;
    } else {
      return _defaultEnglishLayout;
    }
  }

  List<List> getSpecialCharacters() {
    return _defaultSpecialCharactersLayout;
  }
}

/// Keys for Virtual Keyboard's rows.
const List<List> _defaultEnglishLayout = [
  // Row 1
  ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
  // Row 2
  [
    'q',
    'w',
    'e',
    'r',
    't',
    'y',
    'u',
    'i',
    'o',
    'p',
    PionixVirtualKeyboardKeyAction.Backspace
  ],
  // Row 3
  [
    'a',
    's',
    'd',
    'f',
    'g',
    'h',
    'j',
    'k',
    'l',
    ';',
    '\'',
    PionixVirtualKeyboardKeyAction.Return
  ],
  // Row 4
  [
    PionixVirtualKeyboardKeyAction.Shift,
    'z',
    'x',
    'c',
    'v',
    'b',
    'n',
    'm',
    ',',
    '.',
    '/',
    PionixVirtualKeyboardKeyAction.Shift
  ],
  // Row 5
  [
    PionixVirtualKeyboardKeyAction.SwitchToSpecialCharacters,
    '@',
    PionixVirtualKeyboardKeyAction.Space,
    '&',
    '_'
  ],
];

const List<List> _defaultSpecialCharactersLayout = [
  // Row 1
  ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
  // Row 2
  [
    '@',
    '#',
    '\$',
    '_',
    '&',
    '-',
    '+',
    '(',
    ')',
    '/',
    PionixVirtualKeyboardKeyAction.Backspace
  ],
  // Row 3
  [
    '*',
    '"',
    '\'',
    ':',
    ';',
    '!',
    '?',
    '[',
    ']',
    '{',
    '}',
    PionixVirtualKeyboardKeyAction.Return
  ],
  // Row 4
  [
    PionixVirtualKeyboardKeyAction.Shift,
    '~',
    '`',
    '|',
    '^',
    '°',
    '=',
    '\\',
    '%',
    '€',
    '§',
    PionixVirtualKeyboardKeyAction.Shift
  ],
  // Row 5
  [
    PionixVirtualKeyboardKeyAction.SwitchFromSpecialCharacters,
    '<',
    PionixVirtualKeyboardKeyAction.Space,
    '>',
    '_'
  ],
];

/// The default keyboard height. Can be overridden by passing
///  `height` argument to `VirtualKeyboard` widget.
const double _virtualKeyboardDefaultHeight = 300;

const int _virtualKeyboardBackspaceEventPeriod = 250;

/// Virtual Keyboard widget.
class PionixVirtualKeyboard extends StatefulWidget {
  /// Keyboard Type: Should be initiated in creation time.
  final VirtualKeyboardType type;

  /// Callback for Key press event. Called with pressed `Key` object.
  final Function? onKeyPress;

  /// Virtual keyboard height. Default is 300
  final double height;

  /// Virtual keyboard height. Default is full screen width
  final double? width;

  /// Color for key texts and icons.
  final Color textColor;

  /// Font size for keyboard keys.
  final double fontSize;

  /// the custom layout for multi or single language
  final VirtualKeyboardPionixLayoutKeys? customLayoutKeys;

  /// the text controller go get the output and send the default input
  final TextEditingController? textController;

  /// The builder function will be called for each Key object.
  final Widget Function(BuildContext context, PionixVirtualKeyboardKey key)?
      builder;

  /// Set to true if you want only to show Caps letters.
  final bool alwaysCaps;

  /// inverse the layout to fix the issues with right to left languages.
  final bool reverseLayout;

  final bool specialCharacters;

  /// used for multi-languages with default layouts, the default is English only
  /// will be ignored if customLayoutKeys is not null
  final List<VirtualKeyboardDefaultLayouts>? defaultLayouts;

  const PionixVirtualKeyboard(
      {super.key,
      required this.type,
      this.onKeyPress,
      this.builder,
      this.width,
      this.defaultLayouts,
      this.customLayoutKeys,
      this.textController,
      this.reverseLayout = false,
      this.specialCharacters = false,
      this.height = _virtualKeyboardDefaultHeight,
      this.textColor = Colors.black,
      this.fontSize = 14,
      this.alwaysCaps = false});

  @override
  State<StatefulWidget> createState() {
    return _VirtualKeyboardState();
  }
}

/// Holds the state for Virtual Keyboard class.
class _VirtualKeyboardState extends State<PionixVirtualKeyboard> {
  VirtualKeyboardType type = VirtualKeyboardType.Alphanumeric;
  Function? onKeyPress;
  TextEditingController textController = TextEditingController();

  /// The builder function will be called for each Key object.
  Widget Function(BuildContext context, PionixVirtualKeyboardKey key)? builder;
  late double height;
  double? width;
  late Color textColor;
  late double fontSize;
  late bool alwaysCaps;
  late bool reverseLayout;
  late VirtualKeyboardPionixLayoutKeys customLayoutKeys;

  /// Text Style for keys.
  late TextStyle textStyle;

  /// True if shift is enabled.
  bool isShiftEnabled = false;
  bool isSpecialCharactersEnabled = false;

  void _onKeyPress(PionixVirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      textController.text += (isShiftEnabled ? key.capsText! : key.text!);
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case PionixVirtualKeyboardKeyAction.Backspace:
          if (textController.text.isEmpty) return;
          textController.text =
              textController.text.substring(0, textController.text.length - 1);
          break;
        case PionixVirtualKeyboardKeyAction.Return:
          textController.text += '\n';
          break;
        case PionixVirtualKeyboardKeyAction.Space:
          textController.text += key.text!;
          break;
        case PionixVirtualKeyboardKeyAction.Shift:
          break;
        default:
      }
    }

    if (onKeyPress != null) onKeyPress!(key);
  }

  @override
  dispose() {
    if (widget.textController == null) {
      textController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(PionixVirtualKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      type = widget.type;
      onKeyPress = widget.onKeyPress;
      height = widget.height;
      width = widget.width;
      textColor = widget.textColor;
      fontSize = widget.fontSize;
      alwaysCaps = widget.alwaysCaps;
      reverseLayout = widget.reverseLayout;
      textController = widget.textController ?? textController;
      // Init the Text Style for keys.
      textStyle = TextStyle(
        fontSize: fontSize,
        color: textColor,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    textController = widget.textController ?? TextEditingController();
    width = widget.width;
    type = widget.type;
    customLayoutKeys =
        widget.customLayoutKeys ?? VirtualKeyboardPionixLayoutKeys();
    onKeyPress = widget.onKeyPress;
    height = widget.height;
    textColor = widget.textColor;
    fontSize = widget.fontSize;
    alwaysCaps = widget.alwaysCaps;
    reverseLayout = widget.reverseLayout;
    // Init the Text Style for keys.
    textStyle = TextStyle(
      fontSize: fontSize,
      color: textColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _alphanumeric();
  }

  Widget _alphanumeric() {
    return SizedBox(
      height: height,
      width: width ?? MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _rows(),
      ),
    );
  }

  /// Returns a list of `VirtualKeyboardKey` objects.
  List<PionixVirtualKeyboardKey> _getKeyboardRowKeys(
      VirtualKeyboardPionixLayoutKeys layoutKeys, rowNum) {
    // Generate VirtualKeyboardKey objects for each row.
    return List.generate(layoutKeys.activeLayout[rowNum].length, (int keyNum) {
      // Get key string value.
      if (layoutKeys.activeLayout[rowNum][keyNum] is String) {
        String key = layoutKeys.activeLayout[rowNum][keyNum];

        // Create and return new VirtualKeyboardKey object.
        return PionixVirtualKeyboardKey(
          text: key,
          capsText: key.toUpperCase(),
          keyType: VirtualKeyboardKeyType.String,
        );
      } else {
        var action = layoutKeys.activeLayout[rowNum][keyNum]
            as PionixVirtualKeyboardKeyAction;
        return PionixVirtualKeyboardKey(
            keyType: VirtualKeyboardKeyType.Action, action: action);
      }
    });
  }

  /// Returns a list of VirtualKeyboard rows with `VirtualKeyboardKey` objects.
  List<List<PionixVirtualKeyboardKey>> _getKeyboardRows(
      VirtualKeyboardPionixLayoutKeys layoutKeys) {
    // Generate lists for each keyboard row.
    return List.generate(layoutKeys.activeLayout.length,
        (int rowNum) => _getKeyboardRowKeys(layoutKeys, rowNum));
  }

  /// Returns the rows for keyboard.
  List<Widget> _rows() {
    // Get the keyboard Rows
    List<List<PionixVirtualKeyboardKey>> keyboardRows =
        _getKeyboardRows(customLayoutKeys);

    // Generate keyboard row.
    List<Widget> rows = List.generate(keyboardRows.length, (int rowNum) {
      var items = List.generate(keyboardRows[rowNum].length, (int keyNum) {
        // Get the VirtualKeyboardKey object.
        PionixVirtualKeyboardKey virtualKeyboardKey =
            keyboardRows[rowNum][keyNum];

        Widget keyWidget;

        // Check if builder is specified.
        // Call builder function if specified or use default
        //  Key widgets if not.
        if (builder == null) {
          // Check the key type.
          switch (virtualKeyboardKey.keyType) {
            case VirtualKeyboardKeyType.String:
              // Draw String key.
              keyWidget = _keyboardDefaultKey(virtualKeyboardKey);
              break;
            case VirtualKeyboardKeyType.Action:
              // Draw action key.
              keyWidget = _keyboardDefaultActionKey(virtualKeyboardKey);
              break;
          }
        } else {
          // Call the builder function, so the user can specify custom UI for keys.
          keyWidget = builder!(context, virtualKeyboardKey);
        }

        return keyWidget;
      });

      if (reverseLayout) items = items.reversed.toList();
      return Material(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          // Generate keyboard keys
          children: items,
        ),
      );
    });

    return rows;
  }

  // True if long press is enabled.
  bool longPress = false;

  /// Creates default UI element for keyboard Key.
  Widget _keyboardDefaultKey(PionixVirtualKeyboardKey key) {
    return Expanded(
      child: InkWell(
        onTap: () {
          _onKeyPress(key);
        },
        child: SizedBox(
          height: height / customLayoutKeys.activeLayout.length,
          child: Center(
            child: Text(
              alwaysCaps
                  ? key.capsText!
                  : (isShiftEnabled ? key.capsText! : key.text!),
              style: textStyle,
            ),
          ),
        ),
      ),
    );
  }

  /// Creates default UI element for keyboard Action Key.
  Widget _keyboardDefaultActionKey(PionixVirtualKeyboardKey key) {
    // Holds the action key widget.
    Widget actionKey;

    // Switch the action type to build action Key widget.
    switch (key.action!) {
      case PionixVirtualKeyboardKeyAction.Backspace:
        actionKey = GestureDetector(
          onLongPress: () {
            longPress = true;
            // Start sending backspace key events while longPress is true
            Timer.periodic(
              const Duration(
                  milliseconds: _virtualKeyboardBackspaceEventPeriod),
              (timer) {
                if (longPress) {
                  _onKeyPress(key);
                } else {
                  // Cancel timer.
                  timer.cancel();
                }
              },
            );
          },
          onLongPressUp: () {
            // Cancel event loop
            longPress = false;
          },
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Icon(
              Icons.backspace,
              color: textColor,
            ),
          ),
        );
        break;
      case PionixVirtualKeyboardKeyAction.Shift:
        actionKey = Icon(
          Icons.arrow_upward,
          color: textColor,
        );
        break;
      case PionixVirtualKeyboardKeyAction.Space:
        actionKey = actionKey = Icon(
          Icons.space_bar,
          color: textColor,
        );
        break;
      case PionixVirtualKeyboardKeyAction.Return:
        actionKey = Icon(
          Icons.keyboard_return,
          color: textColor,
        );
        break;
      case PionixVirtualKeyboardKeyAction.SwitchLanguage:
        actionKey = GestureDetector(
          onTap: () {
            setState(
              () {
                customLayoutKeys.switchLanguage();
              },
            );
          },
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Icon(
              Icons.language,
              color: textColor,
            ),
          ),
        );
        break;
      case PionixVirtualKeyboardKeyAction.SwitchToSpecialCharacters:
        actionKey = GestureDetector(
            onTap: () {
              setState(
                () {
                  // widget.specialCharacters = true;
                  isSpecialCharactersEnabled = true;
                  customLayoutKeys
                      .switchSpecialCharacters(isSpecialCharactersEnabled);
                },
              );
            },
            child: SizedBox(child: Text("?123", style: textStyle)));
        break;
      case PionixVirtualKeyboardKeyAction.SwitchFromSpecialCharacters:
        actionKey = GestureDetector(
            onTap: () {
              setState(
                () {
                  isSpecialCharactersEnabled = false;
                  customLayoutKeys
                      .switchSpecialCharacters(isSpecialCharactersEnabled);
                },
              );
            },
            child: SizedBox(child: Text("ABC", style: textStyle)));
        break;
    }

    var widget = InkWell(
      onTap: () {
        if (key.action == PionixVirtualKeyboardKeyAction.Shift) {
          if (!alwaysCaps) {
            setState(
              () {
                isShiftEnabled = !isShiftEnabled;
              },
            );
          }
        }

        _onKeyPress(key);
      },
      child: Container(
        alignment: Alignment.center,
        height: height / customLayoutKeys.activeLayout.length,
        child: actionKey,
      ),
    );

    if (key.action == PionixVirtualKeyboardKeyAction.Space) {
      return SizedBox(
          width: (width ?? MediaQuery.of(context).size.width) / 2,
          child: widget);
    } else {
      return Expanded(child: widget);
    }
  }
}
