# Algorithm in R

# Algorithm Tasks: ----
# For a set of publications, determine the:
# (1) number of collaborators
# (2) collaboration types

# Load libraries ----
library(tidyverse)

# Load dataset ----
ds <- read_csv("testDataset.csv")

# Task 1 ----
ds_t1 <- ds %>% mutate(
  collabNum = case_when(
    NumberOfAuthors == 1 ~ "individual",
    NumberOfAuthors == 2 ~ "pair",
    NumberOfAuthors >= 3 ~ "group"
  ),
  .after = "PID"
)
# End Task 1


# Task 2 ----
ds_t2_prep <- ds_t1 %>%
  #separates the authors, creating a new row for each one
  separate_longer_delim(Name, delim = ";") %>%

  #separates the author info from the affiliation info
  separate_wider_delim(Name, delim = ", (", names = c("authorNameID", "affiliation"), too_few = "align_start", too_many = "merge") %>% #need to add code for multiple affiliations

  #separates affiliation into organization and country columns
  separate_wider_delim(affiliation, delim = ", ", names = c("organization", "country"), too_few = "align_start", too_many = "merge") %>%

  #removes extra ) from initial formatting
  mutate(country = str_remove_all(country, "\\)"))


ds_t2_compare <- ds_t2_prep %>%
  #adds authors column with combined authorName, organization, and country
  mutate(
    authors = str_glue_data(ds_t2_prep, "{authorNameID}, ({organization}, {country})"),
    .before = "authorNameID"
  ) %>%

  #groups rows by PID, determining collaboration type by each article
  group_by(PID) %>%

  #adds column for collaboration type & assigns collaboration type
  mutate(
    collabType =
      if_else(NumberOfAuthors == 1, NA, # collaboration type is NA for individual authored publications
        case_when(
          n_distinct(organization) == 1 ~ "local", # assigns local type if all authors share organization
          n_distinct(country) == 1 ~ "national", # assigns national type if all authors share country
          .default = "international" # assigns international type if no shared organization or country
        )
      ),
    .before = "collabNum"
  ) %>%

  #combines separate author rows back into single row per publication
  mutate(
    authors = str_flatten(authors, collapse = "; ")
  ) %>%
  ungroup() %>%
  select(!authorNameID & !organization & !country) %>%
  distinct(PID, .keep_all = TRUE)
# End Task 2