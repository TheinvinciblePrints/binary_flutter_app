class Contacts {
  int id;
  String first_name;
  String last_name;
  String dob;
  String mobile_nmuber;
  String title;
  String company;

  bool isFavourite = false;

  //When using curly braces { } we note dart that
  //the parameters are optional
  Contacts(
      {this.id,
      this.first_name,
      this.last_name,
      this.dob,
      this.mobile_nmuber,
      this.title,
      this.company,
      this.isFavourite = false});

  factory Contacts.fromDatabaseJson(Map<String, dynamic> data) => Contacts(
        //Factory method will be used to convert JSON objects that
        //are coming from querying the database and converting
        //it into a Contacts object

        id: data['id'],
        first_name: data['first_name'],
        last_name: data['last_name'],
        dob: data['dob'],
        mobile_nmuber: data['mobile_nmuber'],
        title: data['title'],
        company: data['company'],

        //Since sqlite doesn't have boolean type for true/false,
        //we will use 0 to denote that it is false
        //and 1 for true
        isFavourite: data['is_favourite'] == 0 ? false : true,
      );

  Map<String, dynamic> toDatabaseJson() => {
        //A method will be used to convert Contacts objects that
        //are to be stored into the database in a form of JSON

        "id": this.id,
        "first_name": this.first_name,
        "last_name": this.last_name,
        "dob": this.dob,
        "mobile_nmuber": this.mobile_nmuber,
        "title": this.title,
        "company": this.company,
        "is_favourite": this.isFavourite == false ? 0 : 1,
      };
}
