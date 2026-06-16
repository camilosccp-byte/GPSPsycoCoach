# Catálogo de Palabras Activadoras y Definición de Priors Bayesianos

Este documento establece el puente cuantitativo entre la psicología del deporte (*Self-Talk* conductual) y los parámetros estadísticos del modelo de regresión multinivel. Los valores (*Priors*) aquí descritos se basan en el metaanálisis de Hatzigeorgiadis et al. (2011) y estudios de coherencia cardíaca (Lehrer et al., 2020).

## 1. Taxonomía de las Palabras Activadoras (Triggers)

El psicólogo deportivo y el entrenador acuerdan el uso exclusivo de palabras cortas (monosílabas o bisílabas) divididas en dos grandes familias funcionales para no saturar la carga cognitiva del jugador en competencia.

### A. Dimensión Psicofisiológica (Regulación del Estrés y VFC)
Orientadas a frenar la hiperactivación del sistema nervioso simpático inducida por el miedo a perder el balón o la presión del rival.
- **Palabras Clave Estándar:** *"Respira"*, *"Suelta"*, *"Eje"*, *"Calma"*.
- **Mecanismo Fisiológico:** Activación del nervio vago (freno parasimpático), induciendo arritmia sinusal respiratoria (sincronización FC-RPM).

### B. Dimensión Cognitiva / Instruccional (Foco y Toma de Decisiones)
Orientadas a dirigir la atención hacia estímulos relevantes del entorno táctico, reactivando la función ejecutiva de la corteza prefrontal.
- **Palabras Clave Estándar:** *"Mira"* (foco visual), *"Pasa"* (dirección), *"Cierra"* (bloqueo espacial), *"Línea"* (orden).
- **Mecanismo Fisiológico:** Estabilización de la atención sin necesidad de una caída drástica en las pulsaciones (eficiencia de procesamiento).

---

## 2. Configuración de Distribuciones Previas (Priors Matemáticos)

Para que el modelo Bayesiano funcione con muestras pequeñas (un piloto de pocos jugadores) sin sesgarse por valores atípicos, inyectamos el conocimiento científico acumulado en forma de **Distribuciones Normales Previas: $N(\mu, \sigma)$**, donde $\mu$ es el cambio esperado en Latidos por Minuto (BPM) y $\sigma$ es la incertidumbre/desviación de la literatura.

### Prior 1: Efecto de Palabras Psicofisiológicas (Calma) sobre la FC
La literatura demuestra que una intervención de respiración guiada o anclaje de calma reduce la FC basal de estrés en situaciones de alta presión.
- **Distribución Bayesiana:** $\beta_{\text{Calma}} \sim N(-8, 2)$
- **Interpretación:** Esperamos que el uso de estas palabras reduzca la frecuencia cardíaca en un promedio de **8 BPM** (con un margen de error estricto de $\pm 2$ BPM donde se concentra el 95% de la probabilidad).

### Prior 2: Efecto de Palabras Cognitivas (Instrucción) sobre la FC
Las palabras instruccionales guían el juego pero no buscan relajar al atleta, sino enfocarlo; por ende, las pulsaciones se mantienen altas pero estables.
- **Distribución Bayesiana:** $\beta_{\text{Instrucción}} \sim N(0, 3)$
- **Interpretación:** Esperamos que el impacto neto sobre la frecuencia cardíaca sea de **0 BPM** (cambio nulo en promedio), pero permitimos una variación de $\pm 3$ BPM debido a la intensidad física de la jugada táctica posterior al estímulo.

### Prior 3: Interacción con la Personalidad del Jugador (Modificador de Pendiente)
Introducemos un factor de corrección según el perfil psicológico determinado previamente por el test (DISC / Big Five):
- **Jugador Perfil Estable/Concienzudo frente a palabras de Calma:** El efecto se potencia: $\Delta \mu = -3$ BPM adicionales.
- **Jugador Perfil Dominante frente a palabras de Grito/Agresivas:** Reacciona con activación positiva (coherencia). Si es un perfil Estable, reacciona con picos de pánico: $\beta_{\text{Pánico}} \sim N(+12, 4)$.

---

## 3. Protocolo de Validación en Entrenamiento (El Rol del Psicólogo)

Antes de medir en partidos oficiales con los datos de SoccerMon/GPS, el psicólogo deportivo debe validar estas líneas base en entrenamientos controlados (vínculo de calibración):
1. **Fase de Aislamiento:** El jugador realiza un esfuerzo intermitente hasta alcanzar su zona de alta intensidad ($\ge 85\%$ FC Máx).
2. **Estímulo Estresor:** Se introduce una tarea cognitiva compleja con penalización (ej. duelo 1v1 en espacio reducido con marcador en contra).
3. **Inyección del Trigger:** El entrenador emite la palabra activadora a través de los micrófonos de campo.
4. **Ventana de Registro:** Se aíslan exactamente los **15 segundos posteriores** en la telemetría para medir el cumplimiento de estos *priors*.
