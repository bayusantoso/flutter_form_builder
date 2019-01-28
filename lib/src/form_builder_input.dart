import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:sy_flutter_widgets/sy_flutter_widgets.dart';

import './form_builder.dart';
import './form_builder_input_option.dart';

//TODO: Consider adding RangeSlider - https://pub.dartlang.org/packages/flutter_range_slider
//TODO: Consider adding ColorPicker - https://pub.dartlang.org/packages/flutter_colorpicker
//TODO: Consider adding masked_text - https://pub.dartlang.org/packages/code_input#-readme-tab- (Not Important)
//TODO: Consider adding code_input - https://pub.dartlang.org/packages/flutter_masked_text#-changelog-tab- (Not Important)
//TODO: Add autovalidate attribute type
class FormBuilderInput extends StatefulWidget {
  static const String TYPE_TEXT = "Text";
  static const String TYPE_NUMBER = "Number";
  static const String TYPE_EMAIL = "Email";
  static const String TYPE_MULTILINE_TEXT = "MultilineText";
  static const String TYPE_PASSWORD = "Password";
  static const String TYPE_RADIO = "Radio";
  static const String TYPE_CHECKBOX_LIST = "CheckboxList";
  static const String TYPE_CHECKBOX = "Checkbox";
  static const String TYPE_SWITCH = "Switch";
  static const String TYPE_SLIDER = "Slider";
  static const String TYPE_DROPDOWN = "Dropdown";
  static const String TYPE_DATE_PICKER = "DatePicker";
  static const String TYPE_TIME_PICKER = "TimePicker";
  static const String TYPE_URL = "Url";
  static const String TYPE_TYPE_AHEAD = "TypeAhead";
  static const String TYPE_PHONE = "Phone";
  static const String TYPE_STEPPER = "Stepper";
  static const String TYPE_RATE = "Rate";
  static const String TYPE_SEGMENTED_CONTROL = "SegmentedControl";
  static const String TYPE_CHIPS_INPUT = "ChipsInput";

  final String label;
  final String attribute;
  final String type;
  final bool readonly;
  final String hint;
  final dynamic value;
  final bool require;
  final dynamic min;
  final dynamic max;
  final int divisions;
  final num step;
  final String format;
  final IconData icon;
  final double iconSize;
  final DateTime firstDate; //TODO: Use min?
  final DateTime lastDate; //TODO: Use max?
  final FormFieldValidator<dynamic> validator;
  final List<FormBuilderInputOption> options;
  final SuggestionsCallback suggestionsCallback;
  final ItemBuilder itemBuilder;
  final ChipsBuilder suggestionBuilder;
  final ChipsBuilder chipBuilder;

  FormBuilderInput.textField({
    @required this.label,
    @required this.type,
    @required this.attribute,
    this.readonly = false,
    this.hint,
    this.value,
    this.require = false,
    this.validator,
    this.min,
    this.max,
    this.divisions,
    this.step,
    this.format,
    this.icon,
    this.iconSize,
    this.firstDate,
    this.lastDate,
    this.options,
    this.suggestionsCallback,
    this.itemBuilder,
    this.suggestionBuilder,
    this.chipBuilder,
    //TODO: Include maxLines for multiline text
  })  : assert(min == null || min is int),
        assert(max == null || max is int);

  FormBuilderInput.password({
    @required this.label,
    @required this.attribute,
    this.readonly = false,
    this.hint,
    this.value,
    this.require = false,
    this.validator,
    this.min,
    this.max,
    this.type = FormBuilderInput.TYPE_PASSWORD,
    this.step,
    this.format,
    this.icon,
    this.iconSize,
    this.firstDate,
    this.lastDate,
    this.options,
    this.suggestionsCallback,
    this.itemBuilder,
    this.suggestionBuilder,
    this.chipBuilder,
    this.divisions,
  })  : assert(min == null || min is int),
        assert(max == null || max is int) {}

  FormBuilderInput.typeAhead({
    @required this.label,
    @required this.attribute,
    @required this.itemBuilder,
    @required this.suggestionsCallback,
    this.readonly = false,
    this.hint,
    this.value,
    this.require = false,
    this.validator,
    this.type = FormBuilderInput.TYPE_TYPE_AHEAD,
    this.min,
    this.max,
    this.divisions,
    this.step,
    this.format,
    this.icon,
    this.iconSize,
    this.firstDate,
    this.lastDate,
    this.options,
    this.suggestionBuilder,
    this.chipBuilder,
  }) {}

