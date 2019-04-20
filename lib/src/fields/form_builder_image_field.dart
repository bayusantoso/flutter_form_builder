/// Some code and idea are from https://github.com/rapido-mobile/rapido-flutter
///
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:validators/validators.dart' as validators;

///

class FormBuilderImageField extends StatefulWidget {
  final String attribute;
  final List<FormFieldValidator> validators;
  final String initialValue;
  final bool readonly;
  final InputDecoration decoration;
  final ValueChanged onChanged;
  final ValueTransformer valueTransformer;
  final bool require;

  FormBuilderImageField(
      {
        @required this.attribute,
      this.initialValue,
      this.validators = const [],
      this.readonly = false,
      this.decoration = const InputDecoration(),
      this.onChanged,
      this.valueTransformer,
      this.require = false,
      });

  @override
  _FormBuilderImageFieldState createState() => _FormBuilderImageFieldState();
}

class _FormBuilderImageFieldState extends State<FormBuilderImageField> {
  bool _readonly = false;
  final GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();

  File _imageFile;
  String _imageUrl;
  bool _dirty = false;
  final double _thumbSize = 200.0;

  @override
  void initState() {
    registerFieldKey();
    _readonly =
        (FormBuilder.of(context)?.readonly == true) ? true : widget.readonly;

    if (widget.initialValue != null) {
      if (validators.isURL(widget.initialValue)) {
        _imageUrl = widget.initialValue;
      } else {
        Uri uri = Uri(path: widget.initialValue);
        _imageFile = File.fromUri(uri);
      }
    }
    super.initState();
  }

  registerFieldKey() {
    if (FormBuilder.of(context) != null)
      FormBuilder.of(context).registerFieldKey(widget.attribute, _fieldKey);
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
        key: _fieldKey,
        enabled: !_readonly,
        validator: (val) {
          /*if (!widget.require) return null;
          if (_imageFile == null && _imageUrl == null)
            return "This field cannot be empty.";*/
          for (int i = 0; i < widget.validators.length; i++) {
            if (widget.validators[i](val) != null)
              return widget.validators[i](val);
          }
        },
        onSaved: (val) {
          if (_dirty) {
            if (_imageFile != null) {
              if (widget.valueTransformer != null) {
                var transformed = widget.valueTransformer(_imageFile);
                FormBuilder.of(context)
                    ?.setAttributeValue(widget.attribute, transformed);
              } else {
                var val = base64Encode(_imageFile.readAsBytesSync());
                FormBuilder.of(context)
                    ?.setAttributeValue(widget.attribute, val);
              }
            }
          }
        },
        builder: (FormFieldState<dynamic> field) {
          return InputDecorator(
            decoration: widget.decoration.copyWith(
              enabled: !_readonly,
              errorText: field.errorText,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(color: Colors.grey),
                      child: _imageFile != null
                          ? ImageDisplayField(
                              imageString: _imageFile.path, boxSize: _thumbSize)
                          : ImageDisplayField(
                              imageString: _imageUrl, boxSize: _thumbSize),
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.image),
                          onPressed: _readonly
                              ? null
                              : () {
                                  _setImageFile(ImageSource.gallery);
                                },
                        ),
                        IconButton(
                          icon: Icon(Icons.camera),
                          onPressed: _readonly
                              ? null
                              : () {
                                  _setImageFile(ImageSource.camera);
                                },
                        ),
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: _readonly
                              ? null
                              : () {
                                  setState(() {
                                    _imageFile = null;
                                    _imageUrl = null;
                                    _dirty = true;
                                  });
                                },
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void _setImageFile(ImageSource source) async {
    File file = await ImagePicker.pickImage(source: source);
    if (file == null) return;
    setState(() {
      _imageUrl = null;
      _imageFile = file;
      _dirty = true;
    });
  }
}

/// Borrowing code from https://github.com/rapido-mobile/rapido-flutter
/// Provides a widget for displaying an image. It will display
/// any image given either a filepath or a url.
class ImageDisplayField extends StatelessWidget {
  static const double defaultBoxSize = 200.0;

  /// File path or URL to an image to display
  final String imageString;

  /// The height and widgth of the box in which the map will display
  final double boxSize;

  ImageDisplayField({@required this.imageString, this.boxSize});

  double _getBoxSize(dynamic value, {double boxSize: defaultBoxSize}) {
    double sz = 0.0;
    if (value != "" && value != null) {
      return boxSize == null ? defaultBoxSize : boxSize;
    }
    return sz;
  }

  @override
  Widget build(BuildContext context) {
    double sz = _getBoxSize(imageString, boxSize: boxSize);
    if (imageString == null) {
      return Container(
        child: SizedBox(
          height: defaultBoxSize,
          width: defaultBoxSize,
          child: Icon(Icons.broken_image),
        ),
      );
    } else if (validators.isURL(imageString)) {
      return Image(
        image: NetworkImage(imageString),
        height: sz,
        width: sz,
      );
    } else {
      return Container(
        child: Image.file(
          File.fromUri(
            Uri(
              path: imageString,
            ),
          ),
          height: sz,
          width: sz,
        ),
      );
    }
  }
}
