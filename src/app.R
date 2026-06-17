if (!require("remotes")) { install.packages("remotes") }
remotes::install_github("jcrodriguez1989/heyshiny", dependencies = TRUE)

# ==============================================================================
# PROYECTO: Fútbol Biometric Analytics
# SCRIPT: app.R (Versión Avanzada con Control de Voz + Módulo DISC)
# OBJETIVO: Captura de triggers en tiempo real por voz y modulación psicológica
# ==============================================================================

library(shiny)
library(shinydashboard)
library(tidyverse)
library(ggiraph)
library(ggforce)
library(heyshiny) # Biblioteca para reconocimiento de voz por API de Navegador

# 1. INTERFAZ DE USUARIO (UI)
ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "Fútbol Biometric AI"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Panel de Campo (Voz)", tabName = "dashboard", icon = icon("microphone")),
      menuItem("Perfiles DISC Plantilla", tabName = "disc_tab", icon = icon("id-card"))
    ),
    selectInput("select_jugador", "Jugador Evaluado:", 
                choices = paste0("Jugador_", sprintf("%02d", 1:11)), selected = "Jugador_02")
  ),
  
  dashboardBody(
    # Inicialización del motor de reconocimiento de voz (Configurado en Español)
    useHeyshiny(language = "es-ES"),
    
    tags$head(tags$style(HTML("
      .content-wrapper { background-color: #111111 !important; }
      .box { background-color: #1a1a1a !important; border-top-color: #444 !important; color: white; }
      h3, h4, .control-label, p { color: white !important; }
    "))),
    
    tabItems(
      # TAB PRINCIPAL: CAPTURA EN TIEMPO REAL
      tabItem(tabName = "dashboard",
        fluidRow(
          # Tarjeta del perfil psicológico actual del jugador seleccionado
          valueBoxOutput("box_disc", width = 4),
          valueBoxOutput("box_umbral_ajustado", width = 4),
          valueBoxOutput("box_estado_psico", width = 4)
        ),
        
        fluidRow(
          # CONTROLES DE ENTRADA (HÍBRIDO: VOZ Y TEXTO MANUAL)
          box(
            title = "🎙️ Consola de Captura de Triggers (Psicólogo)", 
            status = "danger", solidHeader = TRUE, width = 6,
            p("Presiona el botón de voz y di una palabra activadora (ej: 'Respira', 'Mira', 'Suelta') o escríbela manualmente."),
            
            # Entrada de Voz Interactiva
            speechInput("voz_input", label = "Dictado por Voz Activo:"),
            
            hr(),
            # Entrada de Texto Manual de Fallback (Por seguridad si hay mucho ruido de estadio)
            textInput("manual_input", "Entrada Manual Rápida:", value = ""),
            actionButton("btn_enviar_manual", "Registrar Palabra", class = "btn-success"),
            
            hr(),
            h4("Último Trigger Registrado con Éxito:"),
            verbatimTextOutput("consola_log")
          ),
          
          # BITÁCORA DINÁMICA
          box(
            title = "📜 Historial de Intervenciones en esta Sesión", 
            status = "primary", solidHeader = TRUE, width = 6,
            tableOutput("tabla_bitacora")
          )
        ),
        
        fluidRow(
          box(
            title = "Mapa de Control Espacial (Voronoi) y Densidad Cardíaca", 
            status = "info", solidHeader = TRUE, width = 12,
            girafeOutput("mapa_interact")
          )
        )
      ),
      
      # TAB DE DOCUMENTACIÓN DISC
      tabItem(tabName = "disc_tab",
        fluidRow(
          box(
            title = "Ajuste de Umbrales Fisiológicos según el Modelo DISC", 
            status = "warning", solidHeader = TRUE, width = 12,
            p("El psicólogo del deporte calibra los límites de pánico porque la personalidad dicta la tolerancia al estrés:"),
            tags$ul(
              tags$li("Dominante (Competitivo): Soporta alta presión física. Umbral base +5 BPM."),
              tags$li("Influyente (Entusiasta): Reactivo al entorno. Umbral estándar (175 BPM)."),
              tags$li("Estable (Soporte/Seguridad): Requiere calma. Sensible al grito. Umbral reducido -5 BPM (Bloqueo temprano)."),
              tags$li("Concienzudo (Analítico): Se enfoca con instrucciones claras. Umbral estándar.")
            )
          )
        )
      )
    )
  )
)

# 2. LÓGICA DEL SERVIDOR (SERVER)
server <- function(input, output, session) {
  
  # Base de datos reactiva interna para simular la bitácora que se va llenando EN VIVO
  bitacora_en_vivo <- reactiveVal(
    tibble(Timestamp = as.POSIXct(character()), Jugador = character(), Palabra = character(), Tipo = character())
  )
  
  # REACTIVO: Modulación del umbral por perfil DISC (Tu Corollary Metodológico)
  umbral_ajustado <- reactive({
    df_jugador <- datos_integrados %>% filter(jugador_id == input$select_jugador) %>% head(1)
    perfil <- df_jugador$perfil_disc
    
    # Ajustamos matemáticamente el límite de pánico según su personalidad
    umbral_base <- 175
    if (perfil == "Dominante")   return(umbral_base + 5)
    if (perfil == "Estable")     return(umbral_base - 5)
    return(umbral_base)
  })
  
  # FUNCIÓN CENTRAL: Registrar la palabra en la bitácora con su Timestamp exacto
  registrar_evento <- function(palabra) {
    if(palabra == "" || is.na(palabra)) return()
    
    palabra_limpia <- str_to_title(trimws(palabra))
    
    # Clasificación automática basada en el catálogo de teoría (Fase 1)
    tipo <- if_else(palabra_limpia %in% c("Respira", "Suelta", "Calma"), "Psicofisiológica (Calma)", "Cognitiva (Instrucción)")
    
    nuevo_registro <- tibble(
      Timestamp = Sys.time(),
      Jugador = input$select_jugador,
      Palabra = palabra_limpia,
      Tipo = tipo
    )
    
    # Acumulamos en la base de datos reactiva
    bitacora_en_vivo(bind_rows(nuevo_registro, bitacora_en_vivo()))
  }
  
  # DISPARADOR 1: Captura automática por RECONOCIMIENTO DE VOZ
  observeEvent(input$voz_input, {
    registrar_evento(input$voz_input)
  })
  
  # DISPARADOR 2: Captura por BOTÓN MANUAL (Garantía ante ruido extremo)
  observeEvent(input$btn_enviar_manual, {
    registrar_evento(input$manual_input)
    updateTextInput(session, "manual_input", value = "") # Limpiar input
  })

observe({
    minuto_actual <- input$minuto_partido
    marcador_favorable <- TRUE # Simulación de que el equipo va ganando el partido
    
    # Extraemos la frecuencia cardíaca instantánea actual de toda la línea de defensas
    defensas_fc <- datos_integrados %>% 
      filter(posicion %in% c("DFC", "LI", "LD") & timestamp == max(timestamp)) %>% 
      pull(fc_bpm)
    
    # Activación: Ventana crítica del rival (Minuto 75 en adelante) defendiendo resultado
    if (minuto_actual >= 75 && marcador_favorable == TRUE) {
      
      # Contamos cuántos de nuestros defensas superan el nivel de fatiga mental (170 BPM)
      defensas_saturados <- sum(defensas_fc > 170)
      
      # Si la masa crítica defensiva está en pánico (2 o más jugadores), lanzar aviso
      if (defensas_saturados >= 2) {
        showNotification(
          ui = paste("🚨 ALERTA TÁCTICA BANQUILLO (Min", minuto_actual, "): Desgaste cognitivo defensivo.",
                     "Riesgo crítico de desatención posicional ante tendencias del rival."),
          type = "error", 
          duration = 10, 
          closeButton = TRUE
        )
      }
    }
  })
  
  # OUTPUTS DE RENDIMIENTO Y TARJETAS
  output$box_disc <- renderValueBox({
    df_jugador <- datos_integrados %>% filter(jugador_id == input$select_jugador) %>% head(1)
    valueBox(df_jugador$perfil_disc, "Perfil Psicológico DISC", icon = icon("user"), color = "blue")
  })
  
  output$box_umbral_ajustado <- renderValueBox({
    valueBox(paste(umbral_ajustado(), "BPM"), "Umbral de Pánico Adaptado", icon = icon("heartbeat"), color = "yellow")
  })
  
  output$box_estado_psico <- renderValueBox({
    # Evaluamos dinámicamente si el jugador promedio de la sesión excede su umbral modulado
    df_mean <- datos_integrados %>% filter(jugador_id == input$select_jugador) %>% summarise(m = mean(fc_bpm))
    estado <- if_else(df_mean$m > umbral_ajustado(), "Bloqueo / Estrés", "Zona Eficiente")
    col <- if_else(estado == "Zona Eficiente", "green", "red")
    valueBox(estado, "Diagnóstico en Sesión", icon = icon("brain"), color = col)
  })
  
  output$consola_log <- renderText({
    df <- bitacora_en_vivo()
    if(nrow(df) == 0) return("Esperando palabras activadoras...")
    paste0("[", format(df$Timestamp[1], "%H:%M:%S"), "] -> '", df$Palabra[1], "' (", df$Tipo[1], ")")
  })
  
  output$tabla_bitacora <- renderTable({
    bitacora_en_vivo() %>% mutate(Timestamp = format(Timestamp, "%H:%M:%S"))
  })
  
  # RENDERIZADO DEL MAPA CON INTERACTIVIDAD VORONOI
  output$mapa_interact <- renderGirafe({
    df_jugador <- datos_integrados %>% filter(jugador_id == input$select_jugador)
    df_estres <- df_jugador %>% filter(fc_bpm >= umbral_ajustado())
    muestra_instante <- datos_integrados %>% filter(timestamp == max(timestamp))
    
    p <- ggplot() +
      annotate("rect", xmin = 0, xmax = 100, ymin = 0, ymax = 64, fill = "#112213", color = "white", size = 1) +
      annotate("segment", x1 = 50, x2 = 50, y1 = 0, y2 = 64, color = "white", size = 0.8) +
      geom_voronoi_segment(data = muestra_instante, aes(x = coord_x, y = coord_y), color = "#444444", linetype = "dashed") +
      stat_density_2d(data = df_estres, aes(x = coord_x, y = coord_y, fill = ..level..), geom = "polygon", alpha = 0.2, bins = 5) +
      scale_fill_viridis_c(option = "plasma") +
      theme_void() + theme(plot.background = element_rect(fill = "#1a1a1a", color = NA), legend.position = "none")
    
    girafe(ggobj = p)
  })
}

shinyApp(ui = ui, server = server)
