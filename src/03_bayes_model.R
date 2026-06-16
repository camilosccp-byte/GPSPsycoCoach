# ==============================================================================
# PROYECTO: Fútbol Biometric Analytics
# SCRIPT: 03_bayes_model.R
# OBJETIVO: Modelo predictivo Bayesiano avanzado para auditoría de vestuario (DISC + Voz)
# ==============================================================================

library(tidyverse)
library(brms)

# NOTA: En producción, aquí cargarías la matriz unificada generada en el script 01
# datos_integrados <- read_csv("data/processed/datos_limpios.csv")

# ------------------------------------------------------------------------------
# 1. CONFIGURACIÓN DE LA ZONA ÓPTIMA MULTIMODAL
# ------------------------------------------------------------------------------
# Definimos el estado de activación del jugador adaptado a su perfil DISC
datos_para_modelo <- datos_integrados %>%
  group_by(perfil_disc) %>%
  mutate(
    # Calibramos la desviación con el umbral dinámico de personalidad
    umbral_dinamico = case_when(
      perfil_disc == "Dominante" ~ 180,
      perfil_disc == "Estable"   ~ 170,
      TRUE                       ~ 175
    ),
    # Zona Óptima (Ley de Yerkes-Dodson): Activación eficiente, ni pánico ni apatía
    en_zona_optima = if_else(fc_bpm >= (umbral_dinamico - 15) & fc_bpm <= umbral_dinamico, 1, 0)
  ) %>%
  ungroup()

# ------------------------------------------------------------------------------
# 2. DEFINICIÓN DE LA FÓRMULA AVANZADA INTERACTIVA (Tu Innovación)
# ------------------------------------------------------------------------------
# Evaluamos cómo interactúa la personalidad del jugador con el tono de voz del DT (tono_f0)
# más el efecto directo de la claridad táctica (claridad_mfcc).
# '(1 | jugador_id)' es el efecto aleatorio para aislar la condición física individual.

formula_avanzada <- bf(
  en_zona_optima ~ perfil_disc * tono_f0 + claridad_mfcc + (1 | jugador_id),
  family = bernoulli(link = "logit")
)

# ------------------------------------------------------------------------------
# 3. INYECCIÓN DE PRIORS CIENTÍFICOS (Basado en la teoría del repositorio)
# ------------------------------------------------------------------------------
priors_multimodales <- c(
  # Esperamos que un tono muy agudo (grito) reduzca la probabilidad de éxito en perfiles Estables
  prior(normal(-0.5, 0.2), class = "b", coef = "tono_f0"),
  # Esperamos que una alta claridad táctica (MFCC) aumente la probabilidad de éxito
  prior(normal(0.8, 0.3), class = "b", coef = "claridad_mfcc")
)

# ------------------------------------------------------------------------------
# 4. AJUSTE DEL MODELO BAYESIANO (brms / Stan)
# ------------------------------------------------------------------------------
print(">>> AJUSTANDO EL MOTOR BAYESIANO MULTIMODAL (PROCESANDO PRIORS)...")

fit_bayes_vestuario <- brm(
  formula = formula_avanzada,
  data = datos_para_modelo,
  prior = priors_multimodales,
  chains = 2, iter = 1000, cores = 2, # Configuración óptima para el piloto
  backend = "rstan", refresh = 0
)

# ------------------------------------------------------------------------------
# 5. CÁLCULO DEL ÍNDICE DE MASA CRÍTICA COLECTIVA (IMCC) - AUDITORÍA FINAL
# ------------------------------------------------------------------------------
# Extraemos las probabilidades posteriores esperadas para cada escenario
probabilidades_posteriores <- posterior_epred(fit_bayes_vestuario)
datos_para_modelo$prob_coherencia_bayes <- colMeans(probabilidades_posteriores)

# Generamos el reporte confidencial para la Junta Directiva
reporte_auditoria <- datos_para_modelo %>%
  group_by(jugador_id, posicion, perfil_disc) %>%
  summarise(
    IMCC_Individual = mean(prob_coherencia_bayes),
    # Evaluación del comportamiento según los biomarcadores acústicos
    Estado_Vinculo = case_when(
      IMCC_Individual >= 0.75 ~ "Alineado / Conectado",
      IMCC_Individual < 0.60 & mean(fc_bpm) < 140 ~ "Apatía Demostrada (Haciendo el Cajón)",
      TRUE ~ "Riesgo de Saturación por Comunicación"
    ),
    .groups = "drop"
  )

# Calculamos el índice global del equipo
IMCC_Global_Equipo <- mean(reporte_auditoria$IMCC_Individual)

print("========================================================================")
print("===       REPORTE BIOMÉTRICO-ACÚSTICO DE GESTIÓN DE VESTUARIO        ===")
print("========================================================================")
print(reporte_auditoria)

cat("\n>>> ÍNDICE DE MASA CRÍTICA COLECTIVA GLOBAL (IMCC):", round(IMCC_Global_Equipo * 100, 2), "%\n")
if(IMCC_Global_Equipo < 0.60) {
  cat("🛑 ALERTA DIRECTIVA: El modelo matemático confirma desconexión estructural o insubordinación táctica.\n")
} else if(IMCC_Global_Equipo >= 0.60 & IMCC_Global_Equipo < 0.75) {
  cat("⚠️ INTERVENCIÓN: El psicólogo debe reentrenar los parámetros acústicos y el tono del entrenador.\n")
} else {
  cat("✅ GOBERNABILIDAD ÓPTIMA: Sincronización psico-fisiológica exitosa entre el líder y la plantilla.\n")
}
