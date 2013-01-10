# Load libraries

# Load data
?read.csv
payments = read.csv("~/Desktop/code_camp_payments.csv")
items = read.csv("~/Desktop/code_camp_items.csv")
?data.frame

# fix time data types
payments$created_at   = as.POSIXct( payments$created_at, tz='UTC')
items$order_created_at = as.POSIXct( items$order_created_at, tz='UTC')

# Add date columns
payments$date = as.Date( payments$created_at, tz='UTC')
items$date     = as.Date( items$order_created_at, tz='UTC')

# Quick summaries
qs <- function( df){
  print( "Names:")
  print( names( df ) )
  print( "Class:")
  print(class( df ))
  print( "Head:")
  print(head( df ))
  print( "Summary:")
  summary( df )
}

qs( payments )
qs( items )

# plots
plot( aggregate(items$price_cents/100 * items$quantity,by=list(items$date),sum)  )

# Number of items each day
payments.count.daily = aggregate(rep(1, length(payments$date) ),by=list(payments$date),sum)
plot( payments.count.daily
      , main="Square Internal"
      , xlab="Date"
      , ylab="Number of Transactions")

user.list = unique( payments$user )

payments.user = list()
payments.user[[1]] = payments[ payments$user==user.list[1],]
payments.user[[2]] = payments[ payments$user==user.list[2],]
payments.user[[3]] = payments[ payments$user==user.list[3],]

payments.user = list()
payments.user[[1]] = payments[ payments$user==user.list[1],]
payments.user[[2]] = payments[ payments$user==user.list[2],]
payments.user[[3]] = payments[ payments$user==user.list[3],]

payments.user.daily = list()
payments.user.daily[[1]] = aggregate(rep(1, length(payments.user[[1]]$date) ), by=list(payments.user[[1]]$date),sum)
payments.user.daily[[2]] = aggregate(rep(1, length(payments.user[[2]]$date) ), by=list(payments.user[[2]]$date),sum)
payments.user.daily[[3]] = aggregate(rep(1, length(payments.user[[3]]$date) ), by=list(payments.user[[3]]$date),sum)

names( payments.user.daily[[1]] ) <- c("date", "count")
names( payments.user.daily[[2]] ) <- c("date", "count")
names( payments.user.daily[[3]] ) <- c("date", "count")

# Decomposing the 3 time series
plot(payments.user.daily[[1]], pch="+", ylim=c(-10,350)
      , main="Square Internal"
      , xlab="Date"
      , ylab="Number of Transactions")
points( payments.user.daily[[2]], col='red')
points( payments.user.daily[[3]], col='blue')

legend("topleft"
       , c("s1", "s2", "s3")
       , pch = c("+", "o", "o")
       , col=c("black", "red", "blue")
       )

# Find the difference between payments
# inter-arrival distance
qs( payments.user[[2]] )
qs( payments.user[[1]] )
p.in = payments.user[[1]]
p = sort( p.in$created_at )
time.between = diff(p)
time.between.int = as.numeric(time.between)
time.between.int.sm = time.between.int[time.between.int< 600]

plot( density( time.between.int.sm  ) )
abline( v =median( time.between.int.sm  ) )
abline( v =mean( time.between.int.sm  ) )

hist( log( time.between.int.sm ))
plot( density( log(time.between.int.sm  ) ))


# Find the top items overall
names(items)
# reference : http://statistics.ats.ucla.edu/stat/r/faq/sort.htm
items.summary = aggregate(rep(1, length(items$id) ), by=list(items$item_name),sum)
head(items.summary)
names( items.summary ) <- c('item_name', 'count')
sort.items <- items.summary[order(-items.summary$count) , ]
?head
head( sort.items , n=15)

