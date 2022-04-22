// ignore_for_file: missing_required_param
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitup/providers/auth_provider.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User> authStateChanges() {
    return Stream.value(
      _mockUser,
    );
  }
}

void main() {
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  final Auth auth = Auth(auth: mockFirebaseAuth);
  String testEmail = "unit_test@fitup.de";
  String testPassword = "123456789";

  setUp(() {});
  tearDown(() {});

  test('emit occurs', () async {
    expectLater(auth.user, emitsInOrder([_mockUser]));
  });

  test('create account', () async {
    when(
      mockFirebaseAuth.createUserWithEmailAndPassword(
          email: testEmail, password: testPassword),
    ).thenAnswer((realInvocation) => null);
    expect(
        await auth.signUp(email: testEmail, password: testPassword), "Success");
  });

  test('create account exception', () async {
    when(
      mockFirebaseAuth.createUserWithEmailAndPassword(
          email: testEmail, password: testPassword),
    ).thenAnswer((realInvocation) =>
        throw FirebaseAuthException(message: "Something went wrong"));
    expect(await auth.signUp(email: testEmail, password: testPassword),
        "Something went wrong");
  });
  test("sign in", () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: testEmail, password: testPassword))
        .thenAnswer((realInvocation) => null);
    expect(
        await auth.signIn(email: testEmail, password: testPassword), "Success");
  });

  test("sign in exception", () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: testEmail, password: testPassword))
        .thenAnswer((realInvocation) =>
            throw FirebaseAuthException(message: "Something went wrong"));

    expect(await auth.signIn(email: testEmail, password: testPassword),
        "Something went wrong");
  });

  test("sign out", () async {
    when(mockFirebaseAuth.signOut()).thenAnswer((realInvocation) => null);
    expect(await auth.signOut(), "Success");
  });

  test("sign out exception", () async {
    when(mockFirebaseAuth.signOut()).thenAnswer((realInvocation) =>
        throw FirebaseAuthException(message: "Something went wrong"));
    expect(await auth.signOut(), "Something went wrong");
  });
}
