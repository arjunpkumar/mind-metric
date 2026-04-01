
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_base/src/application/bloc/home/home_bloc.dart';
import 'package:flutter_base/src/application/bloc/home/home_event.dart';
import 'package:flutter_base/src/application/bloc/home/home_state.dart';
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
      'emits [] when nothing is added',
      build: () => HomeBloc(),
      expect: () => [],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeState] when HomeInit is added',
      build: () => HomeBloc(),
      act: (bloc) => bloc.add(HomeInit()),
      expect: () => [isA<HomeState>()],
    );
  });
}
