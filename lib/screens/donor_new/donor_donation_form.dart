import 'package:donation_app/models/donation_model.dart';
import 'package:donation_app/providers/donation_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// TODO: Add optional image field
// TODO: Display image and use the image_view to expand
class DonorDonationFormPage extends StatefulWidget {
  final String mode; // add, edit, view
  const DonorDonationFormPage({super.key, required this.mode});

  @override
  State<DonorDonationFormPage> createState() => DonorDonationFormPageState();
}

class DonorDonationFormPageState extends State<DonorDonationFormPage> {
  late List<String> _categories;
  late TextEditingController _otherCategoriesController;
  late TextEditingController _weightController;
  late String _weightUnit;
  late String? _mode;
  late List<TextEditingController> _addressControllers;
  late TextEditingController _contactNumController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;

  Donation? _selectedDonation;
  bool get isViewMode => widget.mode == 'view';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

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
    } else {
      _categories = [];
      _otherCategoriesController = TextEditingController();
      _weightController = TextEditingController();
      _weightUnit = 'kg';
      _mode = 'Pick-up';
      _addressControllers = [TextEditingController()];
      _contactNumController = TextEditingController();
      _dateController = TextEditingController();
      _timeController = TextEditingController();
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

  void _addCustomCategory(String category) {
    setState(() {
      _categories.add(category);
    });
    Navigator.pop(context); // close the modal
  }

  void _showAddCategoryModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Custom Category'),
          content: TextField(
            controller: _otherCategoriesController,
            decoration: InputDecoration(hintText: 'Enter category'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                String category = _otherCategoriesController.text.trim();
                if (category.isNotEmpty) {
                  _addCustomCategory(category);
                }
              },
            ),
          ],
        );
      },
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
                          Text(
                            'Categories',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          if (!isViewMode) ...[
                            // pre-defined categories: Food, Cash, Necessities
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text('Food'),
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
                              title: Text('Cash'),
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
                              title: Text('Necessities'),
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
                                child: Text('Add Category'),
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
                      Text(
                        'Mode of Transfer',
                        style: const TextStyle(
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
                          ),
                        ),
                        if (!isViewMode &&
                            index !=
                                0) // ensure the first address is not removable
                          // TODO: Fix alignment
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
                if (!isViewMode)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Create Donation object
                            if (widget.mode == 'add') {
                              // final newDonation = Donation(
                              //   contactNum: _contactNumController.text,
                              //   date: DateTime.parse(_dateController.text),
                              //   weight: double.parse(_weightController.text),
                              //   weightUnit: _weightUnit,
                              //   categories: _categories,
                              //   addresses: _addressControllers
                              //       .map((controller) => controller.text)
                              //       .toList(),
                              // );
                              //   context
                              //       .read<DonationProvider>()
                              //       .addDonation(newDonation);
                              Navigator.pop(context);
                            } else if (widget.mode == 'edit') {
                              // context
                              //     .read<DonationProvider>()
                              //     .editDonation(newDonation);
                              Navigator.of(context)
                                ..pop()
                                ..pop();
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
                if (isViewMode)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DonorDonationFormPage(mode: 'edit'),
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
                              context.read<DonationProvider>().deleteDonation();
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
