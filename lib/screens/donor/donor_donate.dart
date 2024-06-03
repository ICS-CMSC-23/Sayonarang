import 'package:flutter/material.dart';
import 'package:donation_app/models/donate_data.dart';
import 'package:donation_app/models/user_model.dart' as AppUser;
import 'package:donation_app/providers/donate_provider.dart';
import 'package:provider/provider.dart';
import 'pick_image.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class DonorDonatePage extends StatefulWidget {
  final AppUser.User organization;

  const DonorDonatePage({super.key, required this.organization});

  @override
  _DonorDonatePageState createState() => _DonorDonatePageState();
}

class _DonorDonatePageState extends State<DonorDonatePage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formValues = {
    'categories': <String>[],
    'mode': "Pick-up",
    'addresses': <String>[],
    'contactNum': "",
    'weight': 0.0,
    'weightUnit': "kg",
    'photo': "",
    'date': DateTime.now(),
    'time': "",
    'driveId': "",
    'status': "pending",
    'timestamp': DateTime.now(),
  };

  final List<String> _modeOptions = ["Pick-up", "Drop-off"];
  final List<String> _donateOptions = ['Food', 'Clothes', 'Cash', 'Necessities', 'Others'];
  
  String _mode = "Pick-up";
  bool _showUploadButton = false;
  late String currentDonorId;

  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final List<TextEditingController> addressControllers = [TextEditingController()];
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _initializeCurrentDonorId();
    _initializeListeners();
    _textEditingController = TextEditingController();
  }

  void _initializeListeners() {
    _numberController.addListener(() {
      setState(() {
        formValues["contactNum"] = _numberController.text;
      });
    });

    addressControllers[0].addListener(() {
      if (addressControllers[0].text.isNotEmpty) {
        setState(() {
          formValues["addresses"] = addressControllers.map((c) => c.text).toList();
        });
      }
    });

    formValues["addresses"] = [];
  }

  Future<void> _initializeCurrentDonorId() async {
    Auth.User? user = Auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentDonorId = user.uid;
      });
    } else {
      print("No user logged in");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
        formValues['date'] = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
        formValues['time'] = _timeController.text;
      });
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _textEditingController.dispose();
    for (var controller in addressControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donate to ${widget.organization.name}'),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 230, 230),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color.fromARGB(255, 255, 230, 230), width: 5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ], 
            ),
            constraints: BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSectionTitle("Fill up the following to donate:"),
                    _buildSectionTitle("Items to Donate"),
                    _buildCategorySelection(),
                    _buildSectionTitle("Modes of Transportation:"),
                    _buildSubTitle("Which mode do you prefer?"),
                    _buildModeSelection(),
                    if (_mode == "Pick-up") _buildPickupFields(),
                    _buildSectionTitle("Enter Weight of Donation:"),
                    _buildWeightField(),
                    _buildWeightUnitDropdown(),
                    _buildSectionTitle("Upload a photo (optional)"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: SwitchListTile(
                              title: const Text("Show Upload Options"),
                              value: _showUploadButton,
                              onChanged: (bool? value) {
                                setState(() {
                                  _showUploadButton = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _showUploadButton,
                      child: Column(
                        children: [
                          PickImage(
                            onImagePicked: (String imageName) {
                              setState(() {
                                formValues["photo"] = imageName;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    _buildSectionTitle("Date and Time"),
                    _buildDateTimeFields(),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSubTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
        ),
      ),
    );
  }

  Widget _buildCategorySelection() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          ..._donateOptions.map((option) => CheckboxListTile(
            title: Text(option),
            value: formValues["categories"].contains(option),
            onChanged: (value) {
              setState(() {
                if (value!) {
                  formValues["categories"].add(option);
                } else {
                  formValues["categories"].remove(option);
                }
              });
            },
          )).toList(),
          ElevatedButton(
            onPressed: () => _addNewCategory(context),
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addNewCategory(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add new option'),
          content: TextFormField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: 'Enter new option',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a category name';
              }
              return null;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_textEditingController.text.isNotEmpty) {
                  setState(() {
                    String enteredText = _textEditingController.text;
                    _donateOptions.add(enteredText);
                    formValues["categories"].add(enteredText);
                  });
                  Navigator.of(context).pop();
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Please enter a category name.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildModeSelection() {
    return FormField(
      builder: (value) => Column(
        children: _modeOptions.map((mode) => RadioListTile<String>(
          title: Text(mode),
          value: mode,
          groupValue: _mode,
          onChanged: (String? value) {
            setState(() {
              _mode = value!;
              formValues["mode"] = _mode;
            });
          },
        )).toList(),
      ),
    );
  }

  Widget _buildPickupFields() {
    return Column(
      children: [
        _buildSectionTitle("Enter address(es):"),
        _buildAddressFields(),
        _buildSectionTitle("Enter a Contact Number:"),
        _buildContactNumberField(),
      ],
    );
  }

  Widget _buildAddressFields() {
    return Column(
      children: [
        ...List.generate(
          addressControllers.length,
          (index) => Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: addressControllers[index],
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Address ${index + 1}',
                suffixIcon: addressControllers.length > 1
                    ? IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () {
                          setState(() {
                            addressControllers.removeAt(index);
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (String value) {
                formValues["addresses"][index] = value;
              },
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              addressControllers.add(TextEditingController());
            });
          },
          child: const Text('Add Address'),
        ),
      ],
    );
  }

  Widget _buildContactNumberField() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: _numberController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Contact Number",
          labelText: "Contact Number",
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your contact number';
          }
          return null;
        },
        onChanged: (value) {
          formValues["contactNum"] = value;
        },
      ),
    );
  }

  Widget _buildWeightField() {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Enter weight",
        labelText: "Weight",
      ),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the weight';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          formValues["weight"] = double.parse(value);
        });
      },
    ),
  );
}

  Widget _buildWeightUnitDropdown() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField<String>(
        value: formValues["weightUnit"],
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Weight Unit',
        ),
        items: <String>['kg', 'lbs']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            formValues["weightUnit"] = value!;
          });
        },
      ),
    );
  }

  Widget _buildPhotoUpload() {
    return Column(
      children: [
        if (_showUploadButton) PickImage(
          onImagePicked: (String imageName) {
            setState(() {
              formValues["Photo"] = imageName;
            });
          },
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showUploadButton = true;
            });
          },
          child: const Text('Upload Image'),
        ),
        if (formValues['photo'] != null) Text(formValues['photo']),
      ],
    );
  }

  Widget _buildDateTimeFields() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: _dateController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Date',
            ),
            onTap: () {
              _selectDate(context);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: _timeController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Time',
            ),
            onTap: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
Widget _buildSubmitButton() {
  return Padding(
    padding: const EdgeInsets.all(10), 
    child: SizedBox(
      width: double.infinity, 
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red, 
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), 
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            formValues["addresses"] = addressControllers.map((controller) => controller.text).toList();

            Provider.of<DonateDataProvider>(context, listen: false).addDonation(
              DonateData(
                id: null,
                orgId: widget.organization.id,
                donorId: currentDonorId,
                driveId: formValues["driveId"],
                categories: formValues["categories"],
                mode: formValues["mode"],
                addresses: formValues["addresses"],
                contactNum: formValues["contactNum"],
                weight: formValues["weight"],
                photo: formValues["photo"],
                date: formValues["date"],
                time: formValues["time"],
                status: formValues["status"],
                timestamp: formValues["timestamp"],
                weightUnit: formValues["weightUnit"],
              ),
            );

            Navigator.of(context).pop();
          }
        },
        child: const Text('Submit'),
      ),
    ),
  );
}
}
