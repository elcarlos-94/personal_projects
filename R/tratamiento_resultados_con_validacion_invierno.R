library("dplyr")
library("ggplot2")
library("lubridate")

setwd("D:/UDFnuevo")
getwd()
data_1cm <- read.table("text-tfwinter1cm.txt",sep = " ", header = F)
data_05cm <- read.table("text-tfwinter05cm.txt",sep = " ", header = F)
data_025cm <- read.table("text-tfwinter025cm.txt",sep = " ", header = F)
data_no_pcm <-read.table("validaciónwinter.txt", sep= " ", header = F)

data_extract <- function(file) {
  file %>% select(V1,V2,V3,V11)
}

data_1cm_extract <- data_extract(data_1cm)
data_05cm_extract <- data_extract(data_05cm)
data_025cm_extract <- data_extract(data_025cm)
data_validacion_extract <- data_no_pcm %>%
  select(V1,V2,V3)

data_1cm_produccion <- data_1cm_extract %>%
  select(V1,V2)
data_1cm_acumulado <- data_1cm_extract %>%
  select(V1,V3)
data_1cm_fraccion_liquido <- data_1cm_extract %>%
  select(V1,V11)

data_05cm_produccion <- data_05cm_extract %>%
  select(V2)
data_05cm_acumulado <- data_05cm_extract %>%
  select(V3)
data_05cm_fraccion_liquido <- data_05cm_extract %>%
  select(V11)

data_025cm_produccion <- data_025cm_extract %>%
  select(V2)
data_025cm_acumulado <- data_025cm_extract %>%
  select(V3)
data_025cm_fraccion_liquido <- data_025cm_extract %>%
  select(V11)

data_no_pcm_produccion <- data_validacion_extract %>%
  select(V2)
data_no_pcm_acumulado <- data_validacion_extract %>%
  select(V3)

data_produccion <- cbind(data_1cm_produccion, data_05cm_produccion, data_025cm_produccion, data_no_pcm_produccion)

names(data_produccion) <- make.names(names(data_produccion), unique = TRUE)

data_produccion <- data_produccion %>%
  rename(tiempo_seg = V1,
         pcm_1cm = V2,
         pcm_05cm = V2.1,
         pcm_025cm = V2.2,
         no_pcm = V2.3)

data_acumulado <- cbind(data_1cm_acumulado, data_05cm_acumulado, data_025cm_acumulado, data_no_pcm_acumulado)

names(data_acumulado) <- make.names(names(data_acumulado), unique = TRUE)

data_acumulado <- data_acumulado %>%
  rename(tiempo_seg = V1,
         pcm_1cm = V3,
         pcm_05cm = V3.1,
         pcm_025cm = V3.2,
         no_pcm = V3.3)

data_fraccion_liquido <- cbind(data_1cm_fraccion_liquido, data_05cm_fraccion_liquido, data_025cm_fraccion_liquido)

names(data_fraccion_liquido) <- make.names(names(data_fraccion_liquido), unique = TRUE)

data_fraccion_liquido <- data_fraccion_liquido %>%
  rename(tiempo_seg = V1,
         pcm_1cm = V11,
         pcm_05cm = V11.1,
         pcm_025cm = V11.2)

data_produccion_filtrado <-  data_produccion %>%
  subset(tiempo_seg %% 1800 == 0)
data_acumulado_filtrado <- data_acumulado %>%
  subset(tiempo_seg %% 1800 == 0)
data_fraccion_liquido_filtrado <- data_fraccion_liquido %>%
  subset(tiempo_seg %% 1800 == 0)

date_1 <- as.Date('2022-04-09')
date_2 <- as.Date('2022-04-10')

time_1 <- c('9:30','10:00','10:30','11:00','11:30','12:00','12:30',
            '13:00','13:30','14:00','14:30','15:00','15:30','16:00','16:30',
            '17:00','17:30','18:00','18:30','19:00','19:30','20:00','20:30',
            '21:00','21:30','22:00','22:30','23:00','23:30')

time_2 <- c('00:00','00:30','01:00','01:30','02:00','02:30','03:00','03:30',
            '04:00','04:30','05:00','05:30','06:00','06:30','07:00','07:30',
            '08:00','08:30','09:00')

time_1 <- c('10:00','11:00','12:00','13:00','14:00','15:00',
            '16:00','17:00','18:00','19:00','20:00','21:00','22:00','23:00')

