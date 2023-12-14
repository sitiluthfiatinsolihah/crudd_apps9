class User {
  int? id;
  String? name;
  String? address;
  String? contact;
  String? description;
  userMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id ?? null;
    mapping['name'] = name!;
    mapping['address'] = address!;
    mapping['contact'] = contact!;
    mapping['description'] = description!;
    return mapping;
  }
}
