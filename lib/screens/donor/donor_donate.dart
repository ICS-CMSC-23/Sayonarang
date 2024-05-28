import 'package:donation_app/models/donation_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:donation_app/models/donate_data.dart';
import 'package:donation_app/models/user_model.dart' as AppUser;
import 'package:donation_app/providers/donate_provider.dart';
import 'package:provider/provider.dart';
import 'pick_image.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class DonorDonatePage extends StatefulWidget {
  final AppUser.User organization;

  const DonorDonatePage({super.key, required this.organization});

  @override
  _DonorDonatePageState createState() => _DonorDonatePageState();
}

class _DonorDonatePageState extends State<DonorDonatePage> {
  String? currentDonationId;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formValues = {
    'Donation': <String>[],
    'Mode of Transaction': "Pick-up",
    'Address': <String>[],
    'Contact Number': "",
    'Weight': "",
    'WeightUnit': "kg",
    'Photo': "",
    'Date': "",
    'Time': "",
  };

  List<String> _modeOptions = ["Pick-up", "Drop-off"];
  List<String> _donateOptions = [
    'Food',
    'Clothes',
    'Cash',
    'Necessities',
    'Others'
  ];

  String _mode = "Pick-up";
  String photo = " ";
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  List<TextEditingController> addressControllers = [TextEditingController()];
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _showUploadButton = false;
  late String currentDonorId;

  @override
  void initState() {
    super.initState();
    _initializeCurrentDonorId();
    _textFieldController.addListener(() {
      print("Latest Value: ${_textFieldController.text}");
    });
    addressControllers[0].addListener(() {
      if (addressControllers[0].text.isNotEmpty) {
        setState(() {
          formValues["Address"] =
              addressControllers.map((c) => c.text).toList();
        });
      }
    });

    formValues["Address"] = [];
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
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
        formValues['Date'] = _dateController.text;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != TimeOfDay.now()) {
      setState(() {
        _timeController.text = picked.format(context);
        formValues['Time'] = _timeController.text;
      });
    }
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _numberController.dispose();
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "Fill up the following to donate:",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [Text("Items to Donate")],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ..._donateOptions
                        .map((option) => CheckboxListTile(
                              title: Text(option),
                              value: formValues["Donation"].contains(option),
                              onChanged: (value) {
                                setState(() {
                                  if (value!) {
                                    formValues["Donation"].add(option);
                                  } else {
                                    formValues["Donation"].remove(option);
                                  }
                                });
                              },
                            ))
                        .toList(),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String newOption = '';
                            return AlertDialog(
                              title: Text('Add new option'),
                              content: TextField(
                                onChanged: (value) {
                                  newOption = value;
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _donateOptions.add(newOption);
                                      formValues["Donation"].add(newOption);
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Add'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Modes of Transportation:",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [Text("Which mode do you prefer?")],
              ),
              FormField(
                builder: (value) => Column(
                  children: <Widget>[
                    RadioListTile<String>(
                      title: Text(_modeOptions[0]),
                      value: _modeOptions[0],
                      groupValue: _mode,
                      onChanged: (String? value) {
                        setState(() {
                          _mode = value!;
                          formValues["Mode of Transaction"] = _mode;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text(_modeOptions[1]),
                      value: _modeOptions[1],
                      groupValue: _mode,
                      onChanged: (String? value) {
                        setState(() {
                          _mode = value!;
                          formValues["Mode of Transaction"] = _mode;
                        });
                      },
                    ),
                  ],
                ),
              ),
              if (_mode == "Pick-up")
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "Enter address(es):",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                ),
              if (_mode == "Pick-up") _buildAddressFields(),
              if (_mode == "Pick-up")
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "Enter a Contact Number:",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                ),
              if (_mode == "Pick-up")
                Padding(
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
                    onChanged: (String value) {
                      formValues["Contact Number"] = value;
                    },
                  ),
                ),
              Visibility(visible: _showUploadButton, child: Column()),
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter weight';
                          }
                          return null;
                        },
                        onChanged: (String value) {
                          formValues["Weight"] = value;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Weight",
                          labelText: "Weight",
                        ),
                      ),
                    ),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: formValues["WeightUnit"] ?? "kg",
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            formValues["WeightUnit"] = value!;
                          });
                        },
                        items: [
                          DropdownMenuItem(
                            child: Text("kg"),
                            value: "kg",
                          ),
                          DropdownMenuItem(
                            child: Text("lbs"),
                            value: "lbs",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Select Donation Date and Time:",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: "Date",
                    hintText: "Select Date",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    labelText: "Time",
                    hintText: "Select Time",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: () {
                        _selectTime(context);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a time';
                    }
                    return null;
                  },
                ),
              ),
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
                          formValues["Photo"] = imageName;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_showUploadButton) {}
                      List<String> categories =
                          List<String>.from(formValues["Donation"]);
                      List<String> addresses =
                          List<String>.from(formValues["Address"]);

                      double weight = double.parse(formValues["Weight"]);
                      if (formValues["WeightUnit"] == "lbs") {
                        weight = weight * 0.453592;
                      }

                      DonateData donation = DonateData(
                        orgId: widget.organization.id ?? '',
                        donorId: currentDonorId,
                        //TODO: add drive id if available
                        driveId: '',
                        categories: categories,
                        mode: formValues["Mode of Transaction"],
                        addresses: addresses,
                        contactNum: formValues["Contact Number"],
                        weight: weight.toStringAsFixed(2),
                        photo: formValues["Photo"],
                        date: formValues["Date"],
                        time: formValues["Time"],
                      );

                      await context
                          .read<DonateDataProvider>()
                          .addDonation(donation);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Form validated! Donation submitted.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      print("Not Validated");
                    }
                  },
                  child: const Text("Submit"),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressFields() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          ...addressControllers.map((controller) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter Address",
                  labelText: "Enter Address",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
                onChanged: (String value) {
                  setState(() {
                    formValues["Address"] = addressControllers
                        .map((controller) => controller.text)
                        .toList();
                  });
                },
              ),
            );
          }).toList(),
          ElevatedButton(
            onPressed: () {
              setState(() {
                TextEditingController newController = TextEditingController();
                addressControllers.add(newController);
              });
            },
            child: const Text("Add Address"),
          ),
        ],
      ),
    );
  }
}
