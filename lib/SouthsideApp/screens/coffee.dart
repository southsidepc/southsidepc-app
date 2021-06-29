import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";
import 'package:intl/intl.dart';

class Coffee extends StatefulWidget {
  Coffee({Key? key}) : super(key: key);

  @override
  CoffeeState createState() => CoffeeState();
}

class CoffeeState extends State<Coffee> {
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  TextEditingController _nameController = new TextEditingController();

  final _coffees = <String>[
    'Cappuccino',
    'Chai Latte',
    'Flat White',
    'Hot Chocolate',
    'Long Black',
    'Mocha',
    'Tea'
  ].map<DropdownMenuItem<String>>((value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
  String _coffee = 'Cappuccino';

  final _milks = <String>['Full Cream', 'Lite', 'Zymil']
      .map<DropdownMenuItem<String>>((value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
  String _milk = 'Full Cream';

  final _services =
      <String>['8:30 am', '10 am'].map<DropdownMenuItem<String>>((value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
  String _service = '8:30 am';

  DateTime _serviceDate = DateTime.now();

  TextEditingController _serviceDateController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    _serviceDate = _serviceDate.add(Duration(days: 7 - _serviceDate.weekday));

    _serviceDateController.text =
        new DateFormat('d MMM yyyy').format(_serviceDate);

    if (_serviceDate.hour >= 10) {
      _service = '10 am';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Full Name"),
                textCapitalization: TextCapitalization.words,
                readOnly: _loading,
              ),
              SizedBox(
                height: 32,
                child: Container(),
              ),
              DropdownButtonFormField(
                validator: (value) {
                  if (_service == null) {
                    return 'Please select a service';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Service Time'),
                value: _service,
                items: _services,
                onChanged: _loading
                    ? null
                    : (String? newValue) {
                        if (newValue == null) return;
                        setState(() {
                          _service = newValue;
                        });
                      },
              ),
              SizedBox(
                height: 32,
                child: Container(),
              ),
              TextFormField(
                validator: (value) {
                  if (_serviceDate == null) {
                    return 'Please select a Sunday';
                  }
                  return null;
                },
                enableInteractiveSelection: false,
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());

                  DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: _serviceDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2500));

                  if (newDate == null) {
                    return;
                  }

                  setState(() {
                    _serviceDate = newDate;
                  });

                  _serviceDateController.text =
                      new DateFormat('d MMM yyyy').format(newDate);
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Service Date',
                    suffixIcon: Icon(CommunityMaterialIcons.calendar_outline)),
                controller: _serviceDateController,
                readOnly: _loading,
              ),
              SizedBox(
                height: 32,
                child: Container(),
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Coffee Type'),
                value: _coffee,
                items: _coffees,
                onChanged: _loading
                    ? null
                    : (String? newValue) {
                        if (newValue == null) return;
                        setState(() {
                          _coffee = newValue;
                        });
                      },
                validator: (value) {
                  if (_coffee == null) {
                    return 'Please select a coffee type';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 32,
                child: Container(),
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Milk Type'),
                value: _milk,
                items: _milks,
                onChanged: _loading
                    ? null
                    : (String? newValue) {
                        if (newValue == null) return;
                        setState(() {
                          _milk = newValue;
                        });
                      },
                validator: (value) {
                  if (_milk == null) {
                    return 'Please select a milk type';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 32,
                child: Container(),
              ),
              RaisedButton(
                  elevation: 0,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  onPressed: _loading
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() {
                              _loading = true;
                            });

                            http.Response response = await http.post(
                                Uri.http('www.iamacoffeeaddict.com',
                                    'ssc-app/receive.php'),
                                body: {
                                  'secretWord': '44fdcv8jf3',
                                  'name': _nameController.text,
                                  'service': DateFormat('yyyy-MM-dd')
                                          .format(_serviceDate) +
                                      ' - ' +
                                      _service,
                                  'coffee': _coffee,
                                  'milk': _milk,
                                  'done': 'No'
                                });

                            setState(() {
                              _loading = false;
                            });

                            print(response);

                            if (response.statusCode == 200) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content:
                                      Text('Coffee Ordered Successfully.')));
                            } else {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Something went wrong, please try again.')));
                            }
                          }
                        },
                  child: _loading
                      ? Padding(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                          padding: EdgeInsets.all(8),
                        )
                      : Text('Submit Order'))
            ],
          ),
        ),
      ),
    );
  }
}
