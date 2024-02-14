library(shiny)
library(leaflet)
library(sf)
library(shinycustomloader)
library(shinydashboard)
library(shinyWidgets)
library(DT)

data=st_read("CA_ZIP.shp")

colnames(data)[1]="ZCTA5CE10"
colnames(data)[2]="CREDIT_SCO"
colnames(data)[3]="Owner.occu"
colnames(data)[4]="Owner.occu.1"
colnames(data)[5]="MONTHLY.OW"
colnames(data)[6]="Owner.occu.2"
colnames(data)[7]="Owner.occu.3"
colnames(data)[8]="DB_Estim_5"
colnames(data)[9]="second.mor"
colnames(data)[10]="Total.Cost"

data <- st_transform(data, "+proj=longlat +datum=WGS84")

ui <- dashboardPage(
  dashboardHeader(title = "California Data", titleWidth = 300),
  dashboardSidebar(width = 0),
  dashboardBody(
    tags$head(
      tags$style(HTML("
        .custom-popup {
          width: 200px; /* Ancho deseado */
          height: 100px; /* Alto deseado */
          font-size: 12px; /* Tamaño de fuente deseado */
          overflow: auto; /* Agregar barra de desplazamiento si el contenido es demasiado largo */
          white-space: normal; /* Permitir que el texto se ajuste automáticamente al ancho */
          text-overflow: ellipsis; /* Mostrar puntos suspensivos si el texto desborda el contenedor */
          /* Otros estilos personalizados aquí */
        }
      "))
    ),
    fluidPage(
      titlePanel("California Data", windowTitle = "California Data"),
      splitLayout(
        cellWidths = c("70%", "30%"),
        withLoader(leafletOutput("mapa", height = "100vh")),
        DT::dataTableOutput("tabla", height = "100vh")
      )
    )
  )
)

server <- function(input, output) {
  output$mapa <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addPolygons(data = data, 
                  popup = ~paste0("<div class='custom-popup'>",
                                  "ZCTA5CE10: ", ZCTA5CE10, "<br>",
                                  "Credit Score (Unit - Points): ", CREDIT_SCO, "<br>",
                                  "Owner occupied (Housing units): ", Owner.occu, "<br>",
                                  "Total housing (Housing units): ", Owner.occu.1, "<br>",
                                  "Total house : ", MONTHLY.OW,"$", "<br>",
                                  "Monthly owner: ", Owner.occu.2,"$", "<br>",
                                  "Owner-occupied with a mortgage (Housing units): ", Owner.occu.3, "<br>",
                                  "Housing with a mortgage: ", DB_Estim_5,"$", "<br>",
                                  "Housing with a second mortgage (Housing units): ", second.mor, "<br>",
                                  "</div>"))
  })
  
  output$tabla <- DT::renderDataTable({
    data.frame("ZCTA5CE10" = data$ZCTA5CE10,
               "Credit Score" = paste0(data$CREDIT_SCO,"Unit - Points"),
               "Owner occupied" = paste0(data$Owner.occu,"Housing units"),
               "Total housing" = paste0(data$Owner.occu.1,"Housing units"),
               "Total house" = paste0(data$MONTHLY.OW,"$"),
               "Monthly owner" = paste0(data$Owner.occu.2,"$"),
               "Owner-occupied with a mortgage" = paste0(data$Owner.occu.3,"Housing units"),
               "Housing with a mortgage" = paste0(data$DB_Estim_5,"$"),
               "Housing with a second mortgage" = paste0(data$second.mor,"Housing units"))
  }, options = list(pageLength = 19))
}

shinyApp(ui = ui, server = server)