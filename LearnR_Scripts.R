# Check if Libraries is installed or not, if not then install it
usePackage <- function(p) 
{
  if (!is.element(p, installed.packages()[,1]))
    install.packages(p, dep = TRUE)
  require(p, character.only = TRUE)
}


# Import Libraries 
usePackage("sqldf")
usePackage("DT")
usePackage("plyr")
usePackage("data.table")

# read data
flights14 <- fread("flights14.csv")
# sqldf to run SQL query
sqldf("select carrier from flights14 group by carrier")
# data.table and plyr add new column and use mapvalues to recoding
flights14[, c("carrier_name") := mapvalues(carrier,from = c("AA","AS","B6","DL","EV","F9"),to = c("American Airline","American South Airline","Blue Air","Delta Air","England Air","France Air"))]
# select query after update query to return data
flights14 <- sqldf(c("UPDATE flights14 SET carrier_name = 'American Airline**' WHERE dep_delay + arr_delay = 0 AND carrier = 'AA'","select * from main.flights14 where carrier = 'AA'"))
# datatables.js for html display sqldf query result
datatable(sqldf("SELECT carrier_name, flight as flight_number, dep_delay + arr_delay AS total_delay FROM flights14 WHERE dest = 'LAX' AND dep_delay + arr_delay = 0"))