import 'package:flutter/material.dart';
import "package:image_picker/image_picker.dart";
import 'package:donation_app/models/donate_data.dart';
import 'package:donation_app/providers/donate_provider.dart';
import 'package:provider/provider.dart';
import 'pick_image.dart';
import 'package:qr_flutter/qr_flutter.dart';


class DonorDonatePage extends StatefulWidget {
  const DonorDonatePage({super.key});

  @override
  _DonorDonatePageState createState() => _DonorDonatePageState();
}

class _DonorDonatePageState extends State<DonorDonatePage> {
  // Define form fields and values
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formValues = {
    'Donation': [],
    'Mode of Transaction': "Pick-up",
    'Address': [],
    'Contact Number': "",
    'Weight': "",
    'Upload Photo': false,
    'Donation': [],
  };

  // Define other variables
  List<String> _modeOptions = [
    "Pick-up",
    "Drop-off",
  ];

  List<String> _donateOptions = [
    'Food',
    'Clothes',
    'Cash',
    'Necessities',
    'Others'
  ];

  

  String _mode = "Pick-up";
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  List<TextEditingController> otherAddressesControllers = [];
  List<TextEditingController> addressControllers = [];
  List<Widget> addressFields = [];
  bool _showUploadButton = false;
  bool _showQRCode = false;

  @override
  void initState() {
    super.initState();
    _textFieldController.addListener(() {
      print("Latest Value: ${_textFieldController.text}");
    });
    _addressController.addListener(() {
      if (_addressController.text.isNotEmpty) {
        setState(() {
          formValues["Address"] = _addressController.text;
        });
      }
    });

    // Initialize formValues["Address"] as an empty list
    formValues["Address"] = [];
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: screenHeight * 0.2,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Donation App",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text("Fill up the following to donate:",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic))
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text("Items to Donate")
              ],
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
                    Text("Modes of Transporation:",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic))
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text("Which mode do you prefer?")
                ],
              ),
              FormField(
                builder: (value) => Column(
                  children: <Widget>[
                    RadioListTile<String>(
                      title: Text(_modeOptions[0]),
                      value: _modeOptions[0],
                      groupValue: _mode!,
                      onChanged: (String? value) {
                        setState(() {
                          _mode = value!;
                          formValues["Mode of Transaction"] = _mode;
                          _showQRCode = false;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text(_modeOptions[1]),
                      value: _modeOptions[1],
                      groupValue: _mode!,
                      onChanged: (String? value) {
                        setState(() {
                          _mode = value!;
                          formValues["Mode of Transaction"] = _mode;
                          _showQRCode = true;
                        });
                      },
                    ),
                  ],
                ),
              ),

              _mode == "Pick-up"
                 ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text("Enter address(es):",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic))
                        ],
                      ),
                    )
                  : Container(),

              _mode == "Pick-up"
                 ? _buildAddressFields()
                  : Container(),

              _mode == "Pick-up"
                ? Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text("Enter a Contact Number:",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic))
                  ],
                ),
              )
              : Container(),

              _mode == "Pick-up"
              ? Padding(
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
              )
              : Container(),

              _mode == "Drop-off"
                ? Visibility(
                    visible: _showQRCode,
                    child: QrImageView(
                      data: 'This is a simple QR code',
                      version: QrVersions.auto,
                      size: 150,
                      gapless: false,
                      ),
                )
                : Container(),

                Visibility(
                  visible: _showUploadButton,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showQRCode = true;
                            });
                          },
                        child: Text('Show QR Code'),
                        ),
                      ],
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text("Enter weight of items:",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic))
    ],
  ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a weight';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Weight",
                        labelText: "Weight",
                      ),
                      onChanged: (String value) {
                        formValues["Weight"] = value;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: formValues["WeightUnit"] ?? "kg",
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          formValues["WeightUnit"] = value;
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text("Pick a date and time:",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic
                              )
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded (
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your date';
                                        }
                                        return null;
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Date",
                                      labelText: "Date",
                                    ),
                                    controller: _dateController,
                                    onChanged: (String value) {
                                      formValues["Date"] = value;
                                      },
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100),
                                        );
                                        if (pickedDate != null) {
                                          String formattedDate = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                                          setState(() {
                                            _dateController.text = formattedDate; // Set the formatted date here
                                            formValues["Date"] = formattedDate;
                                          }
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your time';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Time",
                                    labelText: "Time",
                                  ),
                                  controller: _timeController,
                                  onChanged: (String value) {
                                    formValues["Time"] = value;
                                  },
                                  onTap: () async {
                                    TimeOfDay? pickedTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    if (pickedTime != null) {
                                      formValues["Time"] = pickedTime.format(context);
                                      setState(() {
                                        _timeController.text = pickedTime.format(context);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                        PickImage(), // Add the PickImage widget here
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            final form = _formKey.currentState;
                            if (form!.validate()) {
                              DonateData t = new DonateData(data: formValues);
                                context
                              .read<DonateDatacart>()
                              .addData(t);
                              Navigator.pop(context);

                              form.save();
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                      content: Text("Summary:\n" +
                                        "Donation: ${formValues['Donation'].join(", ")}\n" +
                                        "Mode of Transaction: ${formValues["Mode of Transaction"]}\n" +
                                        "Address: ${formValues["Address"].join(", ")}\n" +
                                        "Contact Number: ${formValues["Contact Number"]}\n" +
                                        "Weight: ${formValues["Weight"]} ${formValues["WeightUnit"]}\n" +
                                        "Date: ${formValues["Date"]}\n" +
                                        "Time: ${formValues["Time"]}"),
                                          ));
                            } else {
                              print("Form is not valid.");
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      )
                    ],
                  )
                  ],
                ),
              ),
            ),
          );
        }

Widget _buildAddressFields() {
  return Column(
    children: [
      ...addressFields.asMap().entries.map((entry) {
        int index = entry.key;
        TextEditingController controller;
        if (index < addressControllers.length) {
          controller = addressControllers[index];
        } else {
          controller = TextEditingController();
          addressControllers.add(controller);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Address",
                    labelText: "Address",
                  ),
                  onChanged: (String value) {
                    setState(() {
                      formValues["Address"][index] = value;
                    });
                  },
                ),
              ),
              IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  int index = addressFields.length - 1;
                                  addressFields.removeAt(index);
                                });
                              },
                            ),
            ],
          ),
        );
      }).toList(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    TextEditingController newController = TextEditingController();
                    addressControllers.add(newController);
                    addressFields.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: newController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Address",
                                  labelText: "Address",
                                ),
                                onChanged: (String value) {
                                  setState(() {
                                    int currentIndex = addressFields.length;
                                    formValues["Address"].add(value);
                                    addressControllers[currentIndex] = newController;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
                child: Text('Add Address'),
              ),
            ),
          ],
        ),
      ),
    ],
    
  );
}

}

