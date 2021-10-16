import 'package:catsapp/repository/model/cat.dart';
import 'package:catsapp/repository/service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockHttp extends Mock implements http.Client {}

//
// class MockResponse extends Mock implements http.Response {}
//
// class FakeUri extends Fake implements Uri {}
@GenerateMocks([http.Client])
void main() {
  group('Service', () {
    late CatService catService;
    late MockHttp client;

    group('constructor', () {
      test('does not required an httpClient', () {
        expect(CatService(), isNotNull);
      });
    });
    setUp(() {
      client = MockHttp();
      catService = CatService(httpClient: client);
    });

    group(('catSearch'), () {
      test('make correct http request', () async {
        final url =
            Uri.parse('www.api.thecatapi.com/v1/images/search?has_breeds=true');

        when(client.get(url)).thenAnswer((_) async => http.Response(
            '[{'
            '"breeds":[{"weight":{"imperial":"8 - 15","metric":"4 - 7"},'
            '"id":"asho","name":"American Shorthair",'
            '"cfa_url":"http://cfa.org/Breeds/BreedsAB/AmericanShorthair.aspx",'
            '"vetstreet_url":"http://www.vetstreet.com/cats/american-shorthair",'
            '"vcahospitals_url":"https://vcahospitals.com/know-your-pet/cat-breeds/american-shorthair",'
            '"temperament":"Active, Curious, Easy Going, Playful, Calm",'
            '"origin":"United States",'
            '"country_codes":"US",'
            '"country_code":"US",'
            '"description":"The American Shorthair is known for its longevity, '
            'robust health, good looks, sweet personality, '
            'and amiability with children, dogs, and other pets",'
            '"life_span":"15 - 17",'
            '"indoor":0,'
            '"lap":1,'
            '"alt_names":"Domestic Shorthair",'
            '"adaptability":5,'
            '"affection_level":5,'
            '"child_friendly":4,'
            '"dog_friendly":5,'
            '"energy_level":3,'
            '"grooming":1,'
            '"health_issues":3,'
            '"intelligence":3,'
            '"shedding_level":3,'
            '"social_needs":4,"stranger_friendly":3,'
            '"vocalisation":3,'
            '"experimental":0,'
            '"hairless":0,'
            '"natural":1,'
            '"rare":0,'
            '"rex":0,'
            '"suppressed_tail":0,'
            '"short_legs":0,'
            '"wikipedia_url":"https://en.wikipedia.org/wiki/American_Shorthair",'
            '"hypoallergenic":0,'
            '"reference_image_id":"JFPROfGtQ"}],'
            '"id":"MuEGe1-Sz",'
            '"url":"https://cdn2.thecatapi.com/images/MuEGe1-Sz.jpg",'
            '"width":3000,'
            '"height":2002}]',
            200));
        final result = await catService.search();
        expect(result, isA<Cat>());
        // final response = MockResponse();
        // when(() => response.statusCode).thenReturn(200);
        // when(() => response.body).thenReturn('[]');
        // when(() => httpClient.get(any())).thenAnswer((_) async => response);
        // try {
        //   await catService.search();
        // } catch (_) {}
        // verify(
        //   () => httpClient.get(
        //     Uri.https(
        //         'www.api.thecatapi.com', '/v1/images/search?has_breeds=true'),
        //   ),
        // ).called(1);
      });

      test('throws an exception if the http call completes with an error',
          () async {
        when(client.get(Uri.parse(
                'www.api.thecatapi.com/v1/images/search?has_breeds=true')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        var result = await catService.search();
        expect(result, throwsException);
      });
    });
  });
}
