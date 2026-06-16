# Catálogo de Palabras Activadoras y Definición de Priors Bayesianos Multimodales

Este documento establece el puente cuantitativo entre la psicología del deporte (*Self-Talk* conductual), la analítica acústica de la voz del DT (vía Python) y los parámetros estadísticos del modelo de regresión multinivel en R. 

Los valores (*Priors*) se basan en el metaanálisis de Hatzigeorgiadis et al. (2011), estudios de coherencia cardíaca (Lehrer et al., 2020) y métricas de procesamiento de señales de audio (`librosa`).

---

## 1. Taxonomía de las Palabras Activadoras (Triggers)

El psicólogo deportivo y el entrenador acuerdan el uso de palabras cortas divididas en dos grandes familias funcionales para optimizar la carga cognitiva del jugador bajo presión.

### A. Dimensión Psicofisiológica (Regulación del Estrés y VFC)
Orientadas a frenar la hiperactivación del sistema nervioso simpático inducida por el miedo a perder o la presión del rival.
- **Palabras Clave Estándar:** *"Respira"*, *"Suelta"*, *"Eje"*, *"Calma"*.
- **Mecanismo Acústico Ideal:** Frecuencia Fundamental ($F_0$) baja y profunda ($\sim 120-140$ Hz) con alta estabilidad (*Jitter* bajo), actuando como anclaje parasimpático.

### B. Dimensión Cognitiva / Instruccional (Foco y Toma de Decisiones)
Orientadas a dirigir la atención hacia estímulos relevantes del entorno táctico, reactivando la función ejecutiva de la corteza prefrontal.
- **Palabras Clave Estándar:** *"Mira"* (foco visual), *"Pasa"* (dirección), *"Cierra"* (bloqueo espacial), *"Línea"* (orden).
- **Mecanismo Acústico Ideal:** Alta claridad cepstral (MFCC alto), garantizando órdenes limpias e ininteligibles que activen el procesamiento lógico sin disparar el estrés.

---

## 2. Configuración de Distribuciones Previas (Priors Matemáticos)

Inyectamos el conocimiento científico acumulado en forma de **Distribuciones Normales Previas: $N(\mu, \sigma)$** en la librería `brms`, donde $\mu$ representa el cambio esperado en Latidos por Minuto (BPM) o probabilidad de éxito, y $\sigma$ es la incertidumbre de la literatura.

### Prior 1: Efecto del Tono de Voz Agudo ($F_0$) sobre el Pánico
La literatura demuestra que un tono excesivamente agudo (grito del DT por desesperación) correlaciona con la pérdida de coherencia cardíaca en la plantilla.
- **Distribución Bayesiana:** $\beta_{\text{tono\_f0}} \sim N(-0.5, 0.2)$
- **Interpretación:** Esperamos que a medida que el tono de voz del DT suba y se vuelva más agudo, la probabilidad de que el jugador se mantenga en su Zona Óptima se reduzca significativamente (efecto negativo).

### Prior 2: Efecto de la Claridad Táctica (MFCC) sobre la Zona Óptima
Las instrucciones claras reducen el flote atencional y la frustración cognitiva del jugador, estabilizando el ritmo respiratorio (RPM).
- **Distribución Bayesiana:** $\beta_{\text{claridad\_mfcc}} \sim N(0.8, 0.3)$
- **Interpretación:** Esperamos un fuerte impacto positivo. Una orden nítida y comprensible aumenta la probabilidad de mantener al futbolista enfocado y en control de su espacio.

---

## 3. Modulación por Personalidad DISC (Modificadores de Pendiente)

El modelo estadístico ajusta sus predicciones cruzando la acústica con la personalidad del jugador registrada por el psicólogo:
- **Perfil Estable (S) + Tono Agudo ($F_0$ Alto):** El modelo activa un prior penalizador severo $\beta_{\text{Pánico}} \sim N(-1.2, 0.4)$ debido a su baja tolerancia al grito agresivo.
- **Perfil Dominante (D) + Tono Alto ($F_0$ Alto):** El modelo asume sincronización fisiológica útil por reto competitivo, manteniendo el impacto neutral o positivo.
