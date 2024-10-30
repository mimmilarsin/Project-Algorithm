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
  # Separate author column and create a new row for each author
  separate_longer_delim(Name, delim = ";") %>%

  # Separate author and affiliation
  separate_wider_delim(Name, delim = ", (", names = c("authorNameID", "affiliation"), too_few = "align_start", too_many = "merge") %>% #need to add code for multiple affiliations

  # Separate affiliation into organization and country
  separate_wider_delim(affiliation, delim = ", ", names = c("organization", "country"), too_few = "align_start", too_many = "merge") %>%

  # Remove extra ) from initial formatting
  mutate(country = str_remove_all(country, "\\)"))


ds_t2_compare <- ds_t2_prep %>%
  # Add authors column combining authorName, organization, and country data
  mutate(
    authors = str_glue_data(ds_t2_prep, "{authorNameID}, ({organization}, {country})"),
    .before = "authorNameID"
  ) %>%

  # Group rows by PID to determine collaboration type for each article
  group_by(PID) %>%

  # Add column for collaboration type & assign collaboration type:
  ## NA for individually authored publications
  ## local if all authors share organization
  ## national if all authors share country
  ## international if no shared organization or country
  mutate(
    collabType =
      if_else(NumberOfAuthors == 1, NA,
        case_when(
          n_distinct(organization) == 1 ~ "local",
          n_distinct(country) == 1 ~ "national",
          .default = "international"
        )
      ),
    .before = "collabNum"
  ) %>%

  # Combine author rows back into single row per publication
  # Discard temporary columns & duplicate rows
  mutate(
    authors = str_flatten(authors, collapse = "; ")
  ) %>%
  ungroup() %>%
  select(!authorNameID & !organization & !country) %>%
  distinct(PID, .keep_all = TRUE)
# End Task 2