time_2 <- c('00:00','01:00','02:00','03:00','04:00','05:00','06:00','07:00',
            '08:00','09:00')

format <- "%Y-%m-%d %H:%M"

previous_day <- as.POSIXct(paste(date_1,time_1), format = format)

next_day <- as.POSIXct(paste(date_2,time_2), format = format)

previous_day
next_day

formato_hora <- c(previous_day, next_day)

typeof(formato_hora)
data_produccion_filtrado_tiempo <- cbind(data_produccion_filtrado, formato_hora)
data_acumulado_filtrado_tiempo <- cbind(data_acumulado_filtrado, formato_hora)
data_fraccion_liquido_filtrado_tiempo <- cbind(data_fraccion_liquido_filtrado, formato_hora)
formato_hora

ggplot(data_produccion_filtrado_tiempo) +
  geom_line(aes(x = formato_hora, y = pcm_1cm, colour = 'PCM 1cm'), size = 1.5) +
  geom_point(aes(x = formato_hora, y = pcm_1cm, colour = 'PCM 1cm'), shape = 'square', size = 3) +
  geom_line(aes(x = formato_hora, y = pcm_05cm, colour = 'PCM 0.5cm'), size = 1.5) +
  geom_point(aes(x = formato_hora, y = pcm_05cm, colour = 'PCM 0.5cm', shape = 'triangle'), size = 3) +
  geom_line(aes(x = formato_hora, y = pcm_025cm, colour = 'PCM 0.25cm'), size = 1.5) +
  geom_point(aes(x = formato_hora, y = pcm_025cm, colour = 'PCM 0.25cm', shape = 'circle'), size = 3) +
  geom_line(aes(x = formato_hora, y = no_pcm, colour = 'Sin PCM'), size = 1.5) +
  geom_point(aes(x = formato_hora, y = no_pcm, colour = 'Sin PCM'), shape = 18, size = 3) +
  xlab('Tiempo (hr)') +
  ylab('Producción (kg/m²hr)') +
  guides(shape="none", size = "none") +
  labs(colour = "Grosor de PCM") +
  scale_x_datetime(date_labels = '%T',
                   limits = c(as.POSIXct('2022-04-09 09:00:00', tz = 'MST'), 
                              as.POSIXct('2022-04-10 09:00:00', tz = 'MST')), 
                   breaks = '1 hours') +
  scale_y_continuous(breaks = seq(0,0.2,by=0.01)) +
  theme(
    legend.position = c(.95, .95),
    legend.justification = c("right", "top"),
    legend.box.just = "right",
    legend.margin = margin(8, 8, 8, 8),
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(colour = "black"),
    panel.background = element_blank(),
    axis.text.x = element_text(angle = 90, face = "bold"),
    axis.text.y = element_text(face = "bold")
  ) +
  scale_color_manual(values = c("black","red","blue","green"))

ggplot(data_acumulado_filtrado_tiempo) +
  geom_line(aes(x = formato_hora, y = pcm_1cm, colour = 'PCM 1cm'), size = 1.5) +
  geom_point(aes(x = formato_hora, y = pcm_1cm, colour = 'PCM 1cm'), shape = 'square', size = 3) +
  geom_line(aes(x = formato_hora, y = pcm_05cm, colour = 'PCM 0.5cm'), size = 1.5) +
  geom_point(aes(x = formato_hora, y = pcm_05cm, colour = 'PCM 0.5cm', shape = 'triangle'), size = 3) +
  geom_line(aes(x = formato_hora, y = pcm_025cm, colour = 'PCM 0.25cm'), size = 1.5) +
  geom_point(aes(x = formato_hora, y = pcm_025cm, colour = 'PCM 0.25cm', shape = 'circle'), size = 3) +
  geom_line(aes(x = formato_hora, y = no_pcm, colour = 'Sin PCM'), size = 1.5) +
  geom_point(aes(x = formato_hora, y = no_pcm, colour = 'Sin PCM'), shape = 18, size = 3) +
  xlab('Tiempo (hr)') +
  ylab('Producción (kg/m²hr)') +
  guides(shape="none") +
  labs(colour = "Grosor de PCM") +
  scale_x_datetime(date_labels = '%T',
                   limits = c(as.POSIXct('2022-04-09 09:00:00', tz = 'MST'), 
                              as.POSIXct('2022-04-10 09:00:00', tz = 'MST')), 
                   breaks = '1 hours') +
  scale_y_continuous(breaks = seq(0,1,by=0.1)) + 
  theme(
    legend.position = c(.95, .05),
    legend.justification = c("right", "bottom"),
    legend.box.just = "right",
    legend.margin = margin(8, 8, 8, 8),
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(colour = "black"),
    panel.background = element_blank(),
    axis.text.x = element_text(angle = 90, face = "bold"),
    axis.text.y = element_text(face = "bold")
  ) +
  scale_color_manual(values = c("black","red","blue","green"))

