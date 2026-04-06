
import 'package:bloc_test/bloc_test.dart';
import 'package:mind_metric/src/application/bloc/home/home_bloc.dart';
import 'package:mind_metric/src/application/bloc/home/home_event.dart';
import 'package:mind_metric/src/application/bloc/home/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeBloc', () {
    late HomeBloc homeBloc;

    setUp(() {
      homeBloc = HomeBloc();
    });

    test('initial state is HomeState', () {
      expect(homeBloc.state, isA<HomeState>());
    });

    blocTest<HomeBloc, HomeState>(
      'emits completed init after HomeInit from constructor',
      build: () => HomeBloc(),
      expect: () => [
        isA<HomeState>().having(
          (s) => s.isInitCompleted,
          'isInitCompleted',
          true,
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits again when HomeInit is added a second time',
      build: () => HomeBloc(),
      act: (bloc) => bloc.add(HomeInit()),
      expect: () => [
        isA<HomeState>().having(
          (s) => s.isInitCompleted,
          'isInitCompleted',
          true,
        ),
        isA<HomeState>().having(
          (s) => s.isInitCompleted,
          'isInitCompleted',
          true,
        ),
      ],
    );
  });
}
