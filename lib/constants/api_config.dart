import 'package:lashess_by_prii_app/interfaces/interfaces.dart';

const bool isProduction = bool.fromEnvironment('dart.vm.product');

final String baseApi = isProduction
    ? 'https://lashees_by_prii.com/api'
    : 'http://192.168.1.15:3000/api';

final services = [
      ServiceInfo(
        name: "Extensiones Clásicas",
        price: "U\$S 30",
        description: "Técnica pelo a pelo para un look natural y definido.",
        imagePaths: [
          'assets/images/classic1.jpg',
        ],
      ),
      ServiceInfo(
        name: "Volumen Ruso",
        price: "U\$S 45",
        description:
            "Ventiladores de 2 a 6 pestañas ultra finas para mayor densidad y volumen dramático.",
        imagePaths: [
          'assets/images/russian1.jpg',
        ],
      ),
      ServiceInfo(
        name: "Retoque (15 días)",
        price: "U\$S 20",
        description:
            "Reaplicación parcial para mantener la frescura y densidad de tu diseño inicial.",
        imagePaths: [
          'assets/images/retouch1.jpg',
        ],
      ),
      ServiceInfo(
        name: "Laminado de Pestañas",
        price: "U\$S 25",
        description:
            "Tratamiento que eleva y da forma natural a tus pestañas, ideal para un look sin extensiones.",
        imagePaths: [
          'assets/images/laminado1.jpg',
        ],
      ),
      ServiceInfo(
        name: "Lifting + Tinte",
        price: "U\$S 35",
        description:
            "Combinación de elevación con color para realzar tus pestañas naturales con intensidad.",
        imagePaths: [
          'assets/images/lifting1.jpg',
        ],
      ),
    ];