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
      UserCredential userCredential = await fAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        // 인증 메일 발송
        userCredential.user.sendEmailVerification();
        // 새로운 계정생성이 성공하였으므로 기존계정이 있는 경우 로그아웃
        signOut();
        return true;
      }
    } on Exception catch (e) {
      List<String> result = e.toString().split(", ");
      setLastFBMessage(result[1]);
      return false;
    }
  }

  Future<bool> signInWidthEmail(String email, String password) async {
    try {
      var result = await fAuth.signInWithEmailAndPassword(email: email, password: password);
      if (result != null) {
        setUser(result.user);
        return true;
      } else {
        return false;
      }

    } on Exception catch (e) {
      List<String> result = e.toString().split(", ");
      setLastFBMessage(result[1]);
      return false;
    }
  }

  // Firebase 로그아웃
  signOut() async {
    await fAuth.signOut();
    setUser(null);
  }

  // 사용자에게 비밀번호 재설정 메일을 전송
  sendPasswordResetEmail() async {
    await fAuth.setLanguageCode("ko");
    fAuth.sendPasswordResetEmail(email: getUser().email);
  }

  // Firebase로부터 회원탈퇴
  withdrawalAccount() async {
    await getUser().delete();
    setUser(null);
  }

  // Firebase로부터 수신한 메시지 설정
  setLastFBMessage(String msg) {
    _lastFirebaseResponse = msg;
  }

  // Firebase로부터 수신한 메시지를 반환하고 삭제
  getLastFBMessage() {
    String returnValue = _lastFirebaseResponse;
    _lastFirebaseResponse = null;
    return returnValue;
  }
}
