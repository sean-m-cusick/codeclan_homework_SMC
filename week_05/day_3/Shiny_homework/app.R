# Set up --------------------------
library(tidyverse)
library(shiny)
library(shinythemes)
library(CodeClanData)
library(giscoR)
library(sf)
library(DT)
# library(leaflet)
# library(leaflet.extras)

# Data Creation --------------------------
whisky_data <- whisky
whisky_data_spatial <- whisky_data %>% 
    st_as_sf(coords = c("Latitude", "Longitude"), crs = 4326)
scotland <- giscoR::gisco_get_nuts(nuts_id = 'UKM',
                                   resolution = '01')

all_regions <- unique(whisky_data_spatial$Region)
all_distilleries <- unique(whisky_data_spatial$Distillery)

region_palette <- leaflet::colorFactor(
    palette = c(
        "Campbeltown" = "#CD3700",
        "Highlands" = "#BBFFFF",
        "Islay" = "#7CCD7C",
        "Lowlands" = "#FFDAB9",
        "Speyside" = "#912CEE"),
    domain = whisky_data_spatial$Region)


# User Interface BROKE--------------------------
# ui <- fluidPage(
#     theme = shinytheme("darkly"),
#     
#     
#     # Application title
#     titlePanel(tags$h2("Whisky of Scotland")),
#     
    # Sidebar with alt. map, region, distillery, timescale
    
    #     # mainPanel(
    #         tabsetPanel(
    #             tabPanel("Map", 
    #                      fluid = TRUE,
    #                      # plotOutput("map_plot"),
    #                      sidebarLayout(
    #                          sidebarPanel(
    #                                       checkboxGroupInput("region_input",
    #                                                          "Region",
    #                                                          choices = all_regions,
    #                                                          selected = all_regions
    #                                                          ),
    #                                       mainPanel("Map",
    #                                                 plotOutput("map_plot"))
    #                                       )
    #                                    )
    #                      ),
    #             
    #             tabPanel("Distilleries",
    #                      fluid = TRUE,
    #                      # plotOutput("distrillery_plot"),
    #                      sidebarLayout(
    #                          sidebarPanel(
    #                                       checkboxGroupInput("region_input",
    #                                                          "Region",
    #                                                          choices = all_regions,
    #                                                          selected = all_regions),
    #                                       br(),
    #                                       
    #                                       selectInput("distillery_input",
    #                                                   tags$b("Which Distillery?"),
    #                                                   choices = all_distilleries),
    #                                       mainPanel(plotOutput("distrillery_plot"))
    #                                       ),
    #         
    #                                 )
    #                     ),
    #             
    #             tabPanel("Histogram",
    #                      fluid = TRUE,
    #                      # plotOutput("histogram_plot"),
    #                      sidebarLayout(
    #                          sidebarPanel(
    #                                       sliderInput("time_input",
    #                                                   "Year range",
    #                                                   min = 1775,
    #                                                   max = 1993,
    #                                                   value = c(1780, 1990),
    #                                                   width = 1),
    #                                       mainPanel(plotOutput("histogram_plot"))
    #                                     ),
    #                                   )
    #                      ),
    #         
    #             tabPanel("Whisky Notes",
    #                      plotOutput("flavour_plot")
    #             ),
    #             
    #             tabPanel("About",
    #                      tags$a("Author: Seàn M. Cusick",
    #                             href = "http://riomhach.co.uk//")
    #             
    #                     )
    #             )
    #     # )
    # )
    

# User Interface --------------------------
ui <- fluidPage(
    theme = shinytheme("darkly"),
    
    
    # Application title
    titlePanel(tags$h2("Whisky of Scotland")),
    
    # Sidebar with alt. map, region, distillery, timescale
    sidebarLayout(

        sidebarPanel(position = "left",
                     # select all, doesn't work
                     # actionLink("selectall","Select All"),
                     checkboxGroupInput("region_input",
                               "Region",
                               choices = all_regions,
                               selected = all_regions
                               ),

                    br(),

                    selectInput("distillery_input",
                         tags$b("Which Distillery?"),
                         choices = all_distilleries
                         ),
                    ),

    tabsetPanel(
        tabPanel("Map",
                 plotOutput("map_plot")
                 ),
        tabPanel("Distilleries",
                 textOutput("selected_distillery"),
                 plotOutput("output_table")
                ),
                    
        # tabPanel("Histogram",
        #          sliderInput("time_input",
        #                 "Year range",
        #                 min = 1775,
        #                 max = 1993,
        #                 value = c(1780, 1990),
        #                 width = 500),
        #          plotOutput("histogram_plot")
        #         ),
        tabPanel("Whisky Notes",
                 plotOutput("flavour_plot")
                ),
        tabPanel("About",
                 tags$a("Author: Seàn M. Cusick",
                    href = "http://riomhach.co.uk//")
                ),
                # tabPanel("Map",
                #          checkboxInput("map_type",
                #                        "Interactive map",
                #                        value = FALSE),
                #          plotOutput("map_plot")
                #          #leafletOutput("map_plot")
                #          ),
                # tabPanel("Interactive Map",
                #          checkboxInput("map_type",
                #                        "Interactive map",
                #                        value = TRUE),
                #          leafletOutput("map_plot")
                # ),
            )
        )
    )






