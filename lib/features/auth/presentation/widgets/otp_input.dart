import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/font_weight_helper.dart';
import '../../../../core/theme/values_manager.dart';

class OTPInput extends StatefulWidget {
  final int length;
  final Function(String) onCompleted;
  final Function(String)? onChanged;

  const OTPInput({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
  });

  @override
  State<OTPInput> createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  String currentPin = '';

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    focusNodes = List.generate(widget.length, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _updatePin() {
    currentPin = controllers.map((controller) => controller.text).join();
    if (widget.onChanged != null) {
      widget.onChanged!(currentPin);
    }
    if (currentPin.length == widget.length) {
      widget.onCompleted(currentPin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 50,
          height: 60,
          child: TextFormField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: const TextStyle(
              fontSize: FontSize.s24,
              fontWeight: FontWeight.bold,
              color: AppPallete.blackForText,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                borderSide: const BorderSide(
                  color: AppPallete.borderColor,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                borderSide: const BorderSide(
                  color: AppPallete.borderColor,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                borderSide: const BorderSide(
                  color: AppPallete.primaryColor,
                  width: 2.0,
                ),
              ),
              filled: true,
              fillColor: AppPallete.white,
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (index < widget.length - 1) {
                  focusNodes[index + 1].requestFocus();
                }
              } else {
                if (index > 0) {
                  focusNodes[index - 1].requestFocus();
                }
              }
              _updatePin();
            },
          ),
        );
      }),
    );
  }
}
