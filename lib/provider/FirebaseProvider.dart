import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseProvider with ChangeNotifier {
  final FirebaseAuth fAuth = FirebaseAuth.instance; // Firebase인증 플러그인 인스턴스
  User _user; // Firebase에 로그인된 사용자
  String _lastFirebaseResponse = ""; // Firebase로부터 받은 최신메시지 (에러처리용)

  FirebaseProvider() {
    _prepareUser();
  }

  User getUser() {
    return _user;
  }

  void setUser(User value) {
    _user = value;
    notifyListeners();
  }

  // 최근 Firebase에 로그인한 사용자 정보 획득
  _prepareUser() {
    // 수정함..
    setUser(fAuth.currentUser);
  }

  // 이메일/비밀번호로 Firebase에 회원가입
  Future<bool> signUpWithEmail(String email, String password) async {
    try {

    } on Exception catch (e) {

    }
  }
}
