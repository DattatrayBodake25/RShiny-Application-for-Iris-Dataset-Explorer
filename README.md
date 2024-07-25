# RShiny-Application-for-Iris-Dataset-Explorer

# Iris Dataset Explorer

## Overview

The Iris Dataset Explorer is an interactive Shiny application that allows users to explore the famous Iris dataset. The app provides various filtering options and visualizations to help users gain insights into the dataset's characteristics. Features include scatter plots, histograms, box plots, pair plots, summary statistics, and 3D scatter plots.

## Features

- **Filters**: Allows users to filter the dataset by species and different attributes (Sepal Length, Sepal Width, Petal Length, Petal Width).
- **Scatter Plot**: Visualizes the relationship between two selected variables with color-coded species.
- **Histogram**: Displays the distribution of a selected variable.
- **Box Plot**: Shows the distribution of a selected variable across different species.
- **Pair Plot**: Provides a matrix of scatter plots for all pairs of selected variables.
- **Summary Statistics**: Displays basic statistics of the filtered dataset.
- **3D Scatter Plot**: Enables 3D visualization of the dataset with selectable x, y, and z axes.

## Installation

To run this application locally, you'll need to have R installed along with the required packages. Follow these steps:

1. **Install R**: Download and install R from [CRAN](https://cran.r-project.org/).

2. **Install RStudio** (optional but recommended): Download and install RStudio from [RStudio](https://www.rstudio.com/).

3. **Install Required Packages**: Open R or RStudio and run the following commands to install the necessary packages:

    ```r
    if (!require(shiny)) install.packages("shiny", dependencies=TRUE)
    if (!require(ggplot2)) install.packages("ggplot2", dependencies=TRUE)
    if (!require(DT)) install.packages("DT", dependencies=TRUE)
    if (!require(dplyr)) install.packages("dplyr", dependencies=TRUE)
    if (!require(GGally)) install.packages("GGally", dependencies=TRUE)
    if (!require(plotly)) install.packages("plotly", dependencies=TRUE)
    if (!require(shinythemes)) install.packages("shinythemes", dependencies=TRUE)
    ```

## Usage

1. **Run the Application**: Save the provided `app.R` file and open it in RStudio or another R environment. Run the application using the following command:

    ```r
    shiny::runApp("path/to/your/app.R")
    ```

2. **Interact with the App**: Use the sidebar to apply filters and select variables for different visualizations. Explore the different tabs to view tables, plots, and summary statistics.

## Code Structure

- **`ui`**: Defines the user interface of the application, including layout, filters, and tabs.
- **`server`**: Contains the server logic for filtering data and generating plots and tables.
- **`filteredData`**: A reactive expression that filters the Iris dataset based on user input.
- **`output`**: Defines the outputs for each tab, including tables and plots.

## Contact

For any questions or feedback, please contact [Dattatray Bodake] (mailto:dattatraybodakedb@gmail.com).

---

Enjoy exploring the Iris dataset!
