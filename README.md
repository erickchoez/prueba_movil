# Yiga Móvil - Prueba Técnica

Aplicación móvil para que un técnico visualice sus órdenes de trabajo.

<img width="312" height="689" alt="image" src="https://github.com/user-attachments/assets/59b9dc22-b2aa-48d8-9d47-b548aa0507c3" />
<img width="317" height="691" alt="image" src="https://github.com/user-attachments/assets/92094b25-25c0-44e4-9cf4-3a5f1a77400c" />
<img width="315" height="681" alt="image" src="https://github.com/user-attachments/assets/eed4d672-2615-4c96-999b-8ae52e825a5f" />
<img width="316" height="684" alt="image" src="https://github.com/user-attachments/assets/234472e3-b78c-4ae6-83fd-d322263b9d97" />
<img width="315" height="682" alt="image" src="https://github.com/user-attachments/assets/85b82c46-5717-4231-8aac-b33dcde599bc" />

## Tecnología usada

- **Flutter**: Framework de desarrollo móvil multiplataforma.
- **Dart**: Lenguaje de programación.
- **shared_preferences**: Paquete para persistencia local de datos.

## Pasos para instalar

1. Asegúrate de tener Flutter instalado en tu equipo (versión 3.10.2 o compatible).
2. Clona o descarga el proyecto.
3. Navega a la carpeta del proyecto `yiga_mobile`.
4. Ejecuta el comando: `flutter pub get` para instalar las dependencias.

## Pasos para ejecutar

1. Conecta un dispositivo móvil o inicia un emulador.
2. En la carpeta del proyecto, ejecuta: `flutter run`.

## Decisiones técnicas

- **Arquitectura simple**: Para mantener la aplicación sencilla y fácil de entender, se implementaron todas las funcionalidades en un solo archivo (`main.dart`).
- **Persistencia local**: Se usó `shared_preferences` para guardar las órdenes de trabajo localmente, ya que es una solución simple y efectiva para datos pequeños.
- **Mock data**: Se incluyeron datos de ejemplo para probar la aplicación sin necesidad de un API backend.
- **Estado simple**: Se manejó el estado local de las pantallas con `StatefulWidget`, lo que es suficiente para el tamaño de esta aplicación.

## Qué mejoraría con más tiempo

- **Arquitectura**: Implementar una arquitectura más estructurada como MVVM o Clean Architecture para separar responsabilidades y hacer el código más mantenible.
- **Gestión de estado**: Usar un paquete como Provider o Bloc para manejar el estado de forma más eficiente.
- **API real**: Conectar la aplicación a una API REST real para obtener y enviar datos de órdenes.
- **Cámara**: Implementar la funcionalidad real de tomar fotos y guardarlas (usando paquetes como `image_picker`).
- **Autenticación**: Agregar autenticación real con un backend.
- **Pruebas**: Agregar pruebas unitarias y de widgets.
- **Diseño**: Mejorar el diseño de la interfaz de usuario con más elementos visuales y animaciones.
