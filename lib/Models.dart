class Application {
  final int id;
  final String? applicationName;
  final String appKey;
  final int companyId;

  Application({
    required this.id,
    this.applicationName,
    required this.appKey,
    required this.companyId,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'],
      applicationName: json['applicationName'],
      appKey: json['appKey'],
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'applicationName': applicationName,
      'appKey': appKey,
      'companyId': companyId,
    };
  }
}

class Company {
  final int id;
  final String companyName;

  Company({
    required this.id,
    required this.companyName,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      companyName: json['companyName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
    };
  }
}

class Permission {
  final int id;
  final String permissionName;
  final String? description;

  Permission({
    required this.id,
    required this.permissionName,
    this.description,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'],
      permissionName: json['permissionName'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'permissionName': permissionName,
      'description': description,
    };
  }
}

class RolePermission {
  final int id;
  final int roleId;
  final int permissionId;

  RolePermission({
    required this.id,
    required this.roleId,
    required this.permissionId,
  });

  factory RolePermission.fromJson(Map<String, dynamic> json) {
    return RolePermission(
      id: json['id'],
      roleId: json['roleId'],
      permissionId: json['permissionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roleId': roleId,
      'permissionId': permissionId,
    };
  }
}

class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      createdAt: json['createdAt'] = DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] = DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class UserApplication {
  final int id;
  final int userId;
  final int applicationId;
  final int roleId;
  final String password;

  UserApplication({
    required this.id,
    required this.userId,
    required this.applicationId,
    required this.roleId,
    required this.password,
  });

  factory UserApplication.fromJson(Map<String, dynamic> json) {
    return UserApplication(
      id: json['id'],
      userId: json['userId'],
      applicationId: json['applicationId'],
      roleId: json['roleId'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'applicationId': applicationId,
      'roleId': roleId,
      'password': password,
    };
  }
}

class UserRole {
  final int id;
  final String roleName;
  final int applicationId;

  UserRole({
    required this.id,
    required this.roleName,
    required this.applicationId,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      id: json['id'],
      roleName: json['roleName'],
      applicationId: json['applicationId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roleName': roleName,
      'applicationId': applicationId,
    };
  }
}
