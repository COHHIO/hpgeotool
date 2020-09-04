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
        actionButton("go", "Submit")
    ),
    dashboardBody(
        infoBoxOutput("Housing",
                      width = 6),
        infoBoxOutput("COVID19",
                      width = 6),
        infoBoxOutput("Equity",
                      width = 6),
        infoBoxOutput("Percentile",
                      width = 6),
    )
)


