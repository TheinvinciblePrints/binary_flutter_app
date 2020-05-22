import 'package:binaryflutterapp/src/bloc/offline/contacts_bloc.dart';
import 'package:binaryflutterapp/src/config/assets.dart';
import 'package:binaryflutterapp/src/config/colors.dart';
import 'package:binaryflutterapp/src/models/oflline/contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:masked_text/masked_text.dart';

class AddContactScreen extends StatefulWidget {
  static String tag = 'add-page';

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cFirstName = TextEditingController();
  final _cLastName = TextEditingController();
  final _cTitle = TextEditingController();
  final _cDOB = TextEditingController();
  final _cPhoneNumber = TextEditingController();
  final _cCompany = TextEditingController();

  final ContactsBloc _contactsBloc = ContactsBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextFormField inputName = TextFormField(
      controller: _cFirstName,
      autofocus: false,
      keyboardType: TextInputType.text,
      inputFormatters: [
        LengthLimitingTextInputFormatter(45),
      ],
      decoration: InputDecoration(
        labelText: 'First Name',
        icon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Required';
        }
        return null;
      },
    );

    TextFormField inputLastName = TextFormField(
        controller: _cLastName,
        keyboardType: TextInputType.text,
        inputFormatters: [
          LengthLimitingTextInputFormatter(25),
        ],
        decoration: InputDecoration(
          labelText: 'Last Name',
          icon: Icon(Icons.person),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Required';
          }
          return null;
        });

    TextFormField inputTitle = TextFormField(
        controller: _cTitle,
        keyboardType: TextInputType.text,
        inputFormatters: [
          LengthLimitingTextInputFormatter(25),
        ],
        decoration: InputDecoration(
          labelText: 'Title',
          icon: Icon(Icons.title),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Required';
          }
          return null;
        });

    TextFormField inputCompany = TextFormField(
        controller: _cCompany,
        inputFormatters: [
          LengthLimitingTextInputFormatter(45),
        ],
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Company',
          icon: Icon(Icons.work),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Required';
          }
          return null;
        });

    MaskedTextField inputPhoneNumber = new MaskedTextField(
      maskedTextFieldController: _cPhoneNumber,
      mask: "(xxx) xxxxx-xxxx",
      maxLength: 16,
      keyboardType: TextInputType.phone,
      inputDecoration: new InputDecoration(
        labelText: "Mobile",
        icon: Icon(Icons.phone),
      ),
    );

    MaskedTextField inputDOB = new MaskedTextField(
      maskedTextFieldController: _cDOB,
      mask: "xx/xx/xxxx",
      maxLength: 10,
      keyboardType: TextInputType.phone,
      inputDecoration: new InputDecoration(
        labelText: 'Date of Birth',
        hintText: 'dd/mm/yyyy',
        icon: Icon(Icons.date_range),
      ),
    );

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

    Widget bodyUI(BuildContext context) {
      return ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          SizedBox(height: 10),
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
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                inputName,
                inputLastName,
                inputTitle,
                inputPhoneNumber,
                inputCompany,
                inputDOB,
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          _bottomContent(context),
        ],
      );
    }

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
      body: Builder(builder: (_context) => bodyUI(_context)),
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
            final newContact = Contacts(
                first_name: _cFirstName.value.text.trim(),
                last_name: _cLastName.value.text.trim(),
                dob: _cDOB.value.text.trim(),
                mobile: _cPhoneNumber.value.text.trim(),
                title: _cTitle.value.text.trim(),
                company: _cCompany.value.text.trim());
            if (newContact.first_name.isNotEmpty &&
                newContact.last_name.isNotEmpty &&
                newContact.dob.isNotEmpty &&
                newContact.mobile.isNotEmpty &&
                newContact.title.isNotEmpty &&
                newContact.company.isNotEmpty) {
              _contactsBloc.addContact(newContact);

              await _contactsBloc.refreshContacts();

              Navigator.pop(context);
            } else {
              final snackBar = SnackBar(
                content: Text('Please fill in all details'),
              );

              Scaffold.of(context).showSnackBar(snackBar);
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
}