  FormBuilderInput.number({
    @required this.label,
    @required this.attribute,
    this.readonly = false,
    this.value,
    this.hint,
    this.min,
    this.max,
    this.require = false,
    this.validator,
    this.type = FormBuilderInput.TYPE_NUMBER,
    this.divisions,
    this.step,
    this.format,
    this.icon,
    this.iconSize,
    this.firstDate,
    this.lastDate,
    this.options,
    this.suggestionsCallback,
    this.itemBuilder,
    this.suggestionBuilder,
    this.chipBuilder,
  })  : assert(min == null || min is num),
        assert(max == null || max is num),
        assert(min == null || max == null || min <= max,
            "Min cannot be higher than Max") {}

  FormBuilderInput.stepper({
    @required this.label,
    @required this.attribute,
    this.readonly = false,
    this.value,
    this.hint,
    this.min,
    this.max,
    this.step,
    this.require = false,
    this.validator,
    this.type = FormBuilderInput.TYPE_STEPPER,
    this.divisions,
    this.format,
    this.icon,
    this.iconSize,
    this.firstDate,
    this.lastDate,
    this.options,
    this.suggestionsCallback,
    this.itemBuilder,
    this.suggestionBuilder,
    this.chipBuilder,
  })  : assert(min == null || min is num),
        assert(max == null || max is num),
        assert(min == null || max == null || min <= max,
            "Min cannot be higher than Max") {}

  FormBuilderInput.rate({
    @required this.label,
    @required this.attribute,
    @required this.max,
    this.readonly = false,
    this.value,
    this.icon,
    this.iconSize,
    this.hint,
    this.require = false,
    this.validator,
    this.type = FormBuilderInput.TYPE_RATE,
    this.min,
    this.divisions,
    this.step,
    this.format,
    this.firstDate,
    this.lastDate,
    this.options,
    this.suggestionsCallback,
    this.itemBuilder,
    this.suggestionBuilder,
    this.chipBuilder,
  })  : assert(max == null || max is num),
        assert(max > value || value == null,
            "Initial value cannot be higher than Max") {}

  FormBuilderInput.slider({
    @required this.label,
    @required this.attribute,
    @required this.min,
    @required this.max,
    @required this.value,
    this.readonly = false,
    this.divisions,
    this.hint,
    this.require = false,
    this.validator,
    this.type = FormBuilderInput.TYPE_SLIDER,
    this.step,
    this.format,
    this.icon,
    this.iconSize,
    this.firstDate,
    this.lastDate,
    this.options,
    this.suggestionsCallback,
    this.itemBuilder,
    this.suggestionBuilder,
    this.chipBuilder,
  })  : assert(min == null || min is num),
        assert(max == null || max is num) {}

  FormBuilderInput.dropdown({
    @required this.label,
    @required this.options,
    @required this.attribute,
    this.readonly = false,
    this.hint,
    this.value,
    this.require = false,
    this.validator,
    this.type = FormBuilderInput.TYPE_DROPDOWN,
    this.min,
    this.max,
    this.divisions,
    this.step,
    this.format,
    this.icon,
    this.iconSize,
    this.firstDate,
    this.lastDate,
    this.suggestionsCallback,
    this.itemBuilder,
    this.suggestionBuilder,
    this.chipBuilder,
  }) {}

  FormBuilderInput.radio({
    @required this.label,
    @required this.attribute,
    @required this.options,
    this.readonly = false,
    this.hint,
    this.value,
    this.require = false,
    this.validator,
    this.type = FormBuilderInput.TYPE_RADIO,
    this.min,
    this.max,
    this.divisions,
    this.step,
    this.format,
    this.icon,
    this.iconSize,
    this.firstDate,
    this.lastDate,
    this.suggestionsCallback,
    this.itemBuilder,
    this.suggestionBuilder,
    this.chipBuilder,
  }) {}

  FormBuilderInput.segmentedControl({
    @required this.label,
    @required this.attribute,
    @required this.options,
    this.readonly = false,
    this.hint,
    this.value,
    this.require = false,
    this.validator,
    this.type = FormBuilderInput.TYPE_SEGMENTED_CONTROL,
    this.min,
    this.max,
    this.divisions,
    this.step,
    this.format,
    this.icon,
    this.iconSize,
    this.firstDate,
    this.lastDate,
    this.suggestionsCallback,
    this.itemBuilder,
    this.suggestionBuilder,
    this.chipBuilder,
  }) {}

