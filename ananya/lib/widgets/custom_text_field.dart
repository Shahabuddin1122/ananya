import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomTextField extends StatefulWidget {
  final String text;
  final TextEditingController controller;

  const CustomTextField({
    required this.text,
    required this.controller,
    super.key,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  String? _warningText;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2024, 12, 31),
    );

    if (selectedDate != null) {
      setState(() {
        widget.controller.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  bool _isValidPhoneNumber(String number) {
    final regex = RegExp(r'^(?:\+8801|01)[3-9]\d{8}$');
    return regex.hasMatch(number);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Theme.of(context).smallSubSectionDividerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 7,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: TextField(
              controller: widget.controller,
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: widget.text,
                hintStyle: const TextStyle(
                  color: ACCENT,
                ),
                border: InputBorder.none,
                suffixIcon: (widget.text == "Password" ||
                        widget.text == "পাসওয়ার্ড" ||
                        widget.text == 'New password' ||
                        widget.text == 'নতুন পাসওয়ার্ড')
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: ACCENT,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : null,
              ),
              keyboardType: (widget.text == "Phone Number" ||
                      widget.text == "মোবাইল নম্বর")
                  ? TextInputType.number
                  : TextInputType.text,
              inputFormatters: (widget.text == "Phone Number" ||
                      widget.text == "মোবাইল নম্বর")
                  ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
                  : null,
              obscureText: (widget.text == "Password" ||
                      widget.text == "পাসওয়ার্ড" ||
                      widget.text == 'New password' ||
                      widget.text == 'নতুন পাসওয়ার্ড')
                  ? _obscureText
                  : false,
              onChanged: (value) {
                if (widget.text == "Password" ||
                    widget.text == "পাসওয়ার্ড" ||
                    widget.text == 'New password' ||
                    widget.text == 'নতুন পাসওয়ার্ড') {
                  setState(() {
                    _warningText = value.length < 6
                        ? AppLocalizations.of(context)!.password_is_too_short
                        : null;
                  });
                } else if (widget.text == "Phone Number" ||
                    widget.text == "মোবাইল নম্বর") {
                  setState(() {
                    _warningText = _isValidPhoneNumber(value)
                        ? null
                        : AppLocalizations.of(context)!
                            .invalid_bangladeshi_phone_number;
                  });
                }
              },
              onTap: () {
                if (widget.text == "Date of Birth" ||
                    widget.text == "জন্ম তারিখ") {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectDate(context);
                }
              },
            ),
          ),
          if (_warningText != null)
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                _warningText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
