import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: appHeader,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        home: const HomePage(),
      ),
    ),
  );
}

const appHeader = 'StreamProvider';

const names = [
  'Alice',
  'Bob',
  'Dave',
  'Mong',
  'Jack',
  'Pearl',
  'Liong',
];

final tickerProvider = StreamProvider(
  (ref) => Stream.periodic(
    const Duration(
      seconds: 1,
    ),
    (i) => i + 1,
  ),
);

final namesProvider = StreamProvider(
  (ref) => ref.watch(tickerProvider.stream).map(
        (count) => names.getRange(
          0,
          count,
        ),
      ),
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(
      namesProvider,
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            appHeader,
          ),
        ),
        body: names.when(
          data: (names) {
            return ListView.builder(
              itemCount: names.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text(
                    names.elementAt(index),
                  ),
                );
              }),
            );
          },
          error: (error, stackTrace) => const Text('Reached end of the list!'),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ));
  }
}