  FormBuilderInput.checkbox({
    @required this.label,
    @required this.attribute,
    this.readonly = false,
    this.hint,
    this.value,
    this.require = false,
    this.validator,
    this.type = FormBuilderInput.TYPE_CHECKBOX,
    this.min,
    this.max,
    this.divisions,
    this.step,
    this.format,
    this.icon,
    this.iconSize,
    this.firstDate,
    this.lastDate,
    this.options,
    this.suggestionsCallback,
    this.itemBuilder,
    this.suggestionBuilder,
    this.chipBuilder,
  }) : assert(value == null || value is bool,
            "Initial value for a checkbox should be boolean") {}

  FormBuilderInput.switchInput({
    @required this.label,
    @required this.attribute,
    this.readonly = false,
    this.hint,
    this.value,
    this.require = false,
    this.validator,
    this.type = FormBuilderInput.TYPE_SWITCH,
    this.min,
    this.max,
    this.divisions,
    this.step,
    this.format,
    this.icon,
    this.iconSize,
    this.firstDate,
    this.lastDate,
    this.options,
    this.suggestionsCallback,
    this.itemBuilder,
    this.suggestionBuilder,
    this.chipBuilder,
  }) : assert(value == null || value is bool,
            "Initial value for a switch should be boolean") {}

  FormBuilderInput.checkboxList({
    @required this.label,
    @required this.options,
    @required this.attribute,
    this.readonly = false,
    this.hint,
    this.value,
    this.require = false,
    this.validator,
    this.type = FormBuilderInput.TYPE_CHECKBOX_LIST,
    this.min,
    this.max,
    this.divisions,
    this.step,
    this.format,
    this.icon,
    this.iconSize,
    this.firstDate,
    this.lastDate,
    this.suggestionsCallback,
    this.itemBuilder,
    this.suggestionBuilder,
    this.chipBuilder,
  }) : assert(value == null || value is List) {
    value == value ?? []; // ignore: unnecessary_statements
  }

  FormBuilderInput.datePicker({
    @required this.label,
    @required this.attribute,
    this.readonly = false,
    this.hint,
    this.firstDate,
    this.lastDate,
    this.format,
    this.value,
    this.require = false,
    this.validator,
    this.type = FormBuilderInput.TYPE_DATE_PICKER,
    this.min,
    this.max,
    this.divisions,
    this.step,
    this.icon,
    this.iconSize,
    this.options,
    this.suggestionsCallback,
    this.itemBuilder,
    this.suggestionBuilder,
    this.chipBuilder,
  }) {
    // type;
  }

  FormBuilderInput.timePicker({
    @required this.label,
    @required this.attribute,
    this.readonly = false,
    this.hint,
    this.firstDate,
    this.lastDate,
    this.value,
    this.require = false,
    this.validator,
    this.type = FormBuilderInput.TYPE_TIME_PICKER,
    this.min,
    this.max,
    this.divisions,
    this.step,
    this.format,
    this.icon,
    this.iconSize,
    this.options,
    this.suggestionsCallback,
    this.itemBuilder,
    this.suggestionBuilder,
    this.chipBuilder,
  }) {}

  FormBuilderInput.chipsInput({
    @required this.label,
    @required this.attribute,
    @required this.suggestionsCallback,
    @required this.suggestionBuilder,
    @required this.chipBuilder,
    this.readonly = false,
    this.hint,
    this.value,
    this.require = false,
    this.validator,
    this.type = FormBuilderInput.TYPE_CHIPS_INPUT,
    this.min,
    this.max,
    this.divisions,
    this.step,
    this.format,
    this.icon,
    this.iconSize,
    this.firstDate,
    this.lastDate,
    this.options,
    this.itemBuilder,
  }) : assert(value == null || value is List) {}

  hasHint() {
    return hint != null;
  }

  @override
  _FormBuilderInputState createState() => _FormBuilderInputState();
}

