import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_form_builder/src/form_builder.dart';
import 'package:flutter_form_builder/src/form_builder_field.dart';

class FormBuilderTextField extends StatefulWidget {
  final String label;
  final String attribute;
  final String type;
  final bool readonly;
  final String hint;
  final dynamic value;
  final bool require;
  final dynamic min;
  final dynamic max;
  final FormFieldValidator<dynamic> validator;

  FormBuilderTextField(
      {@required this.label,
      @required this.type,
      @required this.attribute,
      this.readonly = false,
      this.hint,
      this.value,
      this.require = false,
      this.validator,
      this.min,
      this.max})
      : assert(min == null || min is int),
        assert(max == null || max is int);

  @override
  _FormBuilderTextFieldState createState() => _FormBuilderTextFieldState();
}

class _FormBuilderTextFieldState extends State<FormBuilderTextField> {
  dynamic _value;

  initState() {
    super.initState();
    _value = widget.value;
  }

  updateValue(value) {
    setState(() {
      _value = value;
      FormBuilder.of(context).updateAttributeValue(widget.attribute, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextInputType keyboardType;
    switch (widget.type) {
      case FormBuilder.TYPE_NUMBER:
        keyboardType = TextInputType.number;
        break;
      case FormBuilder.TYPE_EMAIL:
        keyboardType = TextInputType.emailAddress;
        break;
      case FormBuilder.TYPE_URL:
        keyboardType = TextInputType.url;
        break;
      case FormBuilder.TYPE_PHONE:
        keyboardType = TextInputType.phone;
        break;
      case FormBuilder.TYPE_MULTILINE_TEXT:
        keyboardType = TextInputType.multiline;
        break;
      default:
        keyboardType = TextInputType.text;
        break;
    }
    
    return TextFormField(
      key: Key(widget.attribute),
      enabled: !(FormBuilder.of(context).widget.readonly || widget.readonly),
      style: (FormBuilder.of(context).widget.readonly || widget.readonly)
          ? Theme.of(context).textTheme.subhead.copyWith(
                color: Theme.of(context).disabledColor,
              )
          : null,
      focusNode: (FormBuilder.of(context).widget.readonly || widget.readonly)
          ? AlwaysDisabledFocusNode()
          : null,
      decoration: InputDecoration(
        labelText: widget.label,
        enabled: !(FormBuilder.of(context).widget.readonly || widget.readonly),
        hintText: widget.hint,
        helperText: widget.hint,
      ),
      initialValue: widget.value != null ? "${widget.value}" : '',
      maxLines: widget.type == FormBuilder.TYPE_MULTILINE_TEXT ? 5 : 1,
      keyboardType: keyboardType,
      obscureText: widget.type == FormBuilder.TYPE_PASSWORD ? true : false,
      onSaved: (value) {
        var newValue = widget.type == FormBuilder.TYPE_NUMBER
            ? num.tryParse(value)
            : value;
        updateValue(newValue);
      },
      validator: (value) {
        if (widget.require && value.isEmpty)
          return "${widget.label} is required";

        if (widget.type == FormBuilder.TYPE_NUMBER) {
          if (num.tryParse(value) == null && value.isNotEmpty)
            return "$value is not a valid number";
          if (widget.max != null && num.tryParse(value) > widget.max)
            return "${widget.label} should not be greater than ${widget.max}";
          if (widget.min != null && num.tryParse(value) < widget.min)
            return "${widget.label} should not be less than ${widget.min}";
        } else {
          if (widget.max != null && value.length > widget.max)
            return "${widget.label} should have ${widget.max} character(s) or less";
          if (widget.min != null && value.length < widget.min)
            return "${widget.label} should have ${widget.min} character(s) or more";
        }

        if (widget.type == FormBuilder.TYPE_EMAIL && value.isNotEmpty) {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          if (!RegExp(pattern).hasMatch(value))
            return '$value is not a valid email address';
        }

        if (widget.type == FormBuilder.TYPE_URL && value.isNotEmpty) {
          Pattern pattern =
              r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
          if (!RegExp(pattern, caseSensitive: false).hasMatch(value))
            return '$value is not a valid URL';
        }

        if (widget.validator != null) return widget.validator(value);
      },
      // autovalidate: ,
    );
  }
}
