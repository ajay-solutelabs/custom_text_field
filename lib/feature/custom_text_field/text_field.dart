import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextFieldSTL extends StatefulWidget {
  const CustomTextFieldSTL({
    Key? containerKey,
    this.text,
    this.labelText,
    this.labelStyle,
    this.hintText,
    this.textCapitalization,
    this.onTextChanged,
    this.onValidation,
    this.textInputType = TextInputType.text,
    this.textInputAction,
    this.inputFormatters,
    this.errorText,
    this.hasError = false,
    this.enabled = true,
    this.obscureText = false,
    this.autoFocus = false,
    this.focusNode,
    this.hintStyle,
    this.onFocused,
    this.onUnfocused,
    this.suffix,
    this.backgroundColor,
    this.minLines,
    this.maxLines,
    this.maxHeight,
    this.contentPadding,
  }) : super(key: containerKey);

  final String? text;
  final String? labelText;
  final TextStyle? labelStyle;
  final String? hintText;
  final String? errorText;
  final TextStyle? hintStyle;
  final TextCapitalization? textCapitalization;
  final bool? hasError;
  final void Function(String)? onTextChanged;
  final String? Function(String?)? onValidation;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final bool? obscureText;
  final FocusNode? focusNode;
  final bool? autoFocus;
  final VoidCallback? onFocused;
  final VoidCallback? onUnfocused;
  final Widget? suffix;
  final Color? backgroundColor;
  final int? minLines;
  final int? maxLines;
  final double? maxHeight;
  final EdgeInsets? contentPadding;

  @override
  _CustomTextFieldSTLState createState() => _CustomTextFieldSTLState();
}

class _CustomTextFieldSTLState extends State<CustomTextFieldSTL> {
  final _controller = TextEditingController();
  FocusNode? _focusNode;
  bool? _isObscured;

  Color darkGrey = const Color(0xFF666666);
  Color lightGrey = const Color(0xFFF2F2F2);
  Color black = const Color(0xFF1E1E1E);
  Color red = const Color(0xFFE97C64);

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode!.addListener(_onFocusChanged);
    _isObscured = widget.obscureText;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _focusNode!.removeListener(_onFocusChanged);
    _controller.dispose();
  }

  void _onFocusChanged() => setState(
        () {
      if (_focusNode!.hasFocus) {
        widget.onFocused?.call();
      } else {
        widget.onUnfocused?.call();
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    if (widget.text == null) {
      _controller.clear();
    } else if (_controller.text != widget.text) {
      _controller.text = widget.text!;
    }

    final fillColor = widget.enabled!
        ? widget.backgroundColor ?? Colors.white
        : lightGrey;

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (widget.labelText != null && widget.labelText!.isNotEmpty) ...[
            Text(
              widget.labelText!,
              style: widget.labelStyle ?? Theme.of(context).textTheme.headline5!.copyWith(
                color: darkGrey,
              ),
            ),
            const SizedBox(height: 1.5 * 4)
          ],
          Container(
            height: widget.maxHeight,
            decoration: BoxDecoration(
              boxShadow: _focusNode!.hasFocus ? [
                const BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 20,
                ),
              ] : null,
            ),
            child: TextFormField(
              textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
              minLines: widget.minLines,
              maxLines: widget.maxLines ?? 1,
              key: widget.key,
              autofocus: widget.autoFocus!,
              focusNode: _focusNode,
              enabled: widget.enabled,
              controller: _controller,
              cursorColor: black,
              keyboardType: widget.textInputType,
              textInputAction: widget.textInputAction,
              obscureText: _isObscured!,
              inputFormatters: [
                ...?widget.inputFormatters
              ],
              style: widget.labelStyle ?? Theme.of(context).textTheme.bodyText1!.copyWith(
                color: black,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: fillColor,
                contentPadding: widget.contentPadding ??
                    const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                hintText: widget.hintText,
                hintStyle: widget.hintStyle ?? Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: const Color(0xFFDADADA),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: widget.hasError! || widget.errorText != null
                        ? red
                        : lightGrey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: widget.obscureText!
                    ? Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      _isObscured!
                          ? 'lib/assets/password_hidden.svg'
                          : 'lib/assets/password_visible.svg',
                    ),
                    onPressed: () {
                      setState(() => _isObscured = !_isObscured!);
                    },
                  ),
                )
                    : widget.suffix,
              ),
              onChanged: widget.onTextChanged,
              validator: widget.onValidation,
            ),
          ),
          if (widget.errorText != null) ...[
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset('lib/assets/alert.svg'),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.errorText!,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                    !.copyWith(color: red),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
