import 'package:donation_app/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_app/models/user_model.dart' as user_model;

// TODO: Add loading state for saving and loading images
// TODO: Add snackbar to show successfully edited or successfully saved

class OrgProfilePage extends StatefulWidget {
  final String mode; // edit, view
  const OrgProfilePage({Key? key, required this.mode}) : super(key: key);

  @override
  State<OrgProfilePage> createState() => OrgProfilePageState();
}

class OrgProfilePageState extends State<OrgProfilePage> {
  late User? _currentUser;
  late Future<DocumentSnapshot> _userDocFuture;

  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late List<TextEditingController> _addressControllers;
  late TextEditingController _contactNumController;
  late TextEditingController _descriptionController;
  late String _status;
  late bool _isOpen;
  bool _isLoading = true; // Add a loading state

  bool get isViewMode => widget.mode == "view";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _descriptionController = TextEditingController();
    _addressControllers = [TextEditingController()];
    _contactNumController = TextEditingController();
    _status = '';
    _isOpen = false;

    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      _userDocFuture =
          context.read<MyAuthProvider>().getUserById(_currentUser!.uid);
      _getUserDetails(); // Call _getUserDetails to fetch user details
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    for (var controller in _addressControllers) {
      controller.dispose();
    }
    _contactNumController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  Future<void> _getUserDetails() async {
    final DocumentSnapshot userSnapshot = await _userDocFuture;
    final userData =
        user_model.User.fromJson(userSnapshot.data() as Map<String, dynamic>);

    setState(() {
      _nameController.text = userData.name;
      _usernameController.text = userData.username;
      _descriptionController.text = userData.description;
      _addressControllers = userData.addresses
          .map((address) => TextEditingController(text: address))
          .toList();
      _contactNumController.text = userData.contactNum;
      _status = userData.status;
      _isOpen = userData.isOpen;
      _isLoading = false; // Set loading to false after data is fetched
    });
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
          "${widget.mode == "edit" ? "Edit" : ""} Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        )),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (isViewMode) ...[
                        const SizedBox(height: 8),
                        const Icon(
                          Icons.business,
                          size: 72,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: getStatusColor(_status),
                            borderRadius: BorderRadius.circular(64.0),
                          ),
                          child: Text(
                            'Status: ${_status}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      _buildFormField(
                        context: context,
                        type: 'text',
                        label: 'Name',
                        controller: _nameController,
                        enabled: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      _buildFormField(
                        context: context,
                        type: 'text',
                        label: 'Username',
                        controller: _usernameController,
                        enabled: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                      ),
                      // only description, addresses, contact number, and isOpen can be edited by the org
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
                      ..._addressControllers.map((controller) {
                        final int index =
                            _addressControllers.indexOf(controller);
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
                            return 'Please enter a contact number';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Are you accepting donations?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            IgnorePointer(
                              ignoring: isViewMode,
                              child: Row(children: [
                                const Text("No"),
                                const SizedBox(width: 4),
                                Switch(
                                    value: _isOpen,
                                    onChanged: !isViewMode
                                        ? (value) {
                                            setState(() {
                                              _isOpen = value;
                                            });
                                          }
                                        : null,
                                    activeColor:
                                        Theme.of(context).colorScheme.primary),
                                const SizedBox(width: 4),
                                const Text("Yes"),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (!isViewMode) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (!context.mounted) return; // mounted check
                                  context.read<MyAuthProvider>().editOrgDetails(
                                        _currentUser!.uid,
                                        _addressControllers
                                            .map(
                                                (controller) => controller.text)
                                            .toList(),
                                        _contactNumController.text,
                                        _isOpen,
                                      );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Successfully edited the profile!')),
                                  );
                                  Navigator.of(context)
                                      .pop(); // TODO: Fix changes not reflecting after editing org
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const OrgProfilePage(mode: "edit"),
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
                              label: const Text('Edit Profile'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                // if (_formKey.currentState!.validate()) {
                                if (!context.mounted) return; // mounted check
                                context.read<MyAuthProvider>().signOut();
                                // }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                              child: const Text('Log-out'),
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
