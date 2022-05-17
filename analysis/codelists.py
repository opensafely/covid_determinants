from cohortextractor import (
    codelist,
    codelist_from_csv,
)

# ----------------
# Ethnicity codes
# ----------------


ethnicity_codes_snomed = codelist_from_csv(
    "codelists/user-candrews-full_ethnicity_coded.csv",
    system="snomed",
    column="snomedcode",
    category_column="Grouping_6",
)


ethnicity_codes_snomed_16 = codelist_from_csv(
    "codelists/user-candrews-full_ethnicity_coded.csv",
    system="snomed",
    column="snomedcode",
    category_column="Grouping_16",
)
