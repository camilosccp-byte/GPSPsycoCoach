# ==============================================================================
# PROYECTO: Fútbol Biometric Analytics
# SCRIPT: 02_plots_maps.R
# OBJETIVO: Renderizado de la cancha y generación de mapas de calor dinámicos (DISC)
# ==============================================================================

library(tidyverse)
library(ggplot2)

# NOTA: En producción, aquí cargarías el DataFrame unificado del script 01:
# datos_integrados <- read_csv("data/processed/datos_limpios.csv")

# ------------------------------------------------------------------------------
# 1. DISEÑO GEOMÉTRICO DEL CAMPO DE FÚTBOL (Dimensiones Reglamentarias)
# ------------------------------------------------------------------------------
graficar_campo_futbol <- function() {
  list(
    # Límites externos de la cancha (Estándar FIFA: 100m de largo x 64m de ancho)
    annotate("rect", xmin = 0, xmax = 100, ymin = 0, ymax = 64, fill = "#142516", alpha = 0.95, color = "white", size = 1.2),
    # Línea de mitad de campo
    annotate("segment", x1 = 50, x2 = 50, y1 = 0, y2 = 64, color = "white", size = 1),
    # Círculo central (Radio reglamentario de 9.15 metros)
    annotate("path", 
             x = 50 + 9.15 * cos(seq(0, 2*pi, length.out = 100)),
             y = 32 + 9.15 * sin(seq(0, 2*pi, length.out = 100)), 
             color = "white", size = 1),
    # Punto central de saque
    annotate("point", x = 50, y = 32, color = "white", size = 2),
    
    # Área grande izquierda
    annotate("rect", xmin = 0, xmax = 16.5, ymin = 13.8, ymax = 50.2, fill = NA, color = "white", size = 1),
    # Área chica izquierda
    annotate("rect", xmin = 0, xmax = 5.5, ymin = 24.8, ymax = 39.2, fill = NA, color = "white", size = 1),
    
    # Área grande derecha
    annotate("rect", xmin = 83.5, xmax = 100, ymin = 13.8, ymax = 50.2, fill = NA, color = "white", size = 1),
    # Área chica derecha
    annotate("rect", xmin = 94.5, xmax = 100, ymin = 24.8, ymax = 39.2, fill = NA, color = "white", size = 1),
    
    # Configuración estética oscura premium para el lienzo gráfico
    theme_void(),
    theme(
      plot.background = element_rect(fill = "#0d0d0d", color = NA),
      plot.title = element_text(color = "white", face = "bold", size = 16, hjust = 0.5, margin = margin(t = 15)),
      plot.subtitle = element_text(color = "#888888", size = 11, hjust = 0.5, margin = margin(b = 20)),
      legend.title = element_text(color = "white", face = "bold", size = 9),
      legend.text = element_text(color = "#cccccc", size = 8),
      legend.position = "right"
    )
  )
}

# ------------------------------------------------------------------------------
# 2. ALGORITMO DE FILTRADO Y MODULACIÓN DE PÁNICO (DISC)
# ------------------------------------------------------------------------------
# Cambia este ID para auditar a cualquier otro jugador de la plantilla
jugador_objetivo <- "Jugador_05" # En nuestro script 01, el Jugador_05 es "Estable"

# Extraemos la metadata psicológica del jugador seleccionado
perfil_psicologico <- datos_integrados %>% 
  filter(jugador_id == jugador_objetivo) %>% 
  pull(perfil_disc) %>% 
  unique()

# CALIBRACIÓN DE PÁNICO DINÁMICA (Tu corolario científico)
umbral_base <- 175
umbral_adaptado <- case_when(
  perfil_psicologico == "Dominante" ~ umbral_base + 5,  # Soporta más activación
  perfil_psicologico == "Estable"   ~ umbral_base - 5,  # Sensible, se bloquea antes
  TRUE                              ~ umbral_base       # Influyente y Concienzudo estándar
)

# Filtrado de la telemetría del jugador
telemetria_jugador <- datos_integrados %>% filter(jugador_id == jugador_objetivo)

# Aislamos los momentos exactos de las palabras clave emitidas por el entrenador
eventos_voz_dt <- telemetria_jugador %>% 
  filter(tipo_trigger != "Sin Intervención") %>%
  distinct(timestamp, .keep_all = TRUE) %>%
  mutate(
    # Creamos una etiqueta de texto que combine la palabra y el tono de voz capturado
    etiqueta_voz = paste0("'", palabra_trigger, "' (", round(tono_f0), " Hz)")
  )

# ------------------------------------------------------------------------------
# 3. RENDERIZADO DEL MAPA DE CALOR MULTIMODAL
# ------------------------------------------------------------------------------
mapa_final <- ggplot(telemetria_jugador, aes(x = coord_x, y = coord_y)) +
  # Capa 1: El fondo geométrico reglamentario del campo
  graficar_campo_futbol() +
  
  # Capa 2: Densidad matemática basada exclusivamente en sus picos de pánico modulados
  stat_density_2d(
    data = filter(telemetria_jugador, fc_bpm >= umbral_adaptado),
    aes(fill = ..level..), 
    geom = "polygon", 
    alpha = 0.25, 
    bins = 7
  ) +
  scale_fill_viridis_c(option = "magma", name = "Zonas de Pánico\nFisiológico") +
  
  # Capa 3: Marcadores espaciales de las instrucciones de voz del director técnico
  geom_point(
    data = eventos_voz_dt,
    aes(color = etiqueta_voz), 
    size = 5, 
    shape = 18, 
    stroke = 1.5
  ) +
  scale_color_brewer(palette = "Set1", name = "Voz del DT e Intensidad") +
  
  # Textos adaptados dinámicamente según el perfil del atleta
  labs(
    title = paste("Auditoría Espacial de Estrés:", jugador_objetivo, paste0("(", perfil_psicologico, ")")),
    subtitle = paste("Mapa mapeado con Umbral de Pánico Adaptado DISC a", umbral_adaptado, "BPM"),
    x = NULL, y = NULL
  )

# Desplegar el mapa en la interfaz gráfica de RStudio
print(mapa_final)
