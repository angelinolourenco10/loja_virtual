import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'; // Import necessário para @required
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  final FirebaseFirestore firestore= FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? firebaseUser; // Agora é nullable
  Map<String, dynamic> userData = Map();
  bool isLoading = false;

  static UserModel of(BuildContext context)=>ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  Future<void> signUp({
    required Map<String, dynamic> userData,
    required String pass,
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: userData["email"],
        password: pass,
      );
      firebaseUser = userCredential.user;
      await _saveUserData(userData);
      onSuccess();
    } catch (e) {
      print("Erro ao criar usuário: $e");
      onFail();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }



  Future<void> recoverPass(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      // Notificar usuário sobre o email enviado
    } catch (e) {
    }
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await firestore.collection("users").doc(firebaseUser?.uid).set(userData);
  }

  void signOut() async {
    await _auth.signOut();
    userData = Map(); // Use {} em vez de Map()
    firebaseUser = null;
    notifyListeners();
  }
  Future<void> signIn({
    required String email,
    required String pass,
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) async {
    userData = Map();
    isLoading = true;
    notifyListeners();

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      firebaseUser = userCredential.user;
      await _loadCurrentUser();
      if (firebaseUser != null) {
        final userDoc = await firestore.collection("users").doc(firebaseUser!.uid).get();

        // Verifica se o documento existe e se tem dados
        if (userDoc.exists && userDoc.data() != null) {
          userData = userDoc.data() as Map<String, dynamic>;
        } else {
          userData = {}; // Se não existir, userData é vazio
        }

        onSuccess();
      } else {
        onFail();
      }
    } catch (e) {
      print("Erro ao fazer login: $e");
      onFail();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<void> _loadCurrentUser() async {
    // Verifica se o firebaseUser já está definido
    if (firebaseUser == null) {
      firebaseUser = _auth.currentUser;
    }

    // Se houver um usuário autenticado
    if (firebaseUser != null) {
      // Verifica se os dados do usuário ainda não foram carregados
      if (userData["name"] == null) {
        try {
          DocumentSnapshot docUser = await firestore
              .collection("users")
              .doc(firebaseUser!.uid)
              .get();

          if (docUser.exists) {
            userData = docUser.data() as Map<String, dynamic>;
          }
        } catch (e) {
          print("Erro ao carregar dados do usuário: $e");
        }
      }
    }

    // Notifica os listeners sobre as mudanças no modelo
    notifyListeners();
  }
}
