import '../models/categoria.dart';
import '../models/producto.dart';

/// Datos de ejemplo con los que arranca el catálogo.
final List<Producto> productosIniciales = [
  const Producto(
    id: 'p1',
    nombre: 'Procesador Intel Core i7-14700K',
    categoria: Categoria.procesadores,
    precio: 1899.00,
    descripcion:
        'Procesador de 14.ª generación para escritorio, ideal para tareas de '
        'virtualización, compilación y edición multimedia en laboratorio.',
    caracteristicas: [
      '20 núcleos (8P + 12E) / 28 hilos',
      'Frecuencia turbo hasta 5.6 GHz',
      'Socket LGA 1700',
      'Gráficos integrados Intel UHD 770',
    ],
    imagenAsset: 'assets/images/procesador_intel.jpg',
    stock: 6,
  ),
  const Producto(
    id: 'p2',
    nombre: 'Procesador AMD Ryzen 7 7800X3D',
    categoria: Categoria.procesadores,
    precio: 1749.00,
    descripcion:
        'Procesador con tecnología 3D V-Cache, excelente rendimiento en '
        'aplicaciones de alto consumo de memoria caché.',
    caracteristicas: [
      '8 núcleos / 16 hilos',
      'Frecuencia turbo hasta 5.0 GHz',
      'Socket AM5',
      '96 MB de caché L3',
    ],
    imagenAsset: 'assets/images/procesador_amd.jpg',
    stock: 3,
  ),
  const Producto(
    id: 'p3',
    nombre: 'SSD NVMe M.2 1 TB',
    categoria: Categoria.almacenamiento,
    precio: 289.90,
    descripcion:
        'Unidad de estado sólido PCIe 4.0 de alta velocidad para sistemas '
        'operativos y aplicaciones.',
    caracteristicas: [
      'Interfaz PCIe Gen 4.0 x4',
      'Lectura hasta 7000 MB/s',
      'Escritura hasta 6000 MB/s',
      'Formato M.2 2280',
    ],
    imagenAsset: 'assets/images/ssd_nvme.jpg',
    stock: 15,
  ),
  const Producto(
    id: 'p4',
    nombre: 'Disco duro interno 2 TB 7200 RPM',
    categoria: Categoria.almacenamiento,
    precio: 239.00,
    descripcion:
        'Disco duro mecánico de 3.5" para respaldo de información y '
        'almacenamiento masivo.',
    caracteristicas: [
      'Capacidad 2 TB',
      '7200 RPM',
      'Interfaz SATA III 6 Gb/s',
      'Caché de 256 MB',
    ],
    imagenAsset: 'assets/images/disco_duro.jpg',
    stock: 0,
  ),
  const Producto(
    id: 'p5',
    nombre: 'Memoria RAM DDR5 16 GB 5600 MHz',
    categoria: Categoria.hardware,
    precio: 219.00,
    descripcion:
        'Módulo de memoria DDR5 con disipador, compatible con plataformas '
        'Intel y AMD de última generación.',
    caracteristicas: [
      'Capacidad 16 GB (1 x 16 GB)',
      'Velocidad 5600 MHz',
      'Latencia CL36',
      'Disipador de aluminio',
    ],
    imagenAsset: 'assets/images/memoria_ram.jpg',
    stock: 20,
  ),
  const Producto(
    id: 'p6',
    nombre: 'Placa madre ATX B760',
    categoria: Categoria.hardware,
    precio: 689.00,
    descripcion:
        'Tarjeta madre formato ATX para procesadores Intel de 12.ª a 14.ª '
        'generación, con soporte DDR5.',
    caracteristicas: [
      'Socket LGA 1700',
      '4 ranuras DDR5',
      '2 ranuras M.2 PCIe 4.0',
      'Red 2.5 GbE',
    ],
    imagenAsset: 'assets/images/placa_madre.jpg',
    stock: 4,
  ),
  const Producto(
    id: 'p7',
    nombre: 'Tarjeta gráfica RTX 4060 8 GB',
    categoria: Categoria.hardware,
    precio: 1399.00,
    descripcion:
        'Tarjeta de video para modelado 3D, diseño gráfico y prácticas de '
        'inteligencia artificial.',
    caracteristicas: [
      '8 GB GDDR6',
      'Interfaz PCIe 4.0',
      'Salidas HDMI 2.1 y DisplayPort 1.4a',
      'Doble ventilador',
    ],
    imagenAsset: 'assets/images/tarjeta_grafica.jpg',
    stock: 2,
  ),
  const Producto(
    id: 'p8',
    nombre: 'Teclado mecánico USB',
    categoria: Categoria.perifericos,
    precio: 199.00,
    descripcion:
        'Teclado mecánico con switches táctiles y retroiluminación, '
        'distribución en español.',
    caracteristicas: [
      'Switches mecánicos táctiles',
      'Retroiluminación LED',
      'Distribución en español (LA)',
      'Conexión USB',
    ],
    imagenAsset: 'assets/images/teclado.jpg',
    stock: 12,
  ),
  const Producto(
    id: 'p9',
    nombre: 'Mouse ergonómico gamer',
    categoria: Categoria.perifericos,
    precio: 89.90,
    descripcion:
        'Mouse óptico de alta precisión con diseño ergonómico y botones '
        'programables.',
    caracteristicas: [
      'Sensor óptico 16 000 DPI',
      '6 botones programables',
      'Cable trenzado de 1.8 m',
    ],
    imagenAsset: 'assets/images/mouse.jpg',
    stock: 25,
  ),
  const Producto(
    id: 'p10',
    nombre: 'Monitor 24" Full HD IPS',
    categoria: Categoria.perifericos,
    precio: 549.00,
    descripcion:
        'Monitor de 24 pulgadas con panel IPS y bordes delgados, ideal para '
        'estaciones de trabajo.',
    caracteristicas: [
      'Resolución 1920 x 1080',
      'Panel IPS, 75 Hz',
      'Entradas HDMI y VGA',
    ],
    imagenAsset: 'assets/images/monitor.jpg',
    stock: 0,
  ),
];
