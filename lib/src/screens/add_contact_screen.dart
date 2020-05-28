import 'dart:io';

import 'package:binaryflutterapp/src/bloc/contacts_bloc.dart';
import 'package:binaryflutterapp/src/bloc/create_user/create_user_bloc.dart';
import 'package:binaryflutterapp/src/bloc/create_user/gender_bloc.dart';
import 'package:binaryflutterapp/src/config/assets.dart';
import 'package:binaryflutterapp/src/config/colors.dart';
import 'package:binaryflutterapp/src/models/contacts_model.dart';
import 'package:binaryflutterapp/src/models/data_model.dart';
import 'package:binaryflutterapp/src/screens/contacts_screen.dart';
import 'package:binaryflutterapp/src/utils/uuid.dart';
import 'package:binaryflutterapp/src/widgets/form_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

typedef OnSaveCallback = Function(Contacts contacts);

class AddContactScreen extends StatefulWidget {
  final OnSaveCallback onSave;

  AddContactScreen({@required this.onSave});

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  ContactsBloc _contactsBloc;
  GenderBloc _genderBloc;
  CreateBloc _createBloc;

  final _formKey = GlobalKey<FormState>();
  final _cDOB = TextEditingController();

  String _UUID;
  String _first_name;
  String _last_name;
  String _gender;
  String _email;
  String _dob;
  String _mobile;
  String _photoName;
  String _title;
  String _company;
  bool _isFavourite = false;

  int current_year;

  @override
  void initState() {
    _contactsBloc = ContactsBloc();
    _genderBloc = GenderBloc();
    _createBloc = BlocProvider.of<CreateBloc>(context);
    current_year = int.parse(DateFormat('yyyy').format(DateTime.now()));
    super.initState();
  }

