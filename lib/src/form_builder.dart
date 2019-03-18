import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './form_builder_input.dart';

//TODO: Refactor this spaghetti code
class FormBuilder extends StatefulWidget {
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

  final BuildContext context;
  final Function(Map<String, dynamic>) onChanged;
  final WillPopCallback onWillPop;
  final List<Widget> controls;
  final Function onSubmit;
  final bool autovalidate;
  final bool showResetButton;
  final Widget submitButtonContent;
  final Widget resetButtonContent;
  final bool readonly;

  static _FormBuilderState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_FormBuilderState>());

  const FormBuilder(this.context, {
    @required this.controls,
    @required this.onSubmit,
    this.readonly = false,
    this.onChanged,
    this.autovalidate = false,
    this.showResetButton = false,
    this.onWillPop,
    this.submitButtonContent,
    this.resetButtonContent,
  }) : assert(resetButtonContent == null || showResetButton);

  /*assert(duplicateAttributes(controls).length == 0, "Duplicate attribute names not allowed");

  //TODO: Find way to assert no duplicates in control attributes
  Function duplicateAttributes = (List<FormBuilderInput> controls) {
    List<String> attributeList = [];
    controls.forEach((c) {
      attributeList.add(c.attribute);
    });
    List<String> uniqueAttributes = Set.from(attributeList).toList(growable: false);
    //attributeList.
  };*/

  @override
  _FormBuilderState createState() => _FormBuilderState();
}

class _FormBuilderState extends State<FormBuilder> {
  final _formKey = GlobalKey<FormState>();
  List<Widget> formControls;
  Map<String, dynamic> formData = {};

  _FormBuilderState();

  updateAttributeValue(String attribute, dynamic value) {
    setState(() {
      formData[attribute] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    formControls = [];
    formControls.addAll(widget.controls);
    formControls.add(Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          widget.showResetButton
              ? Expanded(
            child: OutlineButton(
              borderSide:
              BorderSide(color: Theme
                  .of(context)
                  .accentColor),
              textColor: Theme
                  .of(context)
                  .accentColor,
              onPressed: () {
                _formKey.currentState.reset();
              },
              child: widget.resetButtonContent ?? Text('Reset'),
            ),
          )
              : SizedBox(),
          Expanded(
            child: MaterialButton(
              color: Theme
                  .of(context)
                  .accentColor,
              textColor: Colors.white,
              onPressed: () {
                _formKey.currentState.save();
                if (_formKey.currentState.validate()) {
                  widget.onSubmit(formData);
                } else {
                  debugPrint("Validation failed");
                  widget.onSubmit(null);
                }
              },
              child: widget.submitButtonContent ?? Text('Submit'),
            ),
          ),
        ],
      ),
    ));
    return Form(
      key: _formKey,
      onChanged: () {
        if (widget.onChanged != null) {
          _formKey.currentState.save();
          widget.onChanged(formData);
        }
      },
      //TODO: Allow user to update field value or validate based on changes in others (e.g. Summations, Confirm Password)
      onWillPop: widget.onWillPop,
      autovalidate: widget.autovalidate,
      child: SingleChildScrollView(
        child: Column(
          children: formControls,
        ),
      ),
    );
  }
}
