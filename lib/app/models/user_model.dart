class UserModel {
  String? uid;
  String? name;
  String? email;
  String? username;
  String? status;
  int? state;
  String? profilePhoto;
  String? updateTime;
  String? creationTime;
  String? lastSignInTime;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.username,
    this.status,
    this.state,
    this.profilePhoto,
    this.updateTime,
    this.creationTime,
    this.lastSignInTime
  });

  UserModel.fromJson(Map<String,dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    username = json['username'];
    status = json['status'];
    profilePhoto = json['profilePhoto'];
    updateTime = json['updateTime'];
    creationTime = json['creationTime'];
    lastSignInTime = json['lastSignInTime'];
  }

  Map<String, dynamic>? toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['email'] = email;
    data['username'] = username;
    data['status'] = status;
    data['profilePhoto'] = profilePhoto;
    data['updateTime'] = updateTime;
    data['creationTime'] = creationTime;
    data['lastSignInTime'] = lastSignInTime;
  }


  }
