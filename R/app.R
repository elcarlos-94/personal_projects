## app.R ##

## Dash board para el data set 'mtcars'

library(shiny)
library(shinydashboard)
#install.packages("shinythemes")
library(shinythemes)

## Código original

library("dplyr")
library("lubridate")
library("ggplot2")
library("tidyverse")
require(splines)

getwd()
setwd("C:/Users/Carlos Alvarez/Desktop/DemoDay/Modulo2")
game_data <- read.csv("games-data-exp.csv") # Usaremos la tabla game_data_exp.

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

# Sacamos los parámetros para estimar la probailidad.

sd_critics <- sd((game_data_modified$Critics_score)^2)
mean_critics <- (mean(game_data_modified$Critics_score))^2

# Consideramos tres casos donde un juego es bueno a partir de la calificación de usuarios, desde 60, 70 y 80.

(prob_critics_60 <- 1 - pnorm(q = (60)^2, mean = mean_critics, sd = sd_critics))
(prob_critics_70 <- 1 - pnorm(q = (70)^2, mean = mean_critics, sd = sd_critics))
(prob_critics_80 <- 1 - pnorm(q = (80)^2, mean = mean_critics, sd = sd_critics))

# Sacamos los parámetros para estimar la probailidad.

sd_users <- sd(na.omit(game_data_modified$Users_Score)^2)
mean_users <- (mean(na.omit(game_data_modified$Users_Score))^2)

# Consideramos tres casos donde un juego es bueno a partir de la calificación de usuarios, desde 6.0, 7.0 y 8.0.

(prob_users_60 <- 1 - pnorm(q = (6.0)^2, mean = mean_users, sd = sd_users))
(prob_users_70 <- 1 - pnorm(q = (7.0)^2, mean = mean_users, sd = sd_users))
(prob_users_80 <- 1 - pnorm(q = (8.0)^2, mean = mean_users, sd = sd_users))

# summary(game_data_modified)

# Extraemos el a?o de lanzamiento de cada juego.
game_data_modified$Year <- format(game_data_modified$Release_Date, format = "%Y")

# Graficamos la calidad de los juegos año tras año según la crítica.
year_mean <- game_data_modified %>% group_by(Year) %>% summarise(Mean = mean(Critics_score), n = n())
year_mean_filtered <- filter(year_mean, n > 52)
spline_critics <- lm(year_mean_filtered$Mean ~ bs(year_mean_filtered$Year, knots=c(2005, 2015), degree=4.5), data=year_mean_filtered)

# Graficamos la calidad de los juegos a?o tras a?o seg?n los jugadores.

game_data_users_filtered <- filter(game_data_modified, Number_of_users > 100)
year_mean_users <- game_data_users_filtered %>% group_by(Year) %>% summarise(Mean = mean(Users_Score), n = n())
spline_users <- lm(year_mean_users$Mean ~ bs(year_mean_users$Year, knots=c(2000, 2015), degree=3), data=year_mean_users)


# Graficamos la popularidad de los videojuegos a trav?s de los a?os
spline_users_years <- lm(year_mean_users$n ~ bs(year_mean_users$Year, knots=c(2000, 2015), degree=5), data=year_mean_users)


