import 'dart:async';
import 'dart:convert';
import 'package:emrals/models/report_comment.dart';
import 'package:emrals/models/transaction.dart';
import 'package:emrals/utils/network_util.dart';
import 'package:emrals/models/user.dart';
import 'package:emrals/models/user_profile.dart';
import 'package:emrals/styles.dart';

class RestDatasource {
  final NetworkUtil _netUtil = NetworkUtil();
  static final loginURL = apiUrl + "/login/";
  static final signupURL = apiUrl + "/rest-auth/registration/";
  static final tipURL = apiUrl + "/tip/";
  static final reportURL = apiUrl + "/alerts/";
  static final inviteURL = apiUrl + "/invite/";
  static final usersURL = apiUrl + "/users/";
  static final sendURL = apiUrl + "/send/";
  static final updateURL = apiUrl + "/me/";

  Future<User> login(String username, String password) {
    return _netUtil.post(loginURL, body: {
      "username": username,
      "password": password,
    }).then((dynamic res) {
      if (res["error"] != null) {
        throw Exception(res["error"]);
      }
      return User.map(res);
    });
  }

  Future<User> signup(String username, String password, String email) {
    return _netUtil.post(signupURL, body: {
      "username": username,
      "email": email,
      "password1": password,
      "password2": password
    }).then((dynamic res) {
      if (res["error"] != null) {
        throw Exception(res["error"]);
      }
      if (res["email"] != null) {
        throw Exception(res["email"]);
      }
      if (res["username"] != null) {
        if (res["id"] == null) {
          throw Exception(res["username"]);
        }
      }
      if (res["password1"] != null) {
        throw Exception(res["password1"]);
      }

      return User.map(res);
    });
  }

  Future<dynamic> sendEmrals(
      double amount, String address, String sendto, String token) {
    Map<String, dynamic> payload = {
      "amount": amount,
      "address": address,
      "username": sendto,
    };

    Map<String, String> headers = {
      "Authorization": "token $token",
      "Content-type": "application/json"
    };

    return _netUtil
        .post(sendURL, headers: headers, body: json.encoder.convert(payload))
        .then((dynamic res) {
      return res;
    });
  }

  Future<dynamic> updateEmralsBalance(String token) {
    Map<String, String> headers = {
      "Authorization": "token $token",
      "Content-type": "application/json"
    };

    return _netUtil.get(updateURL, headers).then((dynamic res) {
      return res;
    });
  }

  Future<dynamic> tipReport(int amount, int reportID, String token) {
    Map<String, int> payload = {
      "amount": amount,
      "report_id": reportID,
    };

    Map<String, String> headers = {
      "Authorization": "token $token",
      "Content-type": "application/json"
    };

    return _netUtil
        .post(tipURL, headers: headers, body: json.encoder.convert(payload))
        .then((dynamic res) {
      if (res["error"] != null) {
        throw Exception(res["error"]);
      }
      return res;
    });
  }

  Future<dynamic> tipCleanup(int amount, int reportID, String token) {
    Map<String, int> payload = {
      "amount": amount,
      "cleanup_id": reportID,
    };

    Map<String, String> headers = {
      "Authorization": "token $token",
      "Content-type": "application/json"
    };

    return _netUtil
        .post(tipURL, headers: headers, body: json.encoder.convert(payload))
        .then((dynamic res) {
      if (res["error"] != null) {
        throw Exception(res["error"]);
      }
      return res;
    });
  }

  Future<dynamic> deleteReport(int reportID, String token) {
    Map<String, String> headers = {
      "Authorization": "token $token",
      "Content-type": "application/json"
    };

    return _netUtil
        .delete(reportURL + reportID.toString() + "/", headers: headers)
        .then((dynamic res) {
      return res;
    });
  }

  Future<bool> inviteUser(String email, String token) async {
    Map<String, String> payload = {
      "email": email,
    };

    Map<String, String> headers = {
      "Authorization": "token $token",
      "Content-type": "application/json"
    };

    return _netUtil
        .post(inviteURL, headers: headers, body: json.encoder.convert(payload))
        .then((b) => true, onError: (e) => false);
  }

  Future<UserProfile> getUser(int id) async {
    return _netUtil.get(usersURL + id.toString() + "/").then((dynamic res) {
      if (res["error"] != null) {
        throw Exception(res["error"]);
      }
      return UserProfile.map(res);
    });
  }

  Future<dynamic> getLeaderboardReports() async {
    return _netUtil.get(apiUrl + "/leaderboard/reports");
  }

  Future<dynamic> getEmralsprice(int emralsAmount, String token) async {
    Map<String, String> headers = {
      "Authorization": "token $token",
      "Content-type": "application/json"
    };
    return _netUtil.get(
        apiUrl + "/buy/?emrals_amount=" + emralsAmount.toString(),
        headers = headers);
  }

  Future<dynamic> getLeaderboardCleanups() async {
    return _netUtil.get(apiUrl + "/leaderboard/cleanups");
  }

  Future<dynamic> getReportComments(int reportid) async {
    Map<String, dynamic> json =
        await _netUtil.get(apiUrl + "/alerts/$reportid/");
    return (json["comments"] as List<dynamic>)
        .map((m) => ReportComment.fromJSON(m))
        .toList();
  }

  Future<dynamic> flagComment(int commentid, String token) async {
    Map<String, String> payload = {
      "id": commentid.toString(),
    };

    Map<String, String> headers = {
      "Authorization": "token $token",
      "Content-type": "application/json"
    };

    return _netUtil.post(apiUrl + "/flag_comment/",
        headers: headers, body: json.encoder.convert(payload));
  }

  Future<dynamic> addCommentToReport(int reportid, String comment, User user) {
    Map<String, dynamic> payload = {
      "user": user.id,
      "user_profile_image_url": user.picture,
      "site": 1,
      "object_pk": "$reportid",
      "comment": comment,
      "submit_date": DateTime.now().toIso8601String(),
    };
    Map<String, String> headers = {
      "Authorization": "token ${user.token}",
      "Content-type": "application/json"
    };
    return _netUtil
        .post(apiUrl + "/comments/",
            headers: headers, body: json.encoder.convert(payload))
        .then((d) {
      return ReportComment.fromJSON(d);
    });
  }

  Future<dynamic> deleteComment(int commentID, String token) {
    Map<String, String> payload = {
      "id": commentID.toString(),
    };

    Map<String, String> headers = {
      "Authorization": "token $token",
      "Content-type": "application/json"
    };

    return _netUtil.post(apiUrl + "/delete_comment/",
        headers: headers, body: json.encoder.convert(payload));
  }

  Future<dynamic> registerFCM(
    String token,
    String registationID,
    String deviceID,
    String deviceType,
  ) {
    Map<String, dynamic> payload = {
      "registration_id": registationID,
      "device_id": deviceID,
      "type": deviceType,
    };

    Map<String, String> headers = {
      "Authorization": "token $token",
      "Content-type": "application/json"
    };
    return _netUtil.post(apiUrl + "/devices/",
        headers: headers, body: json.encoder.convert(payload));
  }

  Future<List<Transaction>> getTransactions(String token) async {
    Map<String, String> headers = {
      "Authorization": "token $token",
      "Content-type": "application/json"
    };
    List<Transaction> transactions = [];
    List<Map<String, dynamic>> response =
        List.from(await _netUtil.get(apiUrl + "/transactions/", headers));
    response.forEach((m) {
      transactions.add(Transaction.fromJSON(m));
    });
    print(transactions.length);
    return transactions;
  }
}
