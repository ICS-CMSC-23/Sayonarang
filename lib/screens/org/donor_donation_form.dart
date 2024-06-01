import "package:donation_app/models/donation_model.dart";
import "package:donation_app/providers/donation_provider.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

class DonorDonationFormPage extends StatefulWidget {
  final String mode; // add, edit, view
  const DonorDonationFormPage({super.key, required this.mode});

  @override
  State<DonorDonationFormPage> createState() => DonorDonationFormPageState();
}

class DonorDonationFormPageState extends State<DonorDonationFormPage> {
  late User? _currentUser;

  late List<String> _categories;
  late TextEditingController _contacNumController;
  late TextEditingController _dateController;
  late TextEditingController _weightController;
  late String _weightUnit;

  Donation? _selectedDonation;
  bool get isViewMode => widget.mode == "view";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // fetch user details
    _currentUser = FirebaseAuth.instance.currentUser;

    if (widget.mode == "edit" || widget.mode == "view") {
      _selectedDonation = context.read<DonationProvider>().selected;

      _categories = _selectedDonation!.categories;
      _contacNumController =
          TextEditingController(text: _selectedDonation!.contactNum);
      _dateController = TextEditingController(
          text: DateFormat('yyyy-MM-dd').format(_selectedDonation!.date));
      _weightController =
          TextEditingController(text: _selectedDonation!.weight.toString());
      _weightUnit = _selectedDonation!.weightUnit;
    } else {
      _categories = [];
      _contacNumController = TextEditingController();
      _dateController = TextEditingController();
      _weightController = TextEditingController();
      _weightUnit = 'kg';
    }
  }

  @override
  void dispose() {
    _contacNumController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Widget _buildFormField({
    required BuildContext context,
    required type, // text, date, time
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
          "${widget.mode == "add" ? "Add" : widget.mode == "edit" ? "Edit" : "View"} Donation ${widget.mode == "view" ? "Details" : ""}",
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
                // TODO: Add categories (checkboxes: Food, Cash, Necessities), then additional categories in an other but text field and should be separated with comma
                ...['Food', 'Cash', 'Necessities'].map((option) {
                  return CheckboxListTile(
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
                }).toList(),

                // loop through addresses and display them using the _buildFormField function

                _buildFormField(
                  context: context,
                  type: 'text',
                  label: 'Contact Number',
                  controller: _contacNumController,
                  enabled: !isViewMode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a contact number';
                    }
                    return null;
                  },
                ),
                _buildFormField(
                    context: context,
                    type: 'date',
                    label: 'Date of Pickup/Drop-off',
                    controller: _dateController,
                    enabled: !isViewMode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter date of pickup/drop-off';
                      }
                      return null;
                    },
                    minLines: 1,
                    suffixIcon: const Icon(Icons.calendar_today)),
                // TODO: Display date (above) and time field in the same row
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
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: _weightUnit,
                        onChanged: (newValue) {
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
                  ],
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
                            // create Donation object
                            // call function based on mode
                            if (widget.mode == "add") {
                              // context.read<DonationProvider>().addDonation(donation);
                              Navigator.pop(context);
                            } else if (widget.mode == "edit") {
                              // context.read<DonationProvider>().editDonation(
                              //     );
                              // TODO: find fix for when going to back to view details page from edit, the details page is updated
                              // current solution is to pop twice to go back to the donations page
                              // https: //stackoverflow.com/a/74316628
                              Navigator.of(context)
                                ..pop()
                                ..pop(); // kanta ni nayeon hahahaha
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
                                      const DonorDonationFormPage(mode: "edit"),
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
