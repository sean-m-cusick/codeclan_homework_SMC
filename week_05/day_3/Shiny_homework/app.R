# Set up --------------------------
library(tidyverse)
library(shiny)
library(shinythemes)
library(CodeClanData)
library(giscoR)
library(sf)

# Data Creation --------------------------
whisky_data <- whisky
whisky_data_spatial <- whisky_data %>% 
    st_as_sf(coords = c("Latitude", "Longitude"), crs = 4326)
scotland <- giscoR::gisco_get_nuts(nuts_id = 'UKM',
                                   resolution = '01')
region_palette <- leaflet::colorFactor(
    palette = c(
        "Campbeltown" = "#CD3700",
        "Highlands" = "#BBFFFF",
        "Islay" = "#7CCD7C",
        "Lowlands" = "#FFDAB9",
        "Speyside" = "#912CEE"),
    domain = whisky_data_spatial$Region)


# User Interface --------------------------
ui <- fluidPage(
    theme = shinytheme("darkly"),
    
    
    
    # Application title
    titlePanel(tags$h2("Whisky of Scotland")),
    
    # Sidebar with two radio buttons 
    sidebarLayout(
        
        sidebarPanel(
            
            checkboxGroupInput("region_input",
                               "Region",
                               choices = c(whisky_data_spatial$Region)
                               ),
            
            radioButtons("season_input",
                         tags$b("Which Season?"),
                         choices = c("Summer", "Winter")
                         ),
            
            radioButtons("medal_input",
                         tags$b("Which type of medal?"),
                         choices = c("Bronze", "Silver", "Gold")
                        )
        ),
        
        
        mainPanel(
            tabsetPanel(
                tabPanel("Map",
                         plotOutput("map_plot")
                         ),
                tabPanel("Distilaries",
                         plotOutput("distilary_plot")
                ),
                tabPanel("Histogram",
                         plotOutput("histogram_plot")
                ), 
                tabPanel("Whisky Notes",
                         plotOutput("flavour_plot")
                ),
                tabPanel("About",
                         tags$a("Author: Seàn M. Cusick",
                                href = "http://riomhach.co.uk//")
                ),
                
            )
        )
    )
)





# Server --------------------------
server <- function(input, output) {
    output$map_plot_gg <- renderPlot({
        
        ggplot() +
            geom_sf(data = scotland, fill = NA, color = "gray45") + # borders of Scotland
            geom_sf(data = whisky_data_spatial, pch = 4, color = "red") + # the distilleries
            theme_void() +
            labs(title = "Whisky of Scotland") +
            theme(plot.title = element_text(hjust = 1/2))
                
            
    })
    
    output$map_plot_leaflet <- renderPlot({
        
        leaflet(whisky_data_spatial) %>% 
            addProviderTiles("Stamen.Toner") %>% 
            addCircleMarkers(radius = 10,
                             fillOpacity = 0.7,
                             stroke = FALSE,
                             color = region_palette(
                                 whisky_data_spatial$Region),
            )
        
        
    })
    
    output$medal_plot <- renderPlot({
        
        olympics_overall_medals %>%
            filter(team %in% c("United States",
                               "Soviet Union",
                               "Germany",
                               "Italy",
                               "Great Britain")) %>%
            filter(medal == input$medal_input) %>%
            filter(season == input$season_input) %>%
            ggplot() +
            aes(x = team, y = count, fill = medal, colour = "#000000") +
            geom_col( show.legend = FALSE) +
            theme_minimal() +
            labs(title = "Number of medals") +
            labs(x = "\nTeam",
                 y = "Count") + 
            scale_fill_manual(
                values = c(
                    "Bronze" = "#CD6839", #sienna3
                    "Silver" = "#E0EEEE", #azure2,
                    "Gold" = "#FFD700" #gold
                )
            )
    })
    
}


# Run App --------------------------
shinyApp(ui = ui, server = server)
