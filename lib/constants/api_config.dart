const bool isProduction = bool.fromEnvironment('dart.vm.product');

final String baseApi = isProduction
    ? 'https://lashees_by_prii.com/api'
    : 'http://192.168.1.15:3000/api';
