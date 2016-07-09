#------------------------------------------------------------------------------#
#
### Pull ACS data on race and adult education
#
#------------------------------------------------------------------------------#
library(acs)
setwd("C:/users/nmader/Documents/GitHub/leaflet-trainr/")

key <- readChar(con = keyfile, nchars = file.info(keyfile)$size - 1)
api.key.install(key = key)

# Set geography
ilCounties <- geo.lookup(state = "IL", county = "*")
geo <- geo.make(state = "IL", county = "Cook", tract = "*")
geo <- geo.make(state = "IL", county = "Cook County", tract = "*", block.group = "*")

# Look for tables of interest
acs.lookup(endyear = 2014, span = 5, keyword = "White")
acs.lookup(endyear = 2014, span = 5, table.number = "B03002") # This gets race by Ethnicity
acs.lookup(endyear = 2014, span = 5, keyword = "high school", case.sensitive = FALSE)
acs.lookup(endyear = 2014, span = 5, keyword = "Educational Attainment", case.sensitive = FALSE)
acs.lookup(endyear = 2014, span = 5, table.number = "B15003")

raceEth  <- acs.fetch(endyear = 2013, span = 5, geography = geo, table.number = "B03002")
edAttain <- acs.fetch(endyear = 2013, span = 5, geography = geo, table.number = "B01003")
