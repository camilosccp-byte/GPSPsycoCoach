# GPSPsycoCoach
Este repositorio es una primera aproximacion a lo que seria el uso a profundidad de datos VFR y FC para entender el grado de ansiedad y animico de un jugador, determinando la ZOF con el objetivo de: aplicar terapias psicologicas en juego o entrenamiento y que esto mejore sus funciones ejecutivas, al mejorar la concentracion y enfoque; junto con el grado de cohesion real y abordar una auditoria completa de un cuerpo técnico (DT principalmente) al revisar si su comunicacion y enfoque si esta teniendo un impacto esperado en el equipo!

# ⚽ Fútbol Biometric Analytics, AI Liderazgo & Acoustic Voice Intelligence

El repositorio contiene un ecosistema de analítica deportiva de vanguardia (*Sport Science*) diseñado para evaluar la **Zona de Funcionamiento Óptimo (ZOF)** y el **Índice de Masa Crítica Colectiva (IMCC)** en el fútbol profesional utilizando un enfoque de **Inteligencia Artificial Multimodal**.

A través de la integración de telemetría espacial (GPS), biometría (Frecuencia Cardíaca/Respiratoria), psicología conductual (Test DISC) y analítica acústica de la voz del entrenador, el sistema permite auditar objetivamente la gobernabilidad del vestuario, evaluar el desempeño del psicólogo y optimizar el mercado de fichajes (*Smart Scouting*).

---

## 🛠️ Arquitectura Híbrida del Repositorio (R + Python)

El proyecto utiliza el paquete `reticulate` para unificar el poder de Python en el procesamiento de señales de audio con la capacidad estadística y de visualización de R:

```text
futbol-biometric-analytics/
│
├── LICENSE                 # Licencia MIT (Software libre, uso comercial y protección legal)
├── .gitignore              # Filtro para entorno RStudio y carpeta virtual env_futbol_ai/
├── README.md               # Presentación del proyecto e instrucciones de uso
├── data/                   # Datos biométricos, espaciales y acústicos
│   ├── raw/                # Archivos crudos (Estructura SoccerMon y audios .wav del DT)
│   └── processed/          # Matrices integradas listas para el modelo
├── theory/                 # Sustento científico y metodológico
│   ├── metodologia_liderazgo.md # Análisis de Clases Latentes, IMCC e índices DISC
│   └── self_talk_priors.md      # Catálogo de triggers y Priors Bayesianos de literatura
└── src/                    # Código fuente del ecosistema
    ├── 00_acoustic_analysis.R  # Extracción de voz del DT con Python (Librosa vía reticulate)
    ├── 01_data_cleaning.R      # Sincronización temporal (Rolling Join) y Benchmarks por posición
    ├── 02_plots_maps.R         # Renderizado estático de la cancha y mapas de calor de estrés
    ├── 03_bayes_model.R        # Motor predictivo Bayesiano (brms) para control de vestuario
    └── app.R                   # Dashboard Shiny interactivo premium con control de voz
```

---

## 🚀 El Pipeline de Datos Multimodal

La ventaja metodológica de este software radica en la fusión de cuatro fuentes de información independientes utilizando el **tiempo (`Timestamp`)** y el **espacio (`Coord X, Y`)** como ejes unificadores:

1. **El Espacio (GPS - R):** Registra las coordenadas de la plantilla y calcula las **Celdas de Voronoi** para determinar el control de área teórico de cada jugador.
2. **El "Cómo se Dice" (Acústica - Python/R):** Procesa el micrófono del entrenador usando `librosa` para extraer biomarcadores de voz como el **Tono ($F_0$)**, la **Claridad (MFCC)** y la **Estabilidad (Jitter)**.
3. **El Contexto (Bitácora/Voz - Shiny):** Registra el segundo exacto en el que el DT emite una palabra activadora (capturada en vivo por voz en la app o por texto).
4. **La Respuesta (Biometría - R):** Registra la FC y Respiración, evaluando si el jugador entra en **Zona Óptima**, **Pánico (Hiperactivación)** o **Apatía (Subactivación/"Cajón")**, modulando los umbrales automáticamente según el perfil psicológico **DISC** del atleta.

---

## 📦 Requisitos e Instalación

Este proyecto requiere un entorno híbrido. Asegúrate de tener instalado R (4.0+) y Python (3.8+).

### 1. Clonar el repositorio e instalar librerías de R:
```R
install.packages(c("shiny", "shinydashboard", "tidyverse", "brms", "ggiraph", "ggforce", "reticulate"))
# Instalar paquete de reconocimiento de voz nativo desde GitHub
remotes::install_github("jcrodriguez1989/heyshiny", dependencies = TRUE)
```

### 2. Configurar el entorno de Python (Automático vía Reticulate):
Al ejecutar el primer script, `reticulate` creará un entorno virtual aislado llamado `env_futbol_ai` e instalará las dependencias necesarias de procesamiento de audio (`librosa`, `numpy`, `pandas`) sin interferir con tu sistema global.

---

## 💻 Flujo de Ejecución

### Paso 1: Análisis Acústico e Integración de Datos
Procesa el audio del micrófono del entrenador y genera la matriz unificada cruzando biometría, eventos, benchmarks posicionales y parámetros de voz:
```bash
Rscript src/00_acoustic_analysis.R
Rscript src/01_data_cleaning.R
```

### Paso 2: Lanzamiento del Centro de Mando Terrestre e Inteligencia en Vivo
Abre el panel interactivo diseñado para el cuerpo técnico y el psicólogo deportivo. El sistema permite dictar palabras activadoras por voz en tiempo real, visualizar mapas de calor cruzados con las Celdas de Voronoi y activar el **Módulo de Alertas Preventivas de Remontada (IFRM)**, el cual notificará al banquillo si la línea defensiva sufre desgaste cognitivo severo ante las ventanas de goles históricos del rival.
```R
shiny::runApp("src/app.R")
```

---

## 📊 Diagnóstico de Gobernabilidad de Vestuario
- **Evidencia Científica del "Cajón":** Si la voz del DT muestra alta claridad y calidez, pero la biometría del grupo es plana (apatía táctica), el modelo Bayesiano demuestra insubordinación pasiva de la plantilla.
- **Evidencia de Saturación del DT:** Si el análisis acústico detecta tonos agudos inestables (gritos desorganizados) y el grupo entra en pánico (FC/RPM críticas), la responsabilidad de la pérdida de control espacial es del cuerpo técnico.
