import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class FormBuilderImagePicker extends StatefulWidget {
  final String attribute;
  final List<FormFieldValidator> validators;
  final List<Asset> initialValue;
  final bool readonly;
  final InputDecoration decoration;
  final ValueChanged onChanged;
  final ValueTransformer valueTransformer;

  final int maxImages;
  final CupertinoOptions cupertinoOptions;
  final MaterialOptions materialOptions;

  FormBuilderImagePicker({
    @required this.attribute,
    this.initialValue,
    this.validators = const [],
    this.readonly = false,
    this.decoration = const InputDecoration(),
    this.onChanged,
    this.valueTransformer,
    this.maxImages = 1,
    this.cupertinoOptions = const CupertinoOptions(),
    this.materialOptions = const MaterialOptions(),
  });

  @override
  _FormBuilderImagePickerState createState() => _FormBuilderImagePickerState();
}

class _FormBuilderImagePickerState extends State<FormBuilderImagePicker> {
  bool _readonly = false;
  final GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();
  FormBuilderState _formState;
  List<Asset> _images = List<Asset>();

  @override
  void initState() {
    _formState = FormBuilder.of(context);
    _formState?.registerFieldKey(widget.attribute, _fieldKey);
    _readonly = (_formState?.readonly == true) ? true : widget.readonly;
    super.initState();
  }

  @override
  void dispose() {
    _formState?.unregisterFieldKey(widget.attribute);
    super.dispose();
  }

  int get _remainingItemCount => widget.maxImages - _images.length;

  @override
  Widget build(BuildContext context) {
    return FormField(
      key: _fieldKey,
      enabled: !_readonly,
      initialValue: widget.initialValue,
      validator: (val) {
        for (int i = 0; i < widget.validators.length; i++) {
          if (widget.validators[i](val) != null)
            return widget.validators[i](val);
        }
      },
      onSaved: (val) {
        if (widget.valueTransformer != null) {
          var transformed = widget.valueTransformer(val);
          FormBuilder.of(context)
              ?.setAttributeValue(widget.attribute, transformed);
        } else
          _formState?.setAttributeValue(widget.attribute, val);
      },
      builder: (FormFieldState<List<Asset>> field) {
        return InputDecorator(
          decoration: widget.decoration.copyWith(
            enabled: !_readonly,
            errorText: field.errorText,
          ),
          child: Container(
            height: 150,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("${_images.length}/${widget.maxImages}"),
                    FlatButton(
                      child: Icon(Icons.add),
                      onPressed: (_readonly || _remainingItemCount <= 0) ? null : () => loadAssets(field),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(_images.length, (index) {
                      return Stack(
                        alignment: Alignment.topRight,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 2),
                            child: AssetThumb(
                              asset: _images[index],
                              width: 300,
                              height: 300,
                            ),
                          ),
                          InkWell(
                            onTap: () => removeImageAtIndex(index, field),
                            child: Container(
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.7),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              height: 22,
                              width: 22,
                              child: Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> loadAssets(FormFieldState field) async {
    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: _remainingItemCount,
        enableCamera: true,
        cupertinoOptions: widget.cupertinoOptions,
        materialOptions: widget.materialOptions,
      );
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _images.addAll(resultList);
      // if (error == null) _error = 'No Error Dectected';
    });
    field.didChange(_images);
    if (widget.onChanged != null) widget.onChanged(_images);
  }

  void removeImageAtIndex(int index, FormFieldState field) {
    setState(() {
      _images.removeAt(index);
    });
    field.didChange(_images);
    if (widget.onChanged != null) widget.onChanged(_images);
  }
}
