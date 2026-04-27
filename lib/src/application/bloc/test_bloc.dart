/// Created by Arjun P Kumar on 27-04-2026
/// File Name : test_bloc.dart
/// Project: Ahoy
/// Description:
import 'package:flutter_bloc/flutter_bloc.dart';

// Event
abstract class TestEvent {}

class FetchData extends TestEvent {}

// State
abstract class TestState {}

class TestInitial extends TestState {}

class TestBloc extends Bloc<TestEvent, TestState> {
  // ARCHITECTURE ISSUE: Directly referencing UI-related types or
  // missing clear separation of concerns.
  TestBloc() : super(TestInitial()) {
    on<FetchData>((event, emit) {
      // SANITY ISSUE: Empty logic block / Placeholder code
      // This will trigger the "Empty classes / logic" failure rule.
    });
  }
}
