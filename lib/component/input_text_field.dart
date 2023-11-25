import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  final String labelTitle;
  final TextEditingController controller;
  final String? hint, errorMessage;
  late bool? isVisible;
  late bool? isPassword;
  late bool? isDropDown;
  late bool? isReadOnly;
  late bool? isCalendarMonth;
  late bool? isCalendarTime;
  final List<String>? dropdownItems;
  final VoidCallback? onPressedSuffixIcon;
  Function(String)? onChangedDropdown;
  Function()? onTap;
  final TextInputType? keyboardType;

  InputTextField({
    Key? key,
    required this.labelTitle,
    required this.controller,
    this.hint,
    this.errorMessage,
    this.isVisible = false,
    this.isPassword = false,
    this.isDropDown = false,
    this.isReadOnly = false,
    this.isCalendarMonth = false,
    this.isCalendarTime = false,
    this.dropdownItems,
    this.onPressedSuffixIcon,
    this.onChangedDropdown,
    this.onTap,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelTitle),
        const SizedBox(height: 10),
        !isDropDown!
            ? TextFormField(
                onTap: onTap,
                readOnly: isReadOnly!,
                obscureText: isVisible!,
                controller: controller,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "$hint",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8 * 5),
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8 * 5),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
                  hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                  labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 14),
                  errorMaxLines: 2,
                  suffixIcon: isPassword!
                      ? IconButton(
                          onPressed: onPressedSuffixIcon,
                          icon: !isVisible!
                              ? const Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.grey,
                                )
                              : const Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                        )
                      : isCalendarMonth!
                          ? const Icon(Icons.calendar_month)
                          : isCalendarTime!
                              ? const Icon(Icons.lock_clock)
                              : null,
                ),
              )
            : DropdownButtonFormField<String>(
                value: null,
                items: dropdownItems!.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (selectedItem) {
                  onChangedDropdown!(selectedItem!);
                },
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "$hint",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8 * 5),
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8 * 5),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                  errorMaxLines: 2,
                  suffixIcon: isPassword!
                      ? IconButton(
                          onPressed: onPressedSuffixIcon,
                          icon: !isVisible!
                              ? const Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.grey,
                                )
                              : const Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                        )
                      : null,
                ),
              ),
        const SizedBox(height: 10),
      ],
    );
  }
}