# Server --------------------------
server <- function(input, output) {
    
# 
#     output$histogram_plot <- renderPlot(
#         ggplot(data = whisky_data_spatial,
#                 aes(whisky_data_spatial$YearFound)) +
#                 geom_histogram(breaks=seq(20, 50, by=2), 
#                                            col="red" 
#                                            ) +
#             scale_fill_gradient("Count", low="green", high="red")
#         )
    
    # select all button - DOESN'T WORK
    # observe({
    #     if(input$selectall == 0) return(NULL) 
    #     else if (input$selectall%%2 == 0)
    #     {
    #         updateCheckboxGroupInput(session,
    #                                  "region_input",
    #                                  "Region",
    #                                  choices = all_regions)
    #     }
    #     else
    #     {
    #         updateCheckboxGroupInput(session,"region_input",
    #                                  "Region",
    #                                  choices = all_regions,
    #                                  selected=campaigns_list)
    #     }
    # })
    
    output$selected_distillery <- renderText({
       paste("You selected", input$distillery_input)
        })
    
    distillery_input <- eventReactive(input$selected_distillery,{
        
        distillery_input <- filter(whisky_data_spatial, colnames(whisky_data_spatial=input$selected_distillery))
        return(distillery_input)
    })
    
    output$table <- renderDT({
        distillery_input()
    })
    
    # output$map_plot <- renderPlot({
    #     
    #     if(input$map_type == FALSE){
    #         
    #         ggplot() +
    #             geom_sf(data = scotland, fill = NA, color = "gray45") + # borders of Scotland
    #             geom_sf(data = whisky_data_spatial, pch = 4, color = "red") + # the distilleries
    #             theme_void() +
    #             labs(title = "Whisky of Scotland") +
    #             theme(plot.title = element_text(hjust = 1/2))
    #     } else {
    #         leaflet(whisky_data_spatial) %>% 
    #             addProviderTiles("Stamen.Toner") %>% 
    #             addCircleMarkers(radius = 10,
    #                              fillOpacity = 0.7,
    #                              stroke = FALSE,
    #                              color = region_palette(
    #                                  whisky_data_spatial$Region),
    #             )
    #     }
    output$map_plot <- renderPlot({
        

        whisky_data_spatial %>% 
            # filter(Distillery %in% Region) %>% 
            filter(whisky_data_spatial$Region == input$region_input)
            ggplot() +
                    geom_sf(data = scotland, fill = NA, color = "gray45") + # borders of Scotland
                    geom_sf(data = whisky_data_spatial, pch = 4, color = "red") + # the distilleries
                    theme_void() +
                    labs(title = "Whisky of Scotland") +
                    theme(plot.title = element_text(hjust = 1/2))
            
                
    })
    
    
    output$flavour_plot <- renderPlot({
        
        whisky_data_spatial %>%
            filter(Distillery == input$distillery_input) %>%
            ggplot() +
            aes(x = intensity, y = note) +
            geom_segment(aes(x = x,
                             xend = x,
                             y = 0,
                             yend = y),
                         color = "gray",
                         lwd = 1.5) +
            geom_point(size = 4,
                       pch = 21,
                       bg = 4,
                       col = 1) +
            scale_x_discrete(labels = c("Capacity",
                                        "Body",
                                        "Sweetness",
                                        "Smoky",
                                        "Medicinal",
                                        "Tobacco",
                                        "Honey",
                                        "Spicy",
                                        "Winey",
                                        "Nutty",
                                        "Malty",
                                        "Fruity",
                                        "Floral"))
            coord_flip()

    })
    
}


# Run App --------------------------
shinyApp(ui = ui, server = server)