ggplot(data_fraccion_liquido_filtrado) +
  geom_line(aes(x = formato_hora, y = pcm_1cm, colour = 'PCM 1cm'), size = 1.5) +
  geom_point(aes(x = formato_hora, y = pcm_1cm, colour = 'PCM 1cm'), shape = 'square', size = 3) +
  geom_line(aes(x = formato_hora, y = pcm_05cm, colour = 'PCM 0.5cm'), size = 1.5) +
  geom_point(aes(x = formato_hora, y = pcm_05cm, colour = 'PCM 0.5cm', shape = 'triangle'), size = 3) +
  geom_line(aes(x = formato_hora, y = pcm_025cm, colour = 'PCM 0.25cm'), size = 1.5) +
  geom_point(aes(x = formato_hora, y = pcm_025cm, colour = 'PCM 0.25cm', shape = 'circle'), size = 3) +
  xlab('Tiempo (hr)') +
  ylab('Fracción Líquido') +
  guides(shape="none") +
  labs(colour = "Grosor de PCM") +
  scale_x_datetime(date_labels = '%T',
                   limits = c(as.POSIXct('2022-04-09 09:00:00', tz = 'MST'), 
                              as.POSIXct('2022-04-10 09:00:00', tz = 'MST')), 
                   breaks = '1 hours') +
  scale_y_continuous(breaks = seq(0,1,by=0.1)) + 
  theme(
    legend.position = c(.95, .95),
    legend.justification = c("right", "top"),
    legend.box.just = "right",
    legend.margin = margin(8, 8, 8, 8),
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(colour = "black"),
    panel.background = element_blank(),
    axis.text.x = element_text(angle = 90, face = "bold"),
    axis.text.y = element_text(face = "bold")
  ) +
  scale_color_manual(values = c("black","red","blue"))

# Código no utilizado 

#spline_1cm_produccion <- as.data.frame(spline(data_produccion_filtrado$tiempo_seg,data_produccion_filtrado$pcm_1cm))
#spline_05cm_produccion <- as.data.frame(spline(data_produccion_filtrado$tiempo_seg,data_produccion_filtrado$pcm_05cm))
#spline_025cm_produccion <- as.data.frame(spline(data_produccion_filtrado$tiempo_seg,data_produccion_filtrado$pcm_025cm))

#spline_1cm_acumulado <- as.data.frame(spline(data_acumulado_filtrado$tiempo_seg,data_acumulado_filtrado$pcm_1cm))
#spline_05cm_acumulado <- as.data.frame(spline(data_acumulado_filtrado$tiempo_seg,data_acumulado_filtrado$pcm_05cm))
#spline_025cm_acumulado <- as.data.frame(spline(data_acumulado_filtrado$tiempo_seg,data_acumulado_filtrado$pcm_025cm))

#spline_1cm_fraccion_liquido <- as.data.frame(spline(data_fraccion_liquido_filtrado$tiempo_seg,data_fraccion_liquido_filtrado$pcm_1cm))
#spline_1cm_fraccion_liquido[spline_1cm_fraccion_liquido<0] <- 0
#spline_05cm_fraccion_liquido <- as.data.frame(spline(data_fraccion_liquido_filtrado$tiempo_seg,data_fraccion_liquido_filtrado$pcm_05cm))
#spline_05cm_fraccion_liquido[spline_05cm_fraccion_liquido<0] <- 0
#spline_025cm_fraccion_liquido <- as.data.frame(spline(data_fraccion_liquido_filtrado$tiempo_seg,data_fraccion_liquido_filtrado$pcm_025cm))
#spline_025cm_fraccion_liquido[spline_025cm_fraccion_liquido<0] <- 0
