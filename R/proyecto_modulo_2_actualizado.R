# Proyecto. M?dulo 2.
# Autor: Carlos Alberto ?lvarez Velasco.

library("dplyr")
library("lubridate")
library("ggplot2")
#library("tidyverse")
require(splines)

getwd()
setwd("C:/Users/Carlos Alvarez/Desktop/DemoDay/Modulo2")
game_data <- read.csv(file.choose()) # Usaremos la tabla game_data_exp.

str(game_data) # Tipo de las variables.

game_data_modified <- game_data %>% mutate(Release_Date = mdy(game_data$r.date))
str(game_data_modified) # Se creo el objeto para las fechas.

game_data_modified <- game_data_modified[,-c(4)] # Eliminamos la columna extra de las fechas.
game_data_modified <- game_data_modified %>% rename(Name = name, Console = platform, Company = company, Critics_score = score, Users_score = user_score, Developer = developer, Genre = genre, Number_of_players = players, Number_of_critics = critics, Number_of_users = users)
# Se cambian los nombres de las columnas.

str(game_data_modified) # Se necesita cambiar el tipo de objeto de la puntuación el usuario.

game_data_modified <- game_data_modified %>% mutate(Users_Score = as.numeric(Users_score))
game_data_modified <- game_data_modified[,-c(5)] # Se elimina la columna original.

str(game_data_modified) # Data frame actual

# Histogramas que muestran el promedio de calificaci?n de la critica y los usuarios.

# Gráfica sin normalizar de puntaje de la crítica.

ggplot(game_data_modified, aes(Critics_score)) +
  geom_histogram(col = "black", fill= "red") +
  ggtitle("Critics score by console") +
  xlab("Score") +
  ylab("Times") +
  geom_vline(xintercept = mean(game_data_modified$Critics_score))

# Normalizamos la serie de datos, sacando el cuadrado de cada calificación hecha por la cr?tica.

ggplot(game_data_modified, aes((Critics_score)^2)) +
  geom_histogram(col = "black", fill= "red") +
  ggtitle("Critics score by console") +
  xlab("Score^2") +
  ylab("Times") +
  geom_vline(xintercept = (mean(game_data_modified$Critics_score))^2)

# Sacamos los parámetros para estimar la probailidad.

sd_critics <- sd((game_data_modified$Critics_score)^2)
mean_critics <- (mean(game_data_modified$Critics_score))^2

# Consideramos tres casos donde un juego es bueno a partir de la calificación de usuarios, desde 60, 70 y 80.

prob_critics <- function(c) {
  num <- 1 - pnorm(q = (c)^2, mean = mean_critics, sd = sd_critics)
  cat("The probability of the game being good by the critics, considering the rating", c, "and above as good is:", num)
}

prob_critics(60)
prob_critics(70)
prob_critics(80)

# Gr?fica sin normalizar de puntaje de los usuarios.

ggplot(game_data_modified, aes(Users_Score)) +
  geom_histogram(col = "black", fill= "red") +
  ggtitle("Users score by console") +
  xlab("Score") +
  ylab("Times") +
  geom_vline(xintercept = mean(na.omit(game_data_modified$Users_Score)))

#Normalizamos la serie de datos, sacando el cuadrado de cada calificaci?n hecha por los usuarios.

ggplot(game_data_modified, aes((Users_Score)^2)) +
  geom_histogram(col = "black", fill= "red") +
  ggtitle("Users score by console") +
  xlab("Score^2") +
  ylab("Times") +
  geom_vline(xintercept = (mean(na.omit(game_data_modified$Users_Score))^2))

# Sacamos los parámetros para estimar la probailidad.

sd_users <- sd(na.omit(game_data_modified$Users_Score)^2)
mean_users <- (mean(na.omit(game_data_modified$Users_Score))^2)

# Consideramos tres casos donde un juego es bueno a partir de la calificación de usuarios, desde 6.0, 7.0 y 8.0.

prob_users <- function(c) {
  num <- 1 - pnorm(q = (c)^2, mean = mean_users, sd = sd_users)
  cat("The probability of the game being good by the gamers, considering the rating", c, "and above as good is:", num)
}

prob_users(6.0)
prob_users(7.0)
prob_users(8.0)

# Análisis cualitativo de relación entre el número de usuarios y el puntaje por la compañía.

ggplot(game_data_modified, aes(Number_of_critics,Critics_score)) +
  geom_point() +
  facet_wrap("Company") +
  ggtitle("Critics Score by company") +
  xlab("Number of users") +
  ylab("Score")

game_data_filtered_game_users <- filter(game_data_modified, Number_of_users < 20000) # Se filtraron estos datos ya que es un número grande.
ggplot(game_data_filtered_game_users, aes(Number_of_users,Users_Score)) +
  geom_point() +
  facet_wrap("Company") +
  ggtitle("Users Score by company") +
  xlab("Number of users") +
  ylab("Score")

# Extraemos el a?o de lanzamiento de cada juego.
game_data_modified$Year <- format(game_data_modified$Release_Date, format = "%Y")

# Graficamos la calidad de los juegos a?o tras a?o seg?n la cr?tica.
year_mean <- game_data_modified %>% group_by(Year) %>% summarise(Mean = mean(Critics_score), n = n())
year_mean_filtered <- filter(year_mean, n > 52)
spline_critics <- lm(year_mean_filtered$Mean ~ bs(year_mean_filtered$Year, knots=c(2005, 2015), degree=4.5), data=year_mean_filtered)
plot(year_mean_filtered$Year, year_mean_filtered$Mean, xlab = "Year", ylab = "Critics Score")
i1 <- order(year_mean_filtered$Year)
lines(year_mean_filtered$Year[i1], fitted(spline_critics)[i1], col='red', lwd=2)
abline(lsfit(year_mean_filtered$Year, year_mean_filtered$Mean), lwd=2)

# Graficamos la calidad de los juegos a?o tras a?o seg?n los jugadores.

game_data_users_filtered <- filter(game_data_modified, Number_of_users > 100)
year_mean_users <- game_data_users_filtered %>% group_by(Year) %>% summarise(Mean = mean(Users_Score), n = n())
spline_users <- lm(year_mean_users$Mean ~ bs(year_mean_users$Year, knots=c(2000, 2015), degree=3), data=year_mean_users)
plot(year_mean_users$Year, year_mean_users$Mean, 
     xlab = "Year", ylab = "User Score")
i2 <- order(year_mean_users$Year)
lines(year_mean_users$Year[i2], fitted(spline_users)[i2], col='red', lwd=2)
abline(lsfit(year_mean_users$Year, year_mean_users$Mean), lwd = 2)

# Graficamos la popularidad de los videojuegos a trav?s de los a?os
spline_users_years <- lm(year_mean_users$n ~ bs(year_mean_users$Year, knots=c(2000, 2015), degree=5), data=year_mean_users)
plot(year_mean_users$Year, year_mean_users$n,
     xlab = "Year", ylab = "Number of players")
i3 <- order(year_mean_users$Year)
lines(year_mean_users$Year[i3], fitted(spline_users_years)[i3], col='red', lwd=2)
abline(lsfit(year_mean_users$Year, year_mean_users$n), lwd=2)

