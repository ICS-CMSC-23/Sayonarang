import 'package:donation_app/models/donation_model.dart';
import 'package:donation_app/providers/donation_provider.dart';
import 'package:donation_app/providers/user_provider.dart';
import 'package:donation_app/screens/donor_new/donor_drive_form.dart';
import 'package:donation_app/screens/donor_new/donor_qrcode.dart';
import 'package:donation_app/screens/shared/image_viewer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import "package:firebase_auth/firebase_auth.dart";
import "package:donation_app/models/user_model.dart" as user_model;

// TODO: Add loading state for saving and loading image
// TODO: Show details of organization before donating

class DonorDonationFormPage extends StatefulWidget {
  final String mode; // add, edit, view
  const DonorDonationFormPage({super.key, required this.mode});

  @override
  State<DonorDonationFormPage> createState() => DonorDonationFormPageState();
}

class DonorDonationFormPageState extends State<DonorDonationFormPage> {
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
  bool get isViewMode => widget.mode == 'view';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // fetch user details
    _currentUser = FirebaseAuth.instance.currentUser;

    if (widget.mode == 'edit' || widget.mode == 'view') {
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
    } else {
      // only fetch selected organization when creating a new donation
      _selectedOrg = context.read<MyAuthProvider>().selected;

      _categories = [];
      _otherCategoriesController = TextEditingController();
      _weightController = TextEditingController();
      _weightUnit = 'kg';
      _mode = 'Pick-up';
      _addressControllers = [TextEditingController()];
      _contactNumController = TextEditingController();
      _dateController = TextEditingController();
      _timeController = TextEditingController();
      _photo = '';
      _photoDownloadURL = '';
      _status = 'pending';
      _timestamp = DateTime.now();
    }
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
    if (widget.mode == "edit" || widget.mode == "view") {
      if (_photo != '') {
        String downloadURL = await context
            .read<DonationProvider>()
            .fetchDownloadURLForImage(_photo);
        setState(() {
          _photoDownloadURL = downloadURL;
        });
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      _selectedPhoto = File(pickedFile.path);
    });
  }

  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) return;

    setState(() {
      _selectedPhoto = File(pickedFile.path);
    });
  }

  void _addNewCategory(String category) {
    setState(() {
      _categories.add(category);
    });
    Navigator.pop(context); // close the modal
  }

  void _showDonationCancellationModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          title: const Text('Cancel Donation'),
          content: const Text('Are you sure you want to cancel the donation?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<DonationProvider>()
                    .editDonationStatus("cancelled");

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Successfully cancelled the donation!')),
                );

                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showAddCategoryModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          title: const Text('Add New Category'),
          content: TextField(
            controller: _otherCategoriesController,
            decoration: const InputDecoration(hintText: 'Enter category'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                String category = _otherCategoriesController.text.trim();
                if (category.isNotEmpty) {
                  _addNewCategory(category);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDatePicker(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  void _showTimePicker(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (!context.mounted) return; // mounted check
    if (pickedTime != null) {
      controller.text = pickedTime.format(context);
    }
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
              if (type == 'date') {
                _showDatePicker(context, controller);
              } else if (type == 'time') {
                _showTimePicker(context, controller);
              }
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

  Future<bool?> _showBackDialog() {
    if (isViewMode) {
      // return true immediately if in view mode
      return Future.value(true);
    }
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          title: const Text('Are you sure you want to leave?'),
          content: const Text('Any unsaved changes will be lost.'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _showBackDialog() ?? false;
        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          "${widget.mode == 'add' ? 'Add' : widget.mode == 'edit' ? 'Edit' : 'View'} Donation ${widget.mode == 'view' ? 'Details' : ''}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        )),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                          if (!isViewMode) ...[
                            // pre-defined categories: Food, Clothes, Cash, Necessities
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: const Text('Food'),
                              value: _categories.contains('Food'),
                              onChanged: (newValue) {
                                setState(() {
                                  if (newValue!) {
                                    _categories.add('Food');
                                  } else {
                                    _categories.remove('Food');
                                  }
                                });
                              },
                            ),
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: const Text('Clothes'),
                              value: _categories.contains('Clothes'),
                              onChanged: (newValue) {
                                setState(() {
                                  if (newValue!) {
                                    _categories.add('Clothes');
                                  } else {
                                    _categories.remove('Clothes');
                                  }
                                });
                              },
                            ),
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: const Text('Cash'),
                              value: _categories.contains('Cash'),
                              onChanged: (newValue) {
                                setState(() {
                                  if (newValue!) {
                                    _categories.add('Cash');
                                  } else {
                                    _categories.remove('Cash');
                                  }
                                });
                              },
                            ),
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: const Text('Necessities'),
                              value: _categories.contains('Necessities'),
                              onChanged: (newValue) {
                                setState(() {
                                  if (newValue!) {
                                    _categories.add('Necessities');
                                  } else {
                                    _categories.remove('Necessities');
                                  }
                                });
                              },
                            ),
                            // display categories aside from the pre-defined ones
                            ..._categories
                                .where((option) => ![
                                      'Food',
                                      'Clothes',
                                      'Necessities',
                                      'Cash'
                                    ].contains(option))
                                .map((option) {
                              return CheckboxListTile(
                                enabled: !isViewMode,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
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
                            }).toList(),
                            Center(
                              child: TextButton(
                                onPressed: _showAddCategoryModal,
                                child: const Text('Add Category'),
                              ),
                            ),
                          ],
                          if (isViewMode)
                            ..._categories.map((option) {
                              return CheckboxListTile(
                                enabled: !isViewMode,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                        if (!isViewMode &&
                            index !=
                                0) // ensure the first address is not removable
                          // TODO: Fix alignment of button to remove address
                          IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _addressControllers.removeAt(index);
                              });
                            },
                          ),
                      ],
                    );
                  }).toList(),
                  if (!isViewMode)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _addressControllers.add(TextEditingController());
                        });
                      },
                      child: const Text('Add Address'),
                    ),
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
                if (!isViewMode) ...[
                  _buildImageContainer(),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _pickImageFromGallery();
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2.0,
                              ),
                            ),
                            icon: const Icon(Icons.image_search),
                            label: const Text('Gallery'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _pickImageFromCamera();
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2.0,
                              ),
                            ),
                            icon: const Icon(Icons.camera_alt_outlined),
                            label: const Text('Camera'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (_categories.isNotEmpty) {
                              if (widget.mode == 'add') {
                                String fileName = '';
                                if (_selectedPhoto != null) {
                                  fileName = await context
                                      .read<DonationProvider>()
                                      .uploadFile(_selectedPhoto!);
                                }
                                final newDonation = Donation(
                                  donorId: _currentUser!.uid,
                                  orgId: _selectedOrg!.id!,
                                  driveId: '',
                                  categories: _categories,
                                  addresses: _addressControllers
                                      .map((controller) => controller.text)
                                      .toList(),
                                  mode: _mode,
                                  weight: double.parse(_weightController.text),
                                  weightUnit: _weightUnit,
                                  contactNum: _contactNumController.text,
                                  status: _status,
                                  date: DateTime.parse(_dateController.text),
                                  time: _timeController.text,
                                  photo: fileName,
                                  timestamp: _timestamp,
                                );

                                if (!context.mounted) return; // mounted check
                                context
                                    .read<DonationProvider>()
                                    .addDonation(newDonation);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Successfully added donation!')),
                                );
                              } else if (widget.mode == 'edit') {
                                String fileName = _photo;
                                if (_selectedPhoto != null) {
                                  fileName = await context
                                      .read<DonationProvider>()
                                      .uploadFile(_selectedPhoto!);
                                }

                                // delete photo only if there is one to delete
                                if (_deletedPhoto != '') {
                                  if (!context.mounted) return; // mounted check
                                  context
                                      .read<DonationProvider>()
                                      .deleteFile(_deletedPhoto);
                                }

                                if (!context.mounted) return; // mounted check
                                context
                                    .read<DonationProvider>()
                                    .editDonationDetails(
                                      _categories,
                                      _addressControllers
                                          .map((controller) => controller.text)
                                          .toList(),
                                      _mode,
                                      double.parse(_weightController.text),
                                      _weightUnit,
                                      _contactNumController.text,
                                      DateTime.parse(_dateController.text),
                                      _timeController.text,
                                      fileName,
                                    );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Successfully edited donation!')),
                                );

                                Navigator.of(context)
                                  ..pop()
                                  ..pop();
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please select at least one category',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        child: const Text('Save'),
                      ),
                    ),
                  ),
                ],
                if (isViewMode) ...[
                  _buildImageContainer(),
                  if (_mode == 'Drop-off')
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DonorQRCodeScreen(
                                      donationId: _selectedDonation!.id!,
                                      status: _selectedDonation!.status,
                                      timestamp: _selectedDonation!.timestamp,
                                    ),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    Theme.of(context).colorScheme.primary,
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2.0,
                                ),
                              ),
                              icon: const Icon(Icons.qr_code_2),
                              label: const Text('View QR Code'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  // only allow edit and delete of donation if pending status
                  if (_status == 'pending')
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DonorDonationFormPage(
                                            mode: 'edit'),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    Theme.of(context).colorScheme.primary,
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2.0,
                                ),
                              ),
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                context
                                    .read<DonationProvider>()
                                    .deleteDonation();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Successfully deleted the donation!')),
                                );
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    Theme.of(context).colorScheme.primary,
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2.0,
                                ),
                              ),
                              icon: const Icon(Icons.delete),
                              label: const Text('Delete'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  // only allow cancellation if status is not yet completed
                  if (_status != 'completed' && _status != 'cancelled')
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _showDonationCancellationModal,
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  // only show donation drive when status is not pending or cancelled
                  if (_status != 'pending' && _status != 'cancelled') ...[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  DonorDriveFormPage(mode: 'view')),
                        );
                      },
                      child: const Text('Where is my donation going?'),
                    ),
                    const SizedBox(height: 8),
                  ],
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