#Esta parte es el análogo al ui.R
ui <- 
    
    fluidPage(
        
        dashboardPage(
            
            dashboardHeader(title = "Proyecto módulo 2"),
            
            (dashboardSidebar(
                
                sidebarMenu(
                    menuItem("Tabla de datos", tabName = "data_table"),
                    menuItem("Análisis de probabilidad", tabName = "Dashboard"),
                    menuItem("Análisis de tiempo", tabName = "time"),
                    menuItem("Análisis cualitativo", tabName = "graph")
                ))
                
            ),
            
            dashboardBody(
                
                tabItems(
                    
                    tabItem(tabName = "graph",
                            fluidRow(
                                titlePanel(h3("Graficos de popularidad")),
                                box(plotOutput("plot6", height = 300, width = 460)),
                                box(plotOutput("plot7", height = 300, width = 460)),
                            )
                    ),
                    
                    tabItem(tabName = "Dashboard",
                            fluidRow(
                                titlePanel("Frecuency of scores"), 
                                box(plotOutput("plot1", height = 500)),
                                box(plotOutput("plot2", height = 500))
                                )
                    ),
                    
                    tabItem(tabName = "time", 
                            fluidRow(
                                titlePanel(h3("Gráficos de dispersión")),
                                box(plotOutput("plot3", height = 300, width = 460)),
                                box(plotOutput("plot4", height = 300, width = 460)),
                                box(plotOutput("plot5", height = 300, width = 460))
                            )
                    ),
                    
                    
                    
                    tabItem(tabName = "data_table",
                            fluidRow(        
                                titlePanel(h3("Data Table")),
                                dataTableOutput ("data_table")
                            )
                    )
                    
                )
        )
    )
    )
    
    

#De aquí en adelante es la parte que corresponde al server

server <- function(input, output) {
    library(ggplot2)
    
    output$plot1 <- renderPlot({
        
        ggplot(game_data_modified, aes((Critics_score)^2)) +
            geom_histogram(col = "black", fill= "red") +
            ggtitle("Critics score by console") +
            xlab("Score^2") +
            ylab("Times") +
            geom_vline(xintercept = (mean(game_data_modified$Critics_score))^2)
        
    })
    
    output$plot2 <- renderPlot({
        ggplot(game_data_modified, aes((Users_Score)^2)) +
            geom_histogram(col = "black", fill= "red") +
            ggtitle("Users score by console") +
            xlab("Score^2") +
            ylab("Times") +
            geom_vline(xintercept = (mean(na.omit(game_data_modified$Users_Score))^2))
        
    }
    )
    
    output$plot3 <- renderPlot({ 
        
        plot(year_mean_filtered$Year, year_mean_filtered$Mean, xlab = "Year", ylab = "Critics Score", main = "Critics score year by year")
        i1 <- order(year_mean_filtered$Year)
        lines(year_mean_filtered$Year[i1], fitted(spline_critics)[i1], col='red', lwd=2)
        abline(lsfit(year_mean_filtered$Year, year_mean_filtered$Mean), lwd=2)
        
    })
    
    output$plot4 <- renderPlot({
        plot(year_mean_users$Year, year_mean_users$Mean, 
             xlab = "Year", ylab = "User Score", main = "Users score year by year")
        i2 <- order(year_mean_users$Year)
        lines(year_mean_users$Year[i2], fitted(spline_users)[i2], col='red', lwd=2)
        abline(lsfit(year_mean_users$Year, year_mean_users$Mean), lwd = 2)
        
    })
    
    output$plot5 <- renderPlot({
        plot(year_mean_users$Year, year_mean_users$n,
             xlab = "Year", ylab = "Number of players", main = "Gaming popularity year by year")
        i3 <- order(year_mean_users$Year)
        lines(year_mean_users$Year[i3], fitted(spline_users_years)[i3], col='red', lwd=2)
        abline(lsfit(year_mean_users$Year, year_mean_users$n), lwd=2)
    })
    
    output$plot6 <- renderPlot({ggplot(game_data_modified, aes(Number_of_critics,Critics_score)) +
        geom_point() +
        facet_wrap("Company") +
        ggtitle("Critics Score by company") +
        xlab("Number of users") +
        ylab("Score")
    })
    
    output$plot7 <- renderPlot({
    ggplot(game_data_filtered_game_users, aes(Number_of_users,Users_Score)) +
        geom_point() +
        facet_wrap("Company") +
        ggtitle("Users Score by company") +
        xlab("Number of users") +
        ylab("Score")
    })
    
    #Data Table
    output$data_table <- renderDataTable( {game_data_modified}, 
                                          options = list(aLengthMenu = c(5,25,50),
                                                         iDisplayLength = 5)
    )
    
}


shinyApp(ui, server)
