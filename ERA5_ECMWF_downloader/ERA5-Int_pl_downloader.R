#!/usr/bin/env Rscript

# !!!before run!!!:
# sudo pip install https://software.ecmwf.int/wiki/download/attachments/56664858/ecmwf-api-client-python.tgz



#limpeza ambiente e objetos:
rm(list=ls())
cat("\014")

#####################################
cat("Autor:", "\n", "Ricardo Faria", "\n")
#####################################

# time sequence
data_i <- "2016-01-01" #readline(prompt = "Data inicial para analise de dados no formato (AAAA-MM-DD): ")
data_f <- "2016-01-15" #readline(prompt = "Data final para analise de dados no formato (AAAA-MM-DD): ")

list_dates <- seq.Date(as.Date(data_i), as.Date(data_f), by = "day")
list_dates <- format(list_dates, "%Y%m%d")

# install python packages dependencies
#system("sudo pip install https://software.ecmwf.int/wiki/download/attachments/56664858/ecmwf-api-client-python.tgz")

for (i in 1:length(list_dates)) {
  
  if (file.exists(paste0("ERA5_pl_", list_dates[i], ".grib"))) {
    
    cat(paste0("ERA5_pl_", list_dates[i], ".grib"), " - already downloaded. \n")
    
  } else if (file.exists(paste0("ERA5_pl_", list_dates[i], ".nc"))) {
    
    cat(paste0("ERA5_pl_", list_dates[i], ".nc"), " - already downloaded. \n")
    
  } else {
    
    txt <- c("#!/usr/bin/env python", 
             "from ecmwfapi import ECMWFDataServer", 
             "", 
             "server = ECMWFDataServer()", 
             "", 
             "server.retrieve({", 
             "'dataset' : 'era5_test',", 
             "'step'    : '0',", 
             "'levtype' : 'pl',", 
             "'levelist' : 'all',", 
             paste0("'date'    : '", list_dates[i], "/to/", list_dates[i], "',"), 
             "'time'    : '00/01/02/03/04/05/06/07/08/09/10/11/12/13/14/15/16/17/18/19/20/21/22/23',", 
             "'type'    : 'an',", 
             "'param'   : '129/130/131/132/157',", 
             #"'area'    : '70/-130/30/-60',", 
             "'grid'    : '128',", 
             #"'format'  : 'netcdf',", 
             #paste0("'target'  : 'ERA5_pl_", list_dates[i], ".nc'"), 
             paste0("'target'  : 'ERA5_pl_", list_dates[i], ".grib'"), 
             
             "})")
    
    writeLines(txt, paste0("ECMWF_ERA5_pl_", list_dates[i], ".py"))
    
    cat(paste0("Downloading ECMWF ERA5 WRF pl variables, day: ", list_dates[i]), "\n")
    system(command = paste0("python ECMWF_ERA5_pl_", list_dates[i], ".py"), ignore.stdout = F, ignore.stderr = F)
    system(command = paste0("rm -rf ECMWF_ERA5_pl_", list_dates[i], ".py"), ignore.stdout = F, ignore.stderr = F)
    
  }
  
}

cat("Download finished with:", "\n", length(list_dates), "files")
