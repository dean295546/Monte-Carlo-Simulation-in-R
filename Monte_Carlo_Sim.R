#Script a Monte Carlo Simulation that allows the user to estimate the area under 
#any given function between any two points over a positive area. 
#Compare that with the actual area. Show the development of the estimator. (also a plot)
library(dplyr)

#Creating normal distribution plot
x <- seq(-10, 10, by = .1)
y <- dnorm(x, mean = 0, sd=2)
plot(x,y, type='l', main = "Monte Carlo Simulation")

#Scattering points onto the plot
set.seed(4)
n <- 100000
x_cor <- sample(seq(-10,10,by=.0001), n, replace=T)
y_cor <- sample(seq(round(min(y),4), round(max(y),4),by=.0001),n, replace = T)
points(x_cor, y_cor, pch = 16,col = 'red', cex=.1)

# Create the function for the estimation
estimation <- function(x1,x2){
# Ask the user to enter 2 values for X
x1 <- as.integer(readline(prompt = "Please enter a number from -10 to 10 for x1: "))
x2 <- as.integer(readline(prompt = "Please enter a number from -10 to 10 for x2: "))
if (x1 > x2){
  x0 <- x1
  x1 <- x2
  x2 <- x0
}

# Count the points under y
point_cor <- data.frame(x_cor, y_cor) %>% arrange(x_cor) #coordinate of each point
point_cor <- point_cor %>% mutate(new_y = dnorm(x_cor, mean = 0, sd=2)) # Add a new col for curve's y value
dots_under <- point_cor %>% filter(y_cor <= new_y) # filter out the dots under the curve
dot_in <- point_cor %>% filter(x_cor <= x2) %>% filter(x_cor >= x1) %>% mutate(new_y = dnorm(x_cor, mean = 0, sd=2)) #Filter out the dots within range

# Real Area (Probability)
real_area <- pnorm(x2, mean = 0, sd=2) - pnorm(x1, mean = 0, sd=2)

# Estimated area (Probability)
est_area <- sum(dot_in$y_cor <= dot_in$new_y)/length(dots_under$x_cor)

# Dots in range and under the curve
est_pt <- dot_in %>% filter(y_cor <= new_y)

# Compute the plot again with the asked area
plot(x,y, type='l', main = "Monte Carlo Simulation")
points(est_pt$x_cor, est_pt$y_cor, pch = 16, col = 'blue',cex=.1)

print(paste("The estimated probability is:", est_area))
print(paste("The real probability is: ", real_area))
}

#Call the function
estimation()
