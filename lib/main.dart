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

const appHeader = 'App';

extension OptionalInfixAddition<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this;
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

enum City {
  stockholm,
  paris,
  tokyo,
}

typedef WeatherEmoji = String;

Future<WeatherEmoji> getWeather(City city) {
  return Future.delayed(
    const Duration(seconds: 1),
    () =>
        {
          City.stockholm: 'snow',
          City.paris: 'rainy',
          City.tokyo: 'sunlight',
        }[city] ??
        unknownWeatherEmoji,
  );
}

// UI writes to this and reads from this
final currentCityProvider = StateProvider<City?>(
  (ref) => null,
);

const unknownWeatherEmoji = '?';

// UI reads this
final weatherProvider = FutureProvider<WeatherEmoji>(
  (ref) {
    final city = ref.watch(
      currentCityProvider,
    );

    if (city != null) {
      return getWeather(city);
    } else {
      return unknownWeatherEmoji;
    }
  },
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(
      weatherProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          appHeader,
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            currentWeather.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(11.0),
                child: CircularProgressIndicator(),
              ),
              data: (data) => Text(
                data,
                style: const TextStyle(
                  fontSize: 40,
                ),
              ),
              error: (error, stackTrace) => const Text('Error...'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: City.values.length,
                itemBuilder: (
                  context,
                  index,
                ) {
                  final city = City.values[index];
                  final isSelected = city ==
                      ref.watch(
                        currentCityProvider,
                      );
                  return ListTile(
                    title: Text(
                      city.toString(),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check,
                          )
                        : null,
                    onTap: () => ref
                        .read(
                          currentCityProvider.notifier,
                        )
                        .state = city,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
