# KC_Dragon_Ball_IOS_Avanzado

**KC_Dragon_Ball_IOS_Avanzado** es una aplicación avanzada de iOS diseñada para gestionar y visualizar personajes y sus transformaciones en el universo de Dragon Ball. La aplicación se centra en una arquitectura de software modular y eficiente, basada en los principios de MVVM (Model-View-ViewModel) y Core Data para la persistencia de datos. Este proyecto también implementa patrones de diseño y casos de uso para garantizar una alta cohesión entre las capas de datos y la interfaz de usuario.

## Tabla de Contenidos

- [Funcionalidades](#funcionalidades)
- [Arquitectura](#arquitectura)
- [Componentes Principales](#componentes-principales)
  - [Modelo de Datos](#modelo-de-datos)
  - [Casos de Uso](#casos-de-uso)
  - [Proveedores de Datos](#proveedores-de-datos)
- [Configuración del Proyecto](#configuración-del-proyecto)
- [Pruebas](#pruebas)
- [Requisitos del Sistema](#requisitos-del-sistema)
- [Contacto](#contacto)

---

## Funcionalidades

La aplicación permite a los usuarios:
- Autenticarse en la aplicación mediante un sistema de login seguro.
- Explorar y visualizar una lista de héroes, junto con detalles específicos como su foto, descripción y transformaciones.
- Ver la ubicación de cada héroe en un mapa interactivo.
- Iniciar y detener la reproducción de música relacionada con los héroes.
- Marcar héroes como favoritos para tener acceso rápido a ellos.
- Mantener la persistencia de datos en Core Data, permitiendo el acceso offline.

## Arquitectura

La aplicación sigue el patrón de arquitectura **MVVM (Model-View-ViewModel)** y utiliza Core Data para la persistencia. La separación de responsabilidades se distribuye de la siguiente forma:
- **View**: Controladores de vista y vistas (interfaz de usuario).
- **ViewModel**: Lógica de negocio y manipulación de datos para actualizar la vista.
- **Model**: Representación de los datos en Core Data y estructuras de dominio.

Adicionalmente, se implementan **Casos de Uso** para gestionar la interacción entre los proveedores de datos y la lógica de negocio.

## Componentes Principales

### Modelo de Datos

La aplicación cuenta con modelos que representan los héroes, transformaciones y localizaciones, tanto para la API como para Core Data. Los modelos se organizan de la siguiente manera:

- **Api Models**: `ApiHero`, `ApiTransformation`, `ApiLocation`, etc., que mapean los datos recibidos desde la API.
- **Core Data Models**: `MOHero`, `MOTransformation`, `MOLocation` representan el almacenamiento de datos en la base de datos local.
- **Domain Models**: `Hero`, `Transformation`, `Location`, que abstraen y facilitan el uso de datos en la capa de presentación.

### Casos de Uso

Los casos de uso definen la lógica de negocio y proporcionan una interfaz clara para la interacción con los datos. Entre los casos de uso se encuentran:

1. **HeroUseCase**: Carga la lista de héroes, ya sea desde la API o desde la base de datos local.
2. **HeroDetailUseCase**: Obtiene los detalles de un héroe, incluyendo transformaciones y ubicaciones.
3. **TransformationUseCase**: Maneja la carga de transformaciones, ya sea desde la API o la base de datos local.

Estos casos de uso garantizan la separación de responsabilidades y simplifican el proceso de pruebas.

### Proveedores de Datos

#### ApiProvider

El `ApiProvider` se encarga de gestionar las llamadas a la API y ofrece métodos para:

- Cargar héroes (`loadHeros`)
- Cargar ubicaciones (`loadLocations`)
- Cargar transformaciones (`loadTransformations`)
- Autenticación del usuario (`loadToken`)

#### StoreDataProvider

`StoreDataProvider` utiliza Core Data para almacenar y recuperar datos localmente. Este proveedor permite realizar consultas eficientes y persistir datos sin conexión.

---

## Configuración del Proyecto

Para ejecutar este proyecto:

1. **Clona el repositorio** en tu máquina local.
2. **Instala las dependencias** utilizando CocoaPods si el proyecto las requiere.
3. **Configura las variables de entorno** en caso de que la API necesite tokens de autenticación o claves de acceso.
4. **Ejecuta el proyecto** en un simulador o dispositivo real con iOS 14.0 o superior.

## Pruebas

El proyecto incluye un conjunto de pruebas unitarias utilizando `XCTest` para verificar:

- La correcta integración de la API y la base de datos.
- La carga y transformación de datos en el ViewModel.
- La gestión de errores de la API y los datos almacenados localmente.

Para ejecutar las pruebas:
1. Selecciona el esquema de pruebas en Xcode.
2. Presiona **Cmd + U** para correr todas las pruebas.

## Requisitos del Sistema

- **Xcode 12.0** o superior
- **iOS 14.0** o superior
- **CocoaPods** para la gestión de dependencias (opcional)

---

## Contacto

**Juan Carlos Rubio Casas**  
**Teléfono**: 606405215  
**Email**: [jcrubio@equinsa.es](mailto:jcrubio@equinsa.es)

**Desarrollado por Juan Carlos Rubio Casas**
