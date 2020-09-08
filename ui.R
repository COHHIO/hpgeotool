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
    dashboardHeader(title = "ERA Prioritization Tool"),
    dashboardSidebar(
        textInput("address",
                  "Enter full address:"),
        actionButton("go", "Submit"),
        width = 300
    ),
    dashboardBody(fluidRow(
        box(
            title = "Indices Within Your State",
            width = 6,
            uiOutput("Percentile",
                          width = 6),
            uiOutput("Housing",
                          width = 6),
            uiOutput("COVID19",
                          width = 6),
            uiOutput("Equity",
                          width = 6)
        )
    ),
    fluidRow(box(
        uiOutput("instructionsText"),
        title = "Instructions",
        collapsible = TRUE,
        collapsed = FALSE,
        width = 6
    )),
    fluidRow(box(
        uiOutput("aboutText"),
        title = "About",
        collapsible = TRUE,
        collapsed = TRUE,
        width = 6
    )),
    fluidRow(box(
        uiOutput("citationsText"),
        title = "Citations",
        collapsible = TRUE,
        collapsed = TRUE,
        width = 6
    )))
)


