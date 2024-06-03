import 'package:donation_app/models/donation_model.dart';
import 'package:donation_app/providers/donation_provider.dart';
import 'package:donation_app/screens/donor_new/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import "package:firebase_auth/firebase_auth.dart";
import "package:donation_app/models/user_model.dart" as user_model;

// TODO: Add loading state for saving and loading image
// TODO: Add snackbar to show successfully edited status

class OrgDonationFormPage extends StatefulWidget {
  const OrgDonationFormPage({super.key});

  @override
  State<OrgDonationFormPage> createState() => OrgDonationFormPageState();
}

class OrgDonationFormPageState extends State<OrgDonationFormPage> {
  late User? _currentUser;

  late List<String> _categories;
  late TextEditingController _otherCategoriesController;
  late TextEditingController _weightController;
  late String _weightUnit;
  late String _mode;
  late List<TextEditingController> _addressControllers;
  late TextEditingController _contactNumController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late String _photo;
  late String _photoDownloadURL;
  late String _status;
  late DateTime _timestamp;
  String _deletedPhoto = '';
  File? _selectedPhoto;

  Donation? _selectedDonation;
  user_model.User? _selectedOrg;
  bool get isViewMode => true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // fetch user details
    _currentUser = FirebaseAuth.instance.currentUser;

    _selectedDonation = context.read<DonationProvider>().selected;

    _categories = _selectedDonation!.categories;
    _otherCategoriesController = TextEditingController();
    _weightController =
        TextEditingController(text: _selectedDonation!.weight.toString());
    _weightUnit = _selectedDonation!.weightUnit;
    _mode = _selectedDonation!.mode;
    _addressControllers = _selectedDonation!.addresses
        .map((address) => TextEditingController(text: address))
        .toList();
    _contactNumController =
        TextEditingController(text: _selectedDonation!.contactNum);
    _dateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(_selectedDonation!.date));
    _timeController = TextEditingController(text: _selectedDonation!.time);
    _photo = _selectedDonation!.photo;
    _photoDownloadURL = '';
    _status = _selectedDonation!.status;
    _timestamp = _selectedDonation!.timestamp;

    _loadDownloadURLs();
  }

  @override
  void dispose() {
    _otherCategoriesController.dispose();
    _weightController.dispose();
    for (var controller in _addressControllers) {
      controller.dispose();
    }
    _contactNumController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _loadDownloadURLs() async {
    if (_photo != '') {
      String downloadURL = await context
          .read<DonationProvider>()
          .fetchDownloadURLForImage(_photo);
      setState(() {
        _photoDownloadURL = downloadURL;
      });
    }
  }

  void _addNewCategory(String category) {
    setState(() {
      _categories.add(category);
    });
    Navigator.pop(context); // close the modal
  }

  Widget _buildImageContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Image (optional)",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          if (_photoDownloadURL != '' || _selectedPhoto != null)
            Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ShowFullImage(
                          image: _photoDownloadURL != ''
                              ? _photoDownloadURL
                              : _selectedPhoto,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: _photoDownloadURL != ''
                            ? NetworkImage(_photoDownloadURL)
                            : FileImage(_selectedPhoto!)
                                as ImageProvider<Object>,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                if (!isViewMode)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _photo = '';
                          _deletedPhoto = _photoDownloadURL;
                          _photoDownloadURL = '';
                          _selectedPhoto = null;
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          if (_photoDownloadURL == '' && _selectedPhoto == null)
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.grey[200],
              ),
              child: Center(
                child: Icon(
                  Icons.image,
                  color: Colors.grey[400],
                  size: 48,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required BuildContext context,
    required String type, // text, date, time
    required String label,
    required TextEditingController controller,
    required bool enabled,
    required String? Function(String?) validator,
    int minLines = 1,
    int? maxLines,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            enabled: enabled,
            validator: validator,
            minLines: minLines,
            maxLines: maxLines,
            onTap: () {
              // not needed for org view
              // if (type == 'date') {
              //   _showDatePicker(context, controller);
              // } else if (type == 'time') {
              //   _showTimePicker(context, controller);
              // }
            },
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              labelText: label,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              alignLabelWithHint: true,
              suffixIcon: suffixIcon,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1.0,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
          title: Text(
        "View Donation Details",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
      )),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      ..._categories.map((option) {
                        return CheckboxListTile(
                          enabled: !isViewMode,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(option),
                          value: _categories.contains(option),
                          onChanged: (newValue) {
                            setState(() {
                              if (newValue!) {
                                _categories.add(option);
                              } else {
                                _categories.remove(option);
                              }
                            });
                          },
                        );
                      }).toList()
                    ])),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildFormField(
                    context: context,
                    type: 'number',
                    label: 'Weight',
                    controller: _weightController,
                    enabled: !isViewMode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter weight';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: _weightUnit,
                    onChanged: isViewMode
                        ? null
                        : (newValue) {
                            setState(() {
                              _weightUnit = newValue!;
                            });
                          },
                    items: <String>['kg', 'lbs'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mode of Transfer',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  RadioListTile<String>(
                    title: const Text('Pick-up'),
                    value: 'Pick-up',
                    groupValue: _mode,
                    onChanged: isViewMode
                        ? null
                        : (value) {
                            setState(() {
                              _mode = value as String;
                            });
                          },
                  ),
                  RadioListTile<String>(
                    title: const Text('Drop-off'),
                    value: 'Drop-off',
                    groupValue: _mode,
                    onChanged: isViewMode
                        ? null
                        : (value) {
                            setState(() {
                              _mode = value as String;
                            });
                          },
                  ),
                ],
              ),
            ),
            if (_mode == 'Pick-up') ...[
              ..._addressControllers.map((controller) {
                final int index = _addressControllers.indexOf(controller);
                return Row(
                  children: [
                    Expanded(
                      child: _buildFormField(
                        context: context,
                        type: 'text',
                        label: 'Address ${index + 1}',
                        controller: controller,
                        enabled: !isViewMode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an address';
                          }
                          return null;
                        },
                        minLines: 1,
                        maxLines: null,
                      ),
                    ),
                  ],
                );
              }).toList(),
              _buildFormField(
                context: context,
                type: 'text',
                label: 'Contact Number',
                controller: _contactNumController,
                enabled: !isViewMode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact number';
                  }
                  return null;
                },
              ),
            ],
            _buildFormField(
              context: context,
              type: 'date',
              label: 'Date of Pick-up/Drop-off',
              controller: _dateController,
              enabled: !isViewMode,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter date of pick-up/drop-off';
                }
                return null;
              },
              minLines: 1,
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            const SizedBox(height: 8),
            _buildFormField(
              context: context,
              type: 'time',
              label: 'Time of Pick-up/Drop-off',
              controller: _timeController,
              enabled: !isViewMode,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter time of pick-up/drop-off';
                }
                return null;
              },
              minLines: 1,
              suffixIcon: const Icon(Icons.access_time),
            ),
            const SizedBox(height: 8),
            _buildImageContainer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text('Save'),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