  @override
  void dispose() {
    _contactsBloc.dispose();
    _genderBloc.dispose();
    _createBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Create new contact"),
      ),
      body: bodyUI(context),
    );
  }

  Widget bodyUI(BuildContext context) {
    return BlocBuilder<CreateBloc, CreateState>(
        bloc: _createBloc,
        builder: (_context, state) {
          if (state is SuccessState) {
            return saveToDB(state.data);
          } else if (state is InitialState) {
            return ListView(
              padding: EdgeInsets.all(20),
              children: <Widget>[
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Add Contact',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _pictureContent(),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _buildFirstName(),
                      _buildLastName(),
                      _buildGender(),
                      _buildEmail(),
                      _buildDOB(),
                      _buildMobileNumber(),
                      _buildCompany(),
                      _buildTitle(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                _bottomContent(context),
              ],
            );
          } else if (state is SubmitState) {
            return Center(
              child: FormLoader(),
            );
          } else if (state is FailureState) {
            return Center(
              child: Text("Failed to insert data :" + state.message),
            );
          } else {
            return Center(
              child: Text("Failed to insert data : Unknown error"),
            );
          }
        });
  }

  Widget _buildFirstName() {
    return TextFormField(
      initialValue: _first_name,
      decoration: InputDecoration(
        labelText: 'First Name',
        icon: Icon(Icons.person),
      ),
      maxLength: 45,
      autofocus: false,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 18),
      validator: (String value) {
        if (value.isEmpty) {
          return 'First Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _first_name = value;
      },
    );
  }

  Widget _buildLastName() {
    return TextFormField(
      initialValue: _last_name,
      decoration: InputDecoration(
        labelText: 'Last Name',
        icon: Icon(Icons.person),
      ),
      maxLength: 45,
      autofocus: false,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 18),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Last Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _last_name = value;
      },
    );
  }

  Widget _buildGender() {
    return StreamBuilder(
        stream: _genderBloc.getOption,
        builder: (context, snapshot) {
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio(
                  activeColor: Hexcolor(AppColors.primaryColor),
                  value: 0,
                  groupValue: _genderBloc.genderProvider.currentOption,
                  onChanged: (newValue) => _genderBloc.updateOption(newValue),
                ),
                Text(
                  'Male',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Radio(
                  activeColor: Hexcolor(AppColors.primaryColor),
                  value: 1,
                  groupValue: _genderBloc.genderProvider.currentOption,
                  onChanged: (newValue) => _genderBloc.updateOption(newValue),
                ),
                Text(
                  'Female',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildEmail() {
    return TextFormField(
      initialValue: _email,
      decoration: InputDecoration(
        labelText: 'Email',
        icon: Icon(Icons.email),
      ),
      maxLength: 45,
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 18),
      validator: validateEmail,
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildDOB() {
    return InkWell(
      onTap: () {
        _selectDate(); // Call Function that has showDatePicker()
      },
      child: IgnorePointer(
        child: TextFormField(
          controller: _cDOB,
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            icon: Icon(Icons.calendar_today),
          ),
          maxLength: 10,
          // validator: validateDob,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Date of birth is Required';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildMobileNumber() {
    return TextFormField(
      initialValue: _mobile,
      decoration: InputDecoration(
        labelText: 'Mobile Number',
        icon: Icon(Icons.phone),
      ),
      maxLength: 45,
      autofocus: false,
      keyboardType: TextInputType.phone,
      style: TextStyle(fontSize: 18),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Mobile number is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _mobile = value;
      },
    );
  }

  Widget _buildTitle() {
    return TextFormField(
      initialValue: _title,
      decoration: InputDecoration(
        labelText: 'Title',
        icon: Icon(Icons.title),
      ),
      maxLength: 45,
      autofocus: false,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 18),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Title is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _title = value;
      },
    );
  }

  Widget _buildCompany() {
    return TextFormField(
      initialValue: _company,
      decoration: InputDecoration(
        labelText: 'Company',
        icon: Icon(Icons.work),
      ),
      maxLength: 45,
      autofocus: false,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 18),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Company name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _company = value;
      },
    );
  }

  Widget _pictureContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 130.0,
          height: 130.0,
          child: CircleAvatar(
            backgroundColor: Hexcolor(AppColors.primaryColor),
            child: CircleAvatar(
              radius: 61,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(
                Assets.iconProfile,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomContent(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 230,
        height: 45,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(color: Hexcolor(AppColors.accentColor))),
          onPressed: () async {
            if (!_formKey.currentState.validate()) {
              return;
            }

            _gender = _genderBloc.getSelectedOption();

            if (_gender.isEmpty) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Please choose gender to continue'),
              ));
              return;
            }

            _formKey.currentState.save();

            try {
              final result = await InternetAddress.lookup('google.com');
              if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                print('internetState: connected');

                Data contacts = Data(
                    id: Uuid().generateV4(),
                    firstName: _first_name.trim(),
                    lastName: _last_name.trim(),
                    email: _email.trim(),
                    gender: _gender.trim(),
                    dateOfBirth: _dob.trim(),
                    phoneNo: _mobile.trim());

                _createBloc.add(SubmitInput(data: contacts));
              }
            } on SocketException catch (_) {
              print('internetState: not connected');

              Contacts contacts = Contacts(
                first_name: _first_name.trim(),
                last_name: _last_name.trim(),
                gender: _gender.trim(),
                dob: _dob.trim(),
                mobile: _mobile.trim(),
                email: _email.trim(),
                title: _title.trim(),
                company: _company.trim(),
                isFavourite: _isFavourite,
              );

              _contactsBloc.addContacts(contacts);
              widget.onSave(contacts);
              Navigator.pop(context);
            }
          },
          child: const Text('Save', style: TextStyle(fontSize: 18)),
          color: Hexcolor(AppColors.accentColor),
          textColor: Colors.white,
          elevation: 5,
        ),
      ),
    );
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Hexcolor(AppColors.primaryColor),
              accentColor: Hexcolor(AppColors.primaryColor),
              colorScheme:
                  ColorScheme.light(primary: Hexcolor(AppColors.primaryColor)),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child,
          );
        },
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1970),
        lastDate: new DateTime(current_year +
            1)); // adding +1 to ensure the datepicker works even after current year
    if (picked != null)
      setState(() {
        _dob = picked.millisecondsSinceEpoch.toString();
        print('DOB: ${_dob}');
        _cDOB.text = DateFormat("dd-MM-yyyy").format(picked);
      });
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter email';
    } else if (!regex.hasMatch(value)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  Widget saveToDB(Data data) {
    Contacts contacts = Contacts(
        UUID: data.id,
        first_name: data.firstName,
        last_name: data.lastName,
        gender: data.gender,
        dob: data.dateOfBirth,
        mobile: data.phoneNo,
        email: data.email,
        title: _title.trim(),
        company: _company.trim(),
        isFavourite: _isFavourite);

    _contactsBloc.addContacts(contacts);
    widget.onSave(contacts);
    Navigator.pop(context);

    return ContactScreen();
  }
}
