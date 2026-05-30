# Odontograma Interactivo

Sistema de odontograma digital interactivo construido con **Ruby on Rails 7**, **Stimulus JS** y **SVG**. Permite registrar y visualizar el estado de cada pieza dental con 5 caras clickeables, 7 estados posibles, historial de cambios y versionado.

## Características

- **Odontograma anatómico**: dibuja la forma real de cada diente (corona y raíces) diferenciando incisivos, caninos, premolares y molares
- **5 caras por diente**: Vestibular (V), Mesial (M), Oclusal/Incisal (O/I), Distal (D), Palatino/Lingual (P/L)
- **7 estados**: Sano, Cariado, Tratado, Ausente, Endodoncia, Prótesis/Corona, Implante
- **Diferenciación Adulto/Niño**: 32 piezas (FDI 11–48) o 20 piezas (FDI 51–85)
- **Estados de diente completo**: Ausente, Implante y Prótesis se aplican a toda la pieza
- **Historial de cambios**: registro detallado con fecha, diente, cara y estados anterior/nuevo
- **Versionado**: crear nuevas versiones del odontograma preservando el estado actual
- **Deshacer**: botón para revertir el último cambio realizado
- **Interfaz responsive**: se adapta a dispositivos móviles y de escritorio

## Tecnologías

- **Ruby 3.2.0**
- **Rails 7.2.3** (sin Turbo, `--skip-hotwire`)
- **SQLite3**
- **Stimulus JS**
- **SVG** con paths anatómicos y clipPath

## Requisitos

- Ruby >= 3.2.0
- Bundler
- SQLite3

## Instalación

```bash
# Clonar el repositorio
git clone <url-del-repositorio>
cd odontograma

# Instalar dependencias
bundle install

# Crear y migrar la base de datos
rails db:create
rails db:migrate

# Cargar datos de ejemplo (opcional)
rails db:seed

# Iniciar el servidor
rails server
```

Luego abrir en el navegador: [http://localhost:3000](http://localhost:3000)

## Uso

1. **Seleccionar un paciente** desde la lista principal
2. **Elegir un odontograma** existente o crear uno nuevo
3. **Seleccionar un estado** en la barra de herramientas (Cariado, Tratado, etc.)
4. **Hacer clic en una cara** del diente para marcarla con ese estado
5. **Deshacer** el último cambio con el botón "Deshacer"
6. **Crear una nueva versión** para preservar el estado actual antes de continuar

### Estados especiales (diente completo)

Los estados **Ausente**, **Implante** y **Prótesis** se aplican automáticamente a toda la pieza dental, eliminando cualquier estado previo por cara.

## Estructura del proyecto

```
app/
├── controllers/
│   └── odontograms_controller.rb    # Lógica de actualización, versionado y deshacer
├── helpers/
│   └── odontogram_helper.rb         # Formas anatómicas y posiciones de dientes
├── javascript/controllers/
│   └── odontogram_controller.js     # Interactividad con Stimulus
├── models/
│   ├── odontogram.rb               # Modelo principal con estados y faces
│   ├── patient.rb
│   ├── tooth_state.rb
│   └── state_history.rb
├── views/odontograms/
│   ├── _tooth_body.html.erb        # SVG anatómico con 5 caras clickeables
│   ├── _tooth.html.erb             # Wrapper para diente individual
│   └── show.html.erb               # Layout principal del odontograma
└── assets/stylesheets/
    └── odontogram.css              # Estilos responsive
```

## Rutas principales

| Método | Ruta | Acción |
|--------|------|--------|
| GET | `/patients` | Lista de pacientes |
| GET/POST | `/patients/:id/odontograms` | Odontogramas del paciente |
| GET | `/patients/:id/odontograms/:id` | Visualizar odontograma |
| POST | `.../update_tooth_state` | Marcar cara de diente |
| POST | `.../undo_last_change` | Deshacer último cambio |
| POST | `.../create_new_version` | Crear nueva versión |

## Licencia

Este proyecto es de uso libre.
