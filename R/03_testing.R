# Copyright Government of Canada 2018
# 
# Written by: National Microbiology Laboratory, Public Health Agency of Canada
# 
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use
# this work except in compliance with the License. You may obtain a copy of the
# License at:
#   
#   http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.


library(tidyr)
library(readr)
library(stringr)

#in.dir <- "data/testfiles/" # Some NTMS and others. Adding this directory to the test set adds a lot of time. 
#in.dir <- "data/failures/" # All of these don't have susceptibility results. Maybe the reason?
in.dir <- c("data/mykrobe_predictor_files_for_adrian/Data - Json files from Mykrobe/", "data/testfiles/", "data/failures/")

Mykrobe_linelist_desiredoutput <- read_csv("data/Mykrobe_linelist_desiredoutput.csv")

in.dir <- "data/testfiles/1800430-A-25__66820.json"

# Grab a single file /  a couple files
list.of.json.files <- map(here(in.dir), ~ fromJSON(.x, simplifyDataFrame = F))

# List files and figure out duplicates
files <- list.files(path = here(in.dir), pattern = "*.json", full.names = T)
data_frame(Directories = dirname(files),
           Files = basename(files)) %>% 
  View()



listelement <- list.of.json.files[[1]]
getResults(listelement) %>% View()

variants.temp %>% 
  mutate(mutation = str_match(variants.temp$mutation, "(.*)-.*:")[,2]) # Extract out the mutation information

select(report, starts_with("Mykrobe_"))
mutate_at(report, vars(starts_with("Mykrobe_")), funs(replace(., is.na(.), "No Mutation")))



# Some nonsense that didn't work ####
# df <- nodes %>% ToDataFrameTable(SampleID = function(x) x$parent$name,
#                                  mykrobe_version = "mykrobe-predictor")
# 
# reposdf <- repos %>% ToDataFrameTable(ownerId = "id", 
#                                       "login", 
#                                       repoName = function(x) x$parent$name, #relative to the leaf
#                                       fullName = "full_name", #unambiguous values are inherited from ancestors
#                                       repoId = function(x) x$parent$id,
#                                       "fork", 
#                                       "type")
# 
# 
# print(df.nodes)


# Command line testing ####
option_list <- list(
  make_option(c("-f", "--file"), 
              type="character", 
              default=NULL,
              #default="data/failures/1701326__46581.json,data/testfiles/1701267__47668.json,data/testfiles/1800607__66788.json,data/mykrobe-test-data/test-data.json", 
              help="dataset file name or comma separated names: eg. file1,file2,file3", 
              metavar="character"),
  make_option(c("-d", "--dir"), 
              type="character", 
              #default=NULL,
              default="data/problemfiles_duplicate-rows/",
              help="directory of json files", 
              metavar="character"),
  make_option(c("-v", "--version"), 
              type="character", 
              default=NULL, 
              help="Mykrobe Workflow Version", 
              metavar="character"),
  make_option(c("-D", "--depth"), 
              type="integer", 
              default=5, 
              help="Minimum depth of coverage [default= %default]", 
              metavar="integer"),
  make_option(c("-c", "--conf"), 
              type="integer", 
              default=10, 
              help="Minimum genotype confidence for variant genotyping [default= %default]", 
              metavar="integer"),
  make_option(c("-n", "--run-name"), 
              type="character", 
              default=NULL, 
              help="Name of the run", 
              metavar="character")
)

opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

# Testing combination of multiple mutations for one gene into a single cell
variants.temp %>% 
  select(file, columnname, mutation) %>% 
  group_by(file, columnname) %>% 
  summarise(mutation = paste(mutation, collapse = ";")) %>% # Easy peasy 
  spread(columnname, mutation)
