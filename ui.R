# COHHIO_HMIS
# Copyright (C) 2020  Coalition on Homelessness and Housing in Ohio (COHHIO)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details at
# <https://www.gnu.org/licenses/>.

dashboardPage(
    skin = "purple",
    dashboardHeader(title = "Homelessness Prevention Geographic Tool",
                    titleWidth = 425),
    dashboardSidebar(
        width = 425,
        textInput("address",
                  "Enter full address:",
                  width = 425),
        actionButton("go", "Submit", 
            style = "background-color: #7975bf; color: white;border-color: #7975bf;"),
        HTML(paste0(
            "<div class=\"sidebar__logo-wrap\"><span>Made by</span><img src=\"COHHIOlogo_white.png\" 
            alt=\"COHHIO logo\" width=\"80\" height=\"80\"></div>"
        ))
    ),
    dashboardBody(
        tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
        ),
        fluidRow(
        box(
            width = 9,
            uiOutput("Percentile",
                          width = 9),
            uiOutput("Housing",
                          width = 9),
            uiOutput("COVID19",
                          width = 9),
            uiOutput("Equity",
                          width = 9)
        )
    ),
    fluidRow(box(
        uiOutput("instructionsText"),
        title = "Instructions",
        collapsible = TRUE,
        collapsed = FALSE,
        width = 9
    )),
    fluidRow(box(
        uiOutput("aboutText"),
        title = "About",
        collapsible = TRUE,
        collapsed = TRUE,
        width = 9
    )),
    fluidRow(box(
        uiOutput("citationsText"),
        title = "Citations",
        collapsible = TRUE,
        collapsed = TRUE,
        width = 9
    )))
)


