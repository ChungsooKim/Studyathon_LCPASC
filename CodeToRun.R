# This is the only code the user should interact with
# Runs the Studyathon Long Covid and PASC Project

# Manage project dependencies
# the following will prompt you to install the various packages used in the study 
# You must have renv package installed. Otherwise, run: install.packages("renv")
# renv::activate()
# renv::restore() 
# renv::deactivate()
# Required packages from CRAN:
library(RPostgres)
library(tools)
library(DBI)
library(dplyr)
library(dbplyr)
library(CDMConnector)
library(here)
library(log4r)
library(zip)
library(poLCA)
library(igraph)
library(psych)
library(MatchIt)
library(purrr)
library(ggplot2)
library(IncidencePrevalence)
library(lubridate)
library(tibble)
library(reshape2)
library(readr)


# install the following packages like this, with remotes 
# library(remotes)
# remotes::install_github("EHDEN/Trajectories")
library(Trajectories)
# remotes::install_github("OHDSI/DatabaseConnector")
library(DatabaseConnector)
# remotes::install_github("OHDSI/CirceR")
library(CirceR)

# Database name or acronym (e.g. for CPRD AURUM use "CPRUAurum")
db.name <- "AUSOM"

# Name of the output folder to save the results. Change to "output" or any other
# desired path
output.folder <- here::here()

# Stem to use for the cohort tables in the database
table_stem <- "ausom"

# Change the following parameters with your own database information
user <- ''
password <- ''
port <- ''
host <- ''

# Create database connection
# We use the DBI package to create a cdm_reference
library(DBI)
library(odbc)

# db <- dbConnect(RPostgres::Postgres(),
#                 dbname = server_dbi,
#                 port = port,
#                 host = host,
#                 user = user,
#                 password = password)
# 
db <- DBI::dbConnect(odbc::odbc(),
                Driver = 'SQL Server',
                Server = '',
                Database = '',
                UID = '',
                PWD = '',
                Port = '')

# db <- dbConnect(odbc::odbc(),
#                 .connection_string='Driver={Oralce dans OraClient11g_home1};DBQ=localhost:1521/XE;UID=system;PWD=oracle')

# sql dialect used with the OHDSI SqlRender package
targetDialect <- "sql server" 

# Create connection details "OHDSI way" for some packages
server <- ''

connectionDetails <- DatabaseConnector::downloadJdbcDrivers(targetDialect, here::here())
connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = 'sql server',
  server = server,
  user = user,
  password = password,
  port = port,
  pathToDriver = here::here())

# Name of the schema with the patient-level data
cdm_database_schema <- ""

# Name of the schema with the vocabulary, usually the same as the patient-level
# data schema
vocabulary_database_schema <- cdm_database_schema

# Name of the schema where the result table will be created
results_database_schema <- cdm_database_schema

# Study start date, should not change this
study_start_date <- as.Date("2020-09-01")

# Covid end date, country specific, when testing ended
# Might not be applicable, otherwise set as latest_data_availability
covid_end_date <- as.Date("2023-02-28")

# Start date of omicron variant, country specific
omicron_start_date <- as.Date("2021-12-31")

# Latest data availability, to know until when to calculate incidences
latest_data_availability <- as.Date("2023-02-28") 

# Decide which parts of the study you want to run 
readInitialCohorts <- TRUE
getStudyCohorts <- TRUE
doIncidencePrevalence <- TRUE
doCharacterisation <- TRUE
doDrugUtilisation <- TRUE
doTreatmentPatterns <- TRUE
doClustering <- TRUE
doTrajectories <- TRUE

# Set to true or false for the following information for your database
vaccine_data <- F # Set to FALSE if you have no information on vaccination 
# whatsoever - and thus cannot stratify by it
vaccine_brand <- F # Set to FALSE if you do have information on vaccination,
# but not on vaccine brand

# If you can only run Long Covid related analyses
onlyLC <- FALSE

# If you have some problems with dates in initial cohorts
instantiate_diff <- FALSE

# If your database engine is SQL Server
sql_server <- TRUE

# Run the study
source(here("RunStudy.R"))

# After this is run you should have a zip file in your output folder to share