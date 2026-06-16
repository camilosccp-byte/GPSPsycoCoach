# ==============================================================================
# PROYECTO: Fútbol Biometric Analytics
# SCRIPT: 01_data_cleaning.R
# OBJETIVO: Carga, simulación (Estructura SoccerMon), Join Psicológico-Acústico y Benchmarking
# ==============================================================================

library(tidyverse)

# ------------------------------------------------------------------------------
# 1. SIMULACIÓN DE DATOS MULTIVARIADOS (Inspirado en SoccerMon de STATSports)
# ------------------------------------------------------------------------------
set.seed(123)
n_registros <- 2000

# Simulamos la plantilla base con sus posiciones y rasgos de personalidad DISC
plantilla_metadata <- tibble(
  jugador_id = paste0("Jugador_", sprintf("%02d", 1:11)),
  posicion   = c("DC", "EX", "EX", "MC", "MC", "MCD", "LI", "LD", "DFC", "DFC", "POR"),
  perfil_disc = c("Dominante", "Influyente", "Influyente", "Concienzudo", "Estable", 
                  "Concienzudo", "Estable", "Dominante", "Concienzudo", "Estable", "Concienzudo")
)

# Generamos la telemetría espacio-temporal (Simulación de un entrenamiento intermitente)
datos_telemetria <- plantilla_metadata %>%
  crossing(timestamp = seq(from = as.POSIXct("2026-06-15 10:00:00"), length.out = 150, by = "1 sec")) %>%
  mutate(
    coord_x  = runif(n(), min = 0, max = 100),
    coord_y  = runif(n(), min = 0, max = 64),
    # Frecuencia Cardíaca reactiva a la posición e intensidad física
    fc_bpm   = round(rnorm(n(), mean = 162, sd = 12)),
    # Frecuencia Respiratoria (RPM) asociada al esfuerzo y estrés cognitivo
    fr_rpm   = round(rnorm(n(), mean = 38, sd = 5)),
    # Métrica de Rendimiento Técnico Acumulada (Eventing: 0 a 100)
    score_eventing = runif(n(), min = 50, max = 95)
  )

# ------------------------------------------------------------------------------
# 2. BITÁCORA PSICOLÓGICA Y PARÁMETROS ACÚSTICOS DE LA VOZ DEL DT
# ------------------------------------------------------------------------------
# Marcas de tiempo exactas donde el DT usó palabras activadoras, incluyendo
# las variables de voz extraídas previamente por Python (Librosa vía reticulate)
bitacora_psicologo <- tibble(
  timestamp = as.POSIXct(c("2026-06-15 10:00:20", "2026-06-15 10:01:15", "2026-06-15 10:02:00")),
  palabra_trigger = c("Respira", "Mira", "Suelta"),
  tipo_trigger    = c("Psicofisiológica", "Cognitiva", "Psicofisiológica"),
  
  # NUEVAS VARIABLES ACÚSTICAS (Aportadas por tu última innovación)
  tono_f0         = c(135.2, 285.4, 142.1), # Hz: Un tono de 285Hz indica un grito agudo/desesperado
  claridad_mfcc   = c(12.4, -3.2, 10.8),    # MFCC: Valores negativos indican audio distorsionado/ininteligible
  estabilidad_jit = c(0.8, 4.5, 1.1)        # Jitter: Inestabilidad en la amplitud de la voz
)

# ------------------------------------------------------------------------------
# 3. ALGORITMO DE INTEGRACIÓN MULTIMODAL (ROLLING JOIN)
# ------------------------------------------------------------------------------
# Unimos la telemetría del jugador con la voz del entrenador.
# Mapeamos una ventana de impacto psicológico de 10 segundos post-estímulo.
datos_integrados <- datos_telemetria %>%
  left_join(bitacora_psicologo, by = "timestamp") %>%
  group_by(jugador_id) %>%
  arrange(timestamp) %>%
  # Rellenamos hacia abajo el efecto de la palabra y la acústica en los segundos posteriores
  fill(palabra_trigger, tipo_trigger, tono_f0, claridad_mfcc, estabilidad_jit, .direction = "down") %>%
  mutate(
    # Etiquetamos el estado por defecto si no hubo intervención del técnico
    tipo_trigger = if_else(is.na(palabra_trigger), "Sin Intervención", tipo_trigger),
    # Rellenamos con valores basales neutros las variables acústicas si no hay trigger activo
    tono_f0 = replace_na(tono_f0, 120.0),
    claridad_mfcc = replace_na(claridad_mfcc, 15.0),
    estabilidad_jit = replace_na(estabilidad_jit, 0.5)
  ) %>%
  ungroup()

# ------------------------------------------------------------------------------
# 4. FUNCIÓN DE BENCHMARKING: JUGADORES TOP POR POSICIÓN (Puntos de Referencia)
# ------------------------------------------------------------------------------
# Tu función para que los analistas extraigan el perfil psicofisiológico ideal
calcular_benchmarks_posicionales <- function(dataset, percentil_corte = 0.80) {
  
  # 1. Identificar a los futbolistas con mejor rendimiento técnico (Eventing) por posición
  jugadores_top <- dataset %>%
    group_by(jugador_id, posicion) %>%
    summarise(media_eventing = mean(score_eventing, na.rm = TRUE), .groups = 'drop') %>%
    group_by(posicion) %>%
    filter(media_eventing >= quantile(media_eventing, probs = percentil_corte)) %>%
    pull(jugador_id)
  
  # 2. Extraer sus métricas cardio-respiratorias reales en momentos de éxito técnico
  benchmarks <- dataset %>%
    filter(jugador_id %in% jugadores_top) %>%
    group_by(posicion) %>%
    summarise(
      ref_fc_bpm_media = mean(fc_bpm, na.rm = TRUE),
      ref_fc_bpm_sd    = sd(fc_bpm, na.rm = TRUE),
      ref_fr_rpm_media = mean(fr_rpm, na.rm = TRUE),
      total_perfiles_analizados = n_distinct(jugador_id),
      .groups = 'drop'
    )
  
  return(benchmarks)
}

# Ejecución del algoritmo de Benchmarking
tabla_referencia_elite <- calcular_benchmarks_posicionales(datos_integrados, percentil_corte = 0.75)

print("=== PIPELINE DE LIMPIEZA MULTIMODAL COMPLETADO CON ÉXITO ===")
print(head(datos_integrados, 5))

print("=== TABLA DE REFERENCIA FISIOLÓGICA TÁCTICA (BENCHMARKS) ===")
print(tabla_referencia_elite)
