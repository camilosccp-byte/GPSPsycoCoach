# Metodología de Auditoría Psico-Biométrica, Inteligencia Acústica y Compatibilidad de Liderazgo (Fase 2 - Actualizado)

Este documento detalla la estructura científica y estadística para evaluar el impacto del estilo de liderazgo del entrenador, el desempeño del psicólogo deportivo y el índice de cohesión de la plantilla utilizando telemetría, analítica de voz multimodal y modelos avanzados.

---

## 1. El Dilema de la Responsabilidad: Criterios Acústico-Biométricos

Para determinar de manera objetiva ante la junta directiva si el bajo rendimiento es responsabilidad del Director Técnico o si la plantilla está ejecutando una insubordinación pasiva ("hacer el cajón"), el sistema cruza los biomarcadores acústicos del micrófono del DT (procesados en Python vía `librosa`) con la respuesta autonómica del jugador (FC/RPM en R):

### Escenario A: Saturación Fisiológica por Defecto del Líder (Culpa del DT)
- **Métricas Acústicas de Voz (Python):** Elevada inestabilidad del tono (*Jitter* crítico), frecuencia fundamental ($F_0$) agudizada de forma persistente (indicador de grito por desesperación) y baja claridad cepstral (MFCC), lo que significa órdenes ininteligibles debido al ruido o la ira.
- **Respuesta Biométrica del Jugador (R):** Picos masivos de hiperactivación (FC > 180 BPM) y caída drástica de la Variabilidad de la Frecuencia Cardíaca (VFC), especialmente en perfiles sensibles.
- **Dictamen Técnico:** El estilo de comunicación del entrenador satura el sistema nervioso del jugador, anulando la corteza prefrontal y provocando un bloqueo cognitivo (*choking*). El problema es el emisor.

### Escenario B: Insubordinación Pasiva Demostrada (El "Cajón" Científico)
- **Métricas Acústicas de Voz (Python):** Frecuencia fundamental ($F_0$) estable y profunda (firmeza), alta claridad cepstral (MFCC - instrucciones tácticas limpias) y variaciones tonales cálidas de motivación.
- **Respuesta Biométrica del Jugador (R):** Respuesta autonómica plana. La frecuencia cardíaca y respiratoria del jugador no muestran ninguna reactividad ni sincronización ante los estímulos o palabras clave del DT, manteniéndose estáticas o variando únicamente por la fatiga física del sprint.
- **Dictamen Técnico:** Desconexión psicológica intencional y absoluta del grupo. El mensaje del líder es metodológica y acústicamente óptimo, pero la plantilla ha decidido ignorar la instrucción. El fenómeno del "cajón" queda evidenciado con datos duros.

---

## 2. Matriz de Compatibilidad Acústica según el Perfil DISC

El algoritmo Bayesiano no evalúa los estímulos del entrenador de forma universal. La literatura en *Sport Science* demuestra que la personalidad del jugador dicta su "Zona de Funcionamiento Óptimo" (ZOF) ante la intensidad de la voz:

| Perfil DISC del Jugador | Estilo Acústico del DT | Respuesta Biométrica Esperada (Prior) | Compatibilidad Inicial | Actionable para el Psicólogo |
| :--- | :--- | :--- | :--- | :--- |
| **Dominante (D)** | Alta intensidad (Fuerte), Tono firme y directo | Sincronización rápida, FC reactiva útil (Activación óptima) | **Alta (Reto)** | Permitir que el DT use un tono fuerte y directo con este perfil. |
| **Influyente (I)** | Tonalidad cálida, Expresividad variable, Elogios | Estabilización de VFC por validación emocional | **Alta (Soporte)** | Capacitar al DT para usar variaciones tonales empáticas al corregir a este jugador. |
| **Estable (S)** | Volumen modéré, Tono bajo, Estabilidad absoluta | Hiperactivación inmediata y pánico ante gritos agudos | **Muy Baja (Riesgo)** | **ALERTA:** Prohibir gritos del DT a este jugador. Exigir palabras de calma en tono pausado. |
| **Concienzudo (C)** | Claridad máxima (MFCC alto), Tonos neutros | Estabilización respiratoria (RPM) por orden cognitivo | **Alta (Lógica)** | Evitar discursos emotivos. El DT debe dar datos espaciales y órdenes tácticas precisas. |

---

## 3. Fundamento Estadístico: El Índice de Masa Crítica Colectiva (IMCC)

En lugar de utilizar un porcentaje de aceptación clásico (como un 75% arbitrario) que falla en muestras pequeñas (plantillas de 25 jugadores), el software utiliza el **Análisis de Clases Latentes Bayesiano (LCA)**. Este modelo calcula la probabilidad posterior de que cada jugador pertenezca a la clase *Alineado* basándose en la interacción: `perfil_disc * tono_f0 + claridad_mfcc`.

$$IMCC = \frac{1}{N} \sum_{i=1}^{N} P(\text{Jugador}_i = \text{Alineado} \mid \text{Biometría} + \text{Acústica} + \text{DISC})$$

### Umbrales Estadísticos de Decisión Institucional:
- **IMCC $\ge$ 0.75 (Gobernabilidad Sostenible):** El cuerpo técnico posee el control psicofisiológico del grupo. Existe la masa crítica necesaria para ejecutar el modelo de juego bajo presión.
- **0.60 $\le$ IMCC < 0.75 (Intervención de Emergencia del Psicólogo):** Existen cortocircuitos de comunicación en subgrupos específicos (ej. el DT le grita a perfiles Estables). El psicólogo debe intervenir auditando los entrenamientos y reentrenando la voz del entrenador.
- **IMCC < 0.60 (Ruptura Estructural / Inviabilidad Financiera):** El entrenador ha perdido la capacidad de regular u optimizar el estado emocional de la plantilla. Continuar con el proceso devaluará los activos económicos del club (los jugadores) y destruirá el rendimiento deportivo.
