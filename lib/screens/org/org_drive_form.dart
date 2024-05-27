import "package:donation_app/models/drive_model.dart";
import "package:donation_app/providers/drive_provider.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

class DriveFormPage extends StatefulWidget {
  final String mode; // add, edit, view
  const DriveFormPage({super.key, required this.mode});

  @override
  State<DriveFormPage> createState() => DriveFormPageState();
}

class DriveFormPageState extends State<DriveFormPage> {
  late User? _currentUser;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _endDateController;
  late List<String> _donationIds;
  Drive? _selectedDrive;
  bool get isViewMode => widget.mode == "view";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // fetch user details
    _currentUser = FirebaseAuth.instance.currentUser;

    if (widget.mode == "edit" || widget.mode == "view") {
      _selectedDrive = context.read<DriveProvider>().selected;

      _titleController = TextEditingController(text: _selectedDrive?.title);
      _descriptionController =
          TextEditingController(text: _selectedDrive?.description);
      _endDateController = TextEditingController(
          text: DateFormat('yyyy-MM-dd').format(_selectedDrive!.endDate));
      _donationIds = _selectedDrive!.donationIds;
    } else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      _endDateController = TextEditingController();
      _donationIds = [];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
          title: Text(
        "${widget.mode == "add" ? "Add" : widget.mode == "edit" ? "Edit" : "View"} Donation Drive ${widget.mode == "view" ? "Details" : ""}",
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
              _buildFormField(
                context: context,
                type: 'text',
                label: 'Title',
                controller: _titleController,
                enabled: !isViewMode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              _buildFormField(
                context: context,
                type: 'text',
                label: 'Description',
                controller: _descriptionController,
                enabled: !isViewMode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                minLines: 5,
                maxLines: null,
              ),
              _buildFormField(
                  context: context,
                  type: 'date',
                  label: 'End Date',
                  controller: _endDateController,
                  enabled: !isViewMode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an end date';
                    }
                    return null;
                  },
                  minLines: 1,
                  suffixIcon: Icon(Icons.calendar_today)),
              if (!isViewMode)
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Drive drive = Drive(
                          orgId: _currentUser?.uid,
                          title: _titleController.text,
                          description: _descriptionController.text,
                          endDate: DateFormat('yyyy-MM-dd')
                              .parse(_endDateController.text),
                          donationIds: _donationIds);

                      // call function based on mode
                      if (widget.mode == "add") {
                        context.read<DriveProvider>().addDrive(drive);
                      } else if (widget.mode == "edit") {
                        drive.id = _selectedDrive?.id;
                        context.read<DriveProvider>().editDrive(
                              _titleController.text,
                              _descriptionController.text,
                              _donationIds,
                              DateFormat('yyyy-MM-dd')
                                  .parse(_endDateController.text),
                            );
                      }

                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.mode == "add" ? 'Add' : 'Update'),
                ),
            ],
          ),
        ),
      ),
    );
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
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
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              labelText: label,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              alignLabelWithHint: true,
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              enabledBorder: OutlineInputBorder(
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
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
    if (pickedTime != null) {
      controller.text = pickedTime.format(context);
    }
  }
}
