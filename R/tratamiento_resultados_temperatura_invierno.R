library("dplyr")
library("ggplot2")
library("lubridate")

setwd("D:/UDFnuevo")
getwd()
data_1cm <- read.table("tempwinter1cm.txt",sep = " ", header = F)
data_05cm <- read.table("tempwinter05cm.txt",sep = " ", header = F)
data_025cm <- read.table("tempwinter025cm.txt",sep = " ", header = F)
data_no_pcm <-read.table("tempwinternopcm.txt", sep= " ", header = F)

data_temp_1cm <- data_1cm %>%
  rename(time_step = V1,
         glass_temp = V2,
         pcm_temp = V3,
         water_temp = V4,
         )

data_temp_1cm$time_step <- data_temp_1cm$time_step * 10

data_temp_05cm <- data_05cm %>%
  rename(time_step = V1,
         glass_temp = V2,
         pcm_temp = V3,
         water_temp = V4,
         )

data_temp_05cm$time_step <- data_temp_05cm$time_step * 10

data_temp_025cm <- data_025cm %>%
  rename(time_step = V1,
         glass_temp = V2,
         pcm_temp = V3,
         water_temp = V4,
         )

data_temp_025cm$time_step <- data_temp_025cm$time_step * 10

data_temp_no_pcm <- data_no_pcm %>%
  rename(time_step = V1,
         glass_temp = V2,
         water_temp = V3,
  )

data_temp_no_pcm$time_step <- data_temp_no_pcm$time_step * 10

data_temp_1cm_filtrado <-  data_temp_1cm %>%
  subset(time_step %% 3600 == 0)
data_temp_05cm_filtrado <-  data_temp_05cm %>%
  subset(time_step %% 3600 == 0)
data_temp_025cm_filtrado <-  data_temp_025cm %>%
  subset(time_step %% 3600 == 0)
data_temp_no_pcm_filtrado <- data_temp_no_pcm %>%
  subset(time_step %% 3600 == 0)

date_1 <- as.Date('2022-04-09')
date_2 <- as.Date('2022-04-10')

# time_1 <- c('9:30','10:00','10:30','11:00','11:30','12:00','12:30',
#             '13:00','13:30','14:00','14:30','15:00','15:30','16:00','16:30',
#             '17:00','17:30','18:00','18:30','19:00','19:30','20:00','20:30',
#             '21:00','21:30','22:00','22:30','23:00','23:30')
# 
# time_2 <- c('00:00','00:30','01:00','01:30','02:00','02:30','03:00','03:30',
#             '04:00','04:30','05:00','05:30','06:00','06:30','07:00','07:30',
#             '08:00','08:30','09:00')

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
data_temp_1cm_tiempo <- cbind(data_temp_1cm_filtrado, formato_hora)
data_temp_05cm_tiempo <- cbind(data_temp_05cm_filtrado, formato_hora)
data_temp_025cm_tiempo <- cbind(data_temp_025cm_filtrado, formato_hora)
data_temp_no_pcm_tiempo <- cbind(data_temp_no_pcm_filtrado, formato_hora)


ggplot() +
  geom_line(aes(x = data_temp_1cm_tiempo$formato_hora, y = data_temp_1cm_tiempo$pcm_temp, colour = 'Agua con PCM de 1 cm'), size = 1.5) +
  geom_point(aes(x = data_temp_1cm_tiempo$formato_hora, y = data_temp_1cm_tiempo$pcm_temp, colour = 'Agua con PCM de 1 cm', shape = 'triangle'), size = 3) +
  geom_line(aes(x = data_temp_no_pcm_tiempo$formato_hora, y = data_temp_no_pcm_tiempo$water_temp, colour = 'Agua sin PCM'), size = 1.5) +
  geom_point(aes(x = data_temp_no_pcm_tiempo$formato_hora, y = data_temp_no_pcm_tiempo$water_temp, colour = 'Agua sin PCM', shape = 'circle'), size = 3) +
  xlab('Tiempo (hr)') +
  ylab('Temperatura (K)') +
  guides(shape="none", size = "none") +
  labs(colour = "Temperaturas") +
  scale_x_datetime(date_labels = '%T',
                   limits = c(as.POSIXct('2022-04-09 10:00:00', tz = 'MST'), 
                              as.POSIXct('2022-04-10 09:00:00', tz = 'MST')), 
                   breaks = '1 hours') +
  scale_y_continuous(breaks = seq(280,350,by=5)) +
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
  scale_color_manual(values = c("red","blue"))

ggplot() +
  geom_line(aes(x = data_temp_05cm_tiempo$formato_hora, y = data_temp_05cm_tiempo$pcm_temp, colour = 'Agua con PCM de 0.5 cm'), size = 1.5) +
  geom_point(aes(x = data_temp_05cm_tiempo$formato_hora, y = data_temp_05cm_tiempo$pcm_temp, colour = 'Agua con PCM de 0.5 cm', shape = 'triangle'), size = 3) +
  geom_line(aes(x = data_temp_no_pcm_tiempo$formato_hora, y = data_temp_no_pcm_tiempo$water_temp, colour = 'Agua sin PCM'), size = 1.5) +
  geom_point(aes(x = data_temp_no_pcm_tiempo$formato_hora, y = data_temp_no_pcm_tiempo$water_temp, colour = 'Agua sin PCM', shape = 'circle'), size = 3) +
  xlab('Tiempo (hr)') +
  ylab('Temperatura (K)') +
  guides(shape="none", size = "none") +
  labs(colour = "Temperaturas") +
  scale_x_datetime(date_labels = '%T',
                   limits = c(as.POSIXct('2022-04-09 10:00:00', tz = 'MST'), 
                              as.POSIXct('2022-04-10 09:00:00', tz = 'MST')), 
                   breaks = '1 hours') +
  scale_y_continuous(breaks = seq(280,350,by=5)) +
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
  scale_color_manual(values = c("red","blue"))

ggplot() +
  geom_line(aes(x = data_temp_025cm_tiempo$formato_hora, y = data_temp_025cm_tiempo$pcm_temp, colour = 'Agua con PCM de 0.25 cm'), size = 1.5) +
  geom_point(aes(x = data_temp_025cm_tiempo$formato_hora, y = data_temp_025cm_tiempo$pcm_temp, colour = 'Agua con PCM de 0.25 cm', shape = 'triangle'), size = 3) +
  geom_line(aes(x = data_temp_no_pcm_tiempo$formato_hora, y = data_temp_no_pcm_tiempo$water_temp, colour = 'Agua sin PCM'), size = 1.5) +
  geom_point(aes(x = data_temp_no_pcm_tiempo$formato_hora, y = data_temp_no_pcm_tiempo$water_temp, colour = 'Agua sin PCM', shape = 'circle'), size = 3) +
  xlab('Tiempo (hr)') +
  ylab('Temperatura (K)') +
  guides(shape="none", size = "none") +
  labs(colour = "Temperaturas") +
  scale_x_datetime(date_labels = '%T',
                   limits = c(as.POSIXct('2022-04-09 10:00:00', tz = 'MST'), 
                              as.POSIXct('2022-04-10 09:00:00', tz = 'MST')), 
                   breaks = '1 hours') +
  scale_y_continuous(breaks = seq(280,350,by=5)) +
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
  scale_color_manual(values = c("red","blue"))