class _FormBuilderInputState extends State<FormBuilderInput> {
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
    switch (widget.type) {
      case FormBuilderInput.TYPE_TEXT:
      case FormBuilderInput.TYPE_PASSWORD:
      case FormBuilderInput.TYPE_NUMBER:
      case FormBuilderInput.TYPE_PHONE:
      case FormBuilderInput.TYPE_EMAIL:
      case FormBuilderInput.TYPE_URL:
      case FormBuilderInput.TYPE_MULTILINE_TEXT:
        TextInputType keyboardType;
        switch (widget.type) {
          case FormBuilderInput.TYPE_NUMBER:
            keyboardType = TextInputType.number;
            break;
          case FormBuilderInput.TYPE_EMAIL:
            keyboardType = TextInputType.emailAddress;
            break;
          case FormBuilderInput.TYPE_URL:
            keyboardType = TextInputType.url;
            break;
          case FormBuilderInput.TYPE_PHONE:
            keyboardType = TextInputType.phone;
            break;
          case FormBuilderInput.TYPE_MULTILINE_TEXT:
            keyboardType = TextInputType.multiline;
            break;
          default:
            keyboardType = TextInputType.text;
            break;
        }
        return (TextFormField(
          key: Key(widget.attribute),
          enabled:
              !(FormBuilder.of(context).widget.readonly || widget.readonly),
          style: (FormBuilder.of(context).widget.readonly || widget.readonly)
              ? Theme.of(context).textTheme.subhead.copyWith(
                    color: Theme.of(context).disabledColor,
                  )
              : null,
          focusNode:
              (FormBuilder.of(context).widget.readonly || widget.readonly)
                  ? AlwaysDisabledFocusNode()
                  : null,
          decoration: InputDecoration(
            labelText: widget.label,
            enabled:
                !(FormBuilder.of(context).widget.readonly || widget.readonly),
            hintText: widget.hint,
            helperText: widget.hint,
          ),
          initialValue: widget.value != null ? "${widget.value}" : '',
          maxLines: widget.type == FormBuilderInput.TYPE_MULTILINE_TEXT ? 5 : 1,
          keyboardType: keyboardType,
          obscureText:
              widget.type == FormBuilderInput.TYPE_PASSWORD ? true : false,
          onSaved: (value) {
            var newValue = widget.type == FormBuilderInput.TYPE_NUMBER
                ? num.tryParse(value)
                : value;
            updateValue(newValue);
          },
          validator: (value) {
            if (widget.require && value.isEmpty)
              return "${widget.label} is required";

            if (widget.type == FormBuilderInput.TYPE_NUMBER) {
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

            if (widget.type == FormBuilderInput.TYPE_EMAIL &&
                value.isNotEmpty) {
              Pattern pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              if (!RegExp(pattern).hasMatch(value))
                return '$value is not a valid email address';
            }

            if (widget.type == FormBuilderInput.TYPE_URL && value.isNotEmpty) {
              Pattern pattern =
                  r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
              if (!RegExp(pattern, caseSensitive: false).hasMatch(value))
                return '$value is not a valid URL';
            }

            if (widget.validator != null) return widget.validator(value);
          },
          // autovalidate: ,
        ));
        break;

      case FormBuilderInput.TYPE_DATE_PICKER:
        return _generateDatePicker();
        break;

      case FormBuilderInput.TYPE_TIME_PICKER:
        return _generateTimePicker();
        break;

      case FormBuilderInput.TYPE_TYPE_AHEAD:
        TextEditingController _typeAheadController =
            TextEditingController(text: widget.value);
        return (TypeAheadFormField(
          key: Key(widget.attribute),
          textFieldConfiguration: TextFieldConfiguration(
            enabled:
                !(FormBuilder.of(context).widget.readonly || widget.readonly),
            controller: _typeAheadController,
            style: (FormBuilder.of(context).widget.readonly || widget.readonly)
                ? Theme.of(context).textTheme.subhead.copyWith(
                      color: Theme.of(context).disabledColor,
                    )
                : null,
            focusNode:
                (FormBuilder.of(context).widget.readonly || widget.readonly)
                    ? AlwaysDisabledFocusNode()
                    : null,
            decoration: InputDecoration(
              labelText: widget.label,
              enabled:
                  !(FormBuilder.of(context).widget.readonly || widget.readonly),
              hintText: widget.hint,
            ),
          ),
          suggestionsCallback: widget.suggestionsCallback,
          itemBuilder: widget.itemBuilder,
          transitionBuilder: (context, suggestionsBox, controller) =>
              suggestionsBox,
          onSuggestionSelected: (suggestion) {
            _typeAheadController.text = suggestion;
          },
          validator: (value) {
            if (widget.require && value.isEmpty)
              return '${widget.label} is required';

            if (widget.validator != null) return widget.validator(value);
          },
          onSaved: (value) => updateValue(value),
        ));
        break;

      case FormBuilderInput.TYPE_DROPDOWN:
        return (FormField(
          key: Key(widget.attribute),
          enabled:
              !(FormBuilder.of(context).widget.readonly || widget.readonly),
          initialValue: widget.value,
          validator: (value) {
            if (widget.require && value == null)
              return "${widget.label} is required";
            if (widget.validator != null) return widget.validator(value);
          },
          onSaved: (value) {
            updateValue(value);
          },
          builder: (FormFieldState<dynamic> field) {
            return InputDecorator(
              decoration: InputDecoration(
                labelText: widget.label,
                enabled: !(FormBuilder.of(context).widget.readonly ||
                    widget.readonly),
                helperText: widget.hint,
                errorText: field.errorText,
                contentPadding: EdgeInsets.only(top: 10.0, bottom: 0.0),
                border: InputBorder.none,
              ),
              child: DropdownButton(
                isExpanded: true,
                hint: Text(widget.hint ?? ''),
                items: widget.options.map((option) {
                  return DropdownMenuItem(
                    child: Text("${option.label ?? option.value}"),
                    value: option.value,
                  );
                }).toList(),
                value: field.value,
                onChanged:
                    (FormBuilder.of(context).widget.readonly || widget.readonly)
                        ? null
                        : (value) {
                            field.didChange(value);
                          },
              ),
            );
          },
        ));
        break;

      //TODO: For TYPE_CHECKBOX, TYPE_CHECKBOX_LIST, TYPE_RADIO allow user to choose if checkbox/radio to appear before or after Label
      case FormBuilderInput.TYPE_RADIO:
        return (FormField(
          key: Key(widget.attribute),
          enabled: !widget.readonly && !widget.readonly,
          initialValue: widget.value,
          onSaved: (value) {
            updateValue(value);
          },
          validator: (value) {
            if (widget.require && value == null)
              return "${widget.label} is required";
            if (widget.validator != null) return widget.validator(value);
          },
          builder: (FormFieldState<dynamic> field) {
            List<Widget> radioList = [];
            for (int i = 0; i < widget.options.length; i++) {
              radioList.addAll([
                ListTile(
                  dense: true,
                  isThreeLine: false,
                  contentPadding: EdgeInsets.all(0.0),
                  leading: null,
                  title: Text(
                      "${widget.options[i].label ?? widget.options[i].value}"),
                  trailing: Radio<dynamic>(
                    value: widget.options[i].value,
                    groupValue: field.value,
                    onChanged: (FormBuilder.of(context).widget.readonly ||
                            widget.readonly)
                        ? null
                        : (dynamic value) {
                            field.didChange(value);
                          },
                  ),
                  onTap: (FormBuilder.of(context).widget.readonly ||
                          widget.readonly)
                      ? null
                      : () {
                          var selectedValue = widget.options[i].value;
                          field.didChange(selectedValue);
                        },
                ),
                Divider(
                  height: 0.0,
                ),
              ]);
            }
            return InputDecorator(
              decoration: InputDecoration(
                labelText: widget.label,
                enabled: !(FormBuilder.of(context).widget.readonly ||
                    widget.readonly),
                helperText: widget.hint ?? "",
                errorText: field.errorText,
                contentPadding: EdgeInsets.only(top: 10.0, bottom: 0.0),
                border: InputBorder.none,
              ),
              child: Column(
                children: radioList,
              ),
            );
          },
        ));
        break;

      case FormBuilderInput.TYPE_SEGMENTED_CONTROL:
        return FormField(
          key: Key(widget.attribute),
          initialValue: widget.value,
          enabled:
              !(FormBuilder.of(context).widget.readonly || widget.readonly),
          onSaved: (value) {
            updateValue(value);
          },
          validator: (value) {
            if (widget.require && value == null)
              return "${widget.label} is required";
            if (widget.validator != null) return widget.validator(value);
          },
          builder: (FormFieldState<dynamic> field) {
            return InputDecorator(
              decoration: InputDecoration(
                labelText: widget.label,
                enabled: !(FormBuilder.of(context).widget.readonly ||
                    widget.readonly),
                helperText: widget.hint,
                errorText: field.errorText,
                contentPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                border: InputBorder.none,
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: CupertinoSegmentedControl(
                  borderColor: (FormBuilder.of(context).widget.readonly ||
                          widget.readonly)
                      ? Theme.of(context).disabledColor
                      : Theme.of(context).primaryColor,
                  selectedColor: (FormBuilder.of(context).widget.readonly ||
                          widget.readonly)
                      ? Theme.of(context).disabledColor
                      : Theme.of(context).primaryColor,
                  pressedColor: (FormBuilder.of(context).widget.readonly ||
                          widget.readonly)
                      ? Theme.of(context).disabledColor
                      : Theme.of(context).primaryColor,
                  groupValue: field.value,
                  children: Map.fromIterable(
                    widget.options,
                    key: (v) => v.value,
                    value: (v) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text("${v.label ?? v.value}"),
                        ),
                  ),
                  onValueChanged: (dynamic value) {
                    if (FormBuilder.of(context).widget.readonly ||
                        widget.readonly) {
                      field.reset();
                    } else
                      field.didChange(value);
                  },
                ),
              ),
            );
          },
        );
        break;

      case FormBuilderInput.TYPE_SWITCH:
        return FormField(
            key: Key(widget.attribute),
            enabled:
                !(FormBuilder.of(context).widget.readonly || widget.readonly),
            initialValue: widget.value ?? false,
            validator: (value) {
              if (widget.require && value == null)
                return "${widget.label} is required";
              /*if (widget.validator != null)
                  return widget.validator(value);*/
            },
            onSaved: (value) {
              updateValue(value);
            },
            builder: (FormFieldState<dynamic> field) {
              return InputDecorator(
                decoration: InputDecoration(
                  // labelText: widget.label,
                  enabled: !(FormBuilder.of(context).widget.readonly ||
                      widget.readonly),
                  helperText: widget.hint ?? "",
                  errorText: field.errorText,
                ),
                child: ListTile(
                  dense: true,
                  isThreeLine: false,
                  contentPadding: EdgeInsets.all(0.0),
                  title: Text(
                    widget.label,
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: Switch(
                    value: field.value,
                    onChanged: (FormBuilder.of(context).widget.readonly ||
                            widget.readonly)
                        ? null
                        : (bool value) {
                            field.didChange(value);
                          },
                  ),
                  onTap: (FormBuilder.of(context).widget.readonly ||
                          widget.readonly)
                      ? null
                      : () {
                          bool newValue = !(field.value ?? false);
                          field.didChange(newValue);
                        },
                ),
              );
            });
        break;

      case FormBuilderInput.TYPE_STEPPER:
        return FormField(
          enabled:
              !(FormBuilder.of(context).widget.readonly || widget.readonly),
          key: Key(widget.attribute),
          initialValue: widget.value,
          validator: (value) {
            if (widget.require && value == null)
              return "${widget.label} is required";
            if (widget.validator != null) return widget.validator(value);
          },
          onSaved: (value) {
            updateValue(value);
          },
          builder: (FormFieldState<dynamic> field) {
            return InputDecorator(
              decoration: InputDecoration(
                labelText: widget.label,
                enabled: !(FormBuilder.of(context).widget.readonly ||
                    widget.readonly),
                helperText: widget.hint ?? "",
                errorText: field.errorText,
              ),
              child: SyStepper(
                value: field.value ?? 0,
                step: widget.step ?? 1,
                min: widget.min ?? 0,
                max: widget.max ?? 9999999,
                size: 24.0,
                onChange:
                    (FormBuilder.of(context).widget.readonly || widget.readonly)
                        ? null
                        : (value) {
                            field.didChange(value);
                          },
              ),
            );
          },
        );
        break;

      case FormBuilderInput.TYPE_RATE:
        return (FormField(
          enabled:
              !(FormBuilder.of(context).widget.readonly || widget.readonly),
          key: Key(widget.attribute),
          initialValue: widget.value ?? 1,
          validator: (value) {
            if (widget.require && value == null)
              return "${widget.label} is required";
            if (widget.validator != null) return widget.validator(value);
          },
          onSaved: (value) {
            updateValue(value);
          },
          builder: (FormFieldState<dynamic> field) {
            return InputDecorator(
              decoration: InputDecoration(
                labelText: widget.label,
                enabled: !(FormBuilder.of(context).widget.readonly ||
                    widget.readonly),
                helperText: widget.hint ?? "",
                errorText: field.errorText,
              ),
              child: SyRate(
                value: field.value,
                total: widget.max,
                icon: widget.icon,
                //TODO: When disabled change icon color (Probably deep grey)
                iconSize: widget.iconSize ?? 24.0,
                onTap:
                    (FormBuilder.of(context).widget.readonly || widget.readonly)
                        ? null
                        : (value) {
                            field.didChange(value);
                          },
              ),
            );
          },
        ));
        break;

      case FormBuilderInput.TYPE_CHECKBOX:
        return FormField(
          key: Key(widget.attribute),
          enabled:
              !(FormBuilder.of(context).widget.readonly || widget.readonly),
          initialValue: widget.value ?? false,
          validator: (value) {
            if (widget.require && value == null)
              return "${widget.label} is required";
            if (widget.validator != null) return widget.validator(value);
          },
          onSaved: (value) {
            updateValue(value);
          },
          builder: (FormFieldState<dynamic> field) {
            return InputDecorator(
              decoration: InputDecoration(
                // labelText: widget.label,
                enabled: !(FormBuilder.of(context).widget.readonly ||
                    widget.readonly),
                helperText: widget.hint ?? "",
                errorText: field.errorText,
              ),
              child: ListTile(
                dense: true,
                isThreeLine: false,
                contentPadding: EdgeInsets.all(0.0),
                title: Text(
                  widget.label,
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Checkbox(
                  value: field.value ?? false,
                  onChanged: (FormBuilder.of(context).widget.readonly ||
                          widget.readonly)
                      ? null
                      : (bool value) {
                          field.didChange(value);
                        },
                ),
                onTap:
                    (FormBuilder.of(context).widget.readonly || widget.readonly)
                        ? null
                        : () {
                            bool newValue = !(field.value ?? false);
                            field.didChange(newValue);
                          },
              ),
            );
          },
        );
        break;

      case FormBuilderInput.TYPE_SLIDER:
        return (FormField(
          key: Key(widget.attribute),
          enabled:
              !(FormBuilder.of(context).widget.readonly || widget.readonly),
          initialValue: widget.value,
          validator: (value) {
            if (widget.require && value == null)
              return "${widget.label} is required";
            if (widget.validator != null) return widget.validator(value);
          },
          onSaved: (value) {
            updateValue(value);
          },
          builder: (FormFieldState<dynamic> field) {
            return InputDecorator(
              decoration: InputDecoration(
                labelText: widget.label,
                enabled: !(FormBuilder.of(context).widget.readonly ||
                    widget.readonly),
                helperText: widget.hint,
                errorText: field.errorText,
              ),
              child: Container(
                padding: EdgeInsets.only(top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Slider(
                      value: field.value,
                      min: widget.min,
                      max: widget.max,
                      divisions: widget.divisions,
                      onChanged: (FormBuilder.of(context).widget.readonly ||
                              widget.readonly)
                          ? null
                          : (double value) {
                              field.didChange(value);
                            },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("${widget.min}"),
                        Text("${field.value}"),
                        Text("${widget.max}"),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ));
        break;

      case FormBuilderInput.TYPE_CHECKBOX_LIST:
        return (FormField(
            key: Key(widget.attribute),
            enabled:
                !(FormBuilder.of(context).widget.readonly || widget.readonly),
            initialValue: widget.value ?? [],
            onSaved: (value) {
              updateValue(value);
            },
            validator: widget.validator,
            builder: (FormFieldState<dynamic> field) {
              List<Widget> checkboxList = [];
              for (int i = 0; i < widget.options.length; i++) {
                checkboxList.addAll([
                  ListTile(
                    dense: true,
                    isThreeLine: false,
                    contentPadding: EdgeInsets.all(0.0),
                    leading: Checkbox(
                      value: field.value.contains(widget.options[i].value),
                      onChanged: (FormBuilder.of(context).widget.readonly ||
                              widget.readonly)
                          ? null
                          : (bool value) {
                              if (value)
                                widget.value.add(widget.options[i].value);
                              else
                                widget.value.remove(widget.options[i].value);
                              field.didChange(widget.value);
                            },
                    ),
                    title: Text(
                        "${widget.options[i].label ?? widget.options[i].value}"),
                    onTap: (FormBuilder.of(context).widget.readonly ||
                            widget.readonly)
                        ? null
                        : () {
                            bool newValue =
                                field.value.contains(widget.options[i].value);
                            if (!newValue)
                              widget.value.add(widget.options[i].value);
                            else
                              widget.value.remove(widget.options[i].value);
                            field.didChange(widget.value);
                          },
                  ),
                  Divider(
                    height: 0.0,
                  ),
                ]);
              }
              return InputDecorator(
                decoration: InputDecoration(
                  labelText: widget.label,
                  enabled: !(FormBuilder.of(context).widget.readonly ||
                      widget.readonly),
                  helperText: widget.hint ?? "",
                  errorText: field.errorText,
                  contentPadding: EdgeInsets.only(top: 10.0, bottom: 0.0),
                  border: InputBorder.none,
                ),
                child: Column(
                  children: checkboxList,
                ),
              );
            }));
        break;
      case FormBuilderInput.TYPE_CHIPS_INPUT:
        return SizedBox(
          // height: 200.0,
          child: FormField(
            key: Key(widget.attribute),
            enabled:
                !(FormBuilder.of(context).widget.readonly || widget.readonly),
            initialValue: widget.value ?? [],
            onSaved: (value) {
              updateValue(value);
            },
            validator: (value) {
              if (widget.require && value.length == 0)
                return "${widget.label} is required";
              if (widget.validator != null) return widget.validator(value);
            },
            builder: (FormFieldState<dynamic> field) {
              return ChipsInput(
                initialValue: field.value,
                enabled: !(FormBuilder.of(context).widget.readonly ||
                    widget.readonly),
                decoration: InputDecoration(
                  // prefixIcon: Icon(Icons.search),
                  enabled: !(FormBuilder.of(context).widget.readonly ||
                      widget.readonly),
                  hintText: widget.hint,
                  labelText: widget.label,
                  errorText: field.errorText,
                ),
                findSuggestions: widget.suggestionsCallback,
                onChanged: (data) {
                  field.didChange(data);
                },
                chipBuilder: widget.chipBuilder,
                suggestionBuilder: widget.suggestionBuilder,
              );
            },
          ),
        );
        break;
    }
  }

  _generateDatePicker() {
    TextEditingController _inputController =
        new TextEditingController(text: widget.value);
    FocusNode _focusNode = FocusNode();
    return GestureDetector(
      onTap: (FormBuilder.of(context).widget.readonly || widget.readonly)
          ? null
          : () {
              FocusScope.of(context).requestFocus(_focusNode);
              _showDatePickerDialog(
                context,
                initialDate: DateTime.tryParse(_inputController.value.text),
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
              ).then((selectedDate) {
                if (selectedDate != null) {
                  String selectedDateFormatted =
                      DateFormat(widget.format ?? 'yyyy-MM-dd')
                          .format(selectedDate);
                  _inputController.value =
                      TextEditingValue(text: selectedDateFormatted);
                }
              });
            },
      child: AbsorbPointer(
        child: TextFormField(
          key: Key(widget.attribute),
          enabled:
              !(FormBuilder.of(context).widget.readonly || widget.readonly),
          style: (FormBuilder.of(context).widget.readonly || widget.readonly)
              ? Theme.of(context).textTheme.subhead.copyWith(
                    color: Theme.of(context).disabledColor,
                  )
              : null,
          focusNode:
              (FormBuilder.of(context).widget.readonly || widget.readonly)
                  ? AlwaysDisabledFocusNode()
                  : _focusNode,
          validator: (value) {
            if (widget.require && (value.isEmpty || value == null))
              return "${widget.label} is required";
            if (widget.validator != null) return widget.validator(value);
          },
          controller: _inputController,
          decoration: InputDecoration(
            labelText: widget.label,
            enabled:
                !(FormBuilder.of(context).widget.readonly || widget.readonly),
            hintText: widget.hint ?? "",
          ),
          onSaved: (value) {
            updateValue(value);
          },
        ),
      ),
    );
  }

  _generateTimePicker() {
    TextEditingController _inputController =
        new TextEditingController(text: widget.value);
    FocusNode _focusNode = new FocusNode();
    return GestureDetector(
      onTap: (FormBuilder.of(context).widget.readonly || widget.readonly)
          ? null
          : () {
              FocusScope.of(context).requestFocus(_focusNode);
              _showTimePickerDialog(
                context,
                // initialTime: new Time, //FIXME: Parse time from string
              ).then((selectedTime) {
                if (selectedTime != null) {
                  String selectedDateFormatted = selectedTime.format(context);
                  _inputController.value =
                      TextEditingValue(text: selectedDateFormatted);
                }
              });
            },
      child: AbsorbPointer(
        child: TextFormField(
          key: Key(widget.attribute),
          enabled:
              !(FormBuilder.of(context).widget.readonly || widget.readonly),
          style: (FormBuilder.of(context).widget.readonly || widget.readonly)
              ? Theme.of(context).textTheme.subhead.copyWith(
                    color: Theme.of(context).disabledColor,
                  )
              : null,
          controller: _inputController,
          focusNode:
              (FormBuilder.of(context).widget.readonly || widget.readonly)
                  ? AlwaysDisabledFocusNode()
                  : _focusNode,
          validator: (value) {
            if (widget.require && (value.isEmpty || value == null))
              return "${widget.label} is required";
            if (widget.validator != null) return widget.validator(value);
          },
          decoration: InputDecoration(
            labelText: widget.label,
            enabled:
                !(FormBuilder.of(context).widget.readonly || widget.readonly),
            hintText: widget.hint ?? "",
          ),
          onSaved: (value) {
            updateValue(value);
          },
        ),
      ),
    );
  }

  Future<DateTime> _showDatePickerDialog(BuildContext context,
      {DateTime initialDate, DateTime firstDate, DateTime lastDate}) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now().subtract(Duration(days: 100000)),
      lastDate: lastDate ?? DateTime.now().add(Duration(days: 100000)),
    );
    return picked;
  }

  Future<TimeOfDay> _showTimePickerDialog(BuildContext context,
      {TimeOfDay initialTime}) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );
    return picked;
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
