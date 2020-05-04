
lin<-read.csv("circle.csv",header = F)

a<-as.matrix(lin[,-3])
b<-as.matrix(lin[,3])
dim(a) #We have 100 observations in this case

ind=which(lin[,3]==0)
plot(lin[ind,1],lin[ind,2],type="p",xlim=c(-1.2,1.2),ylim=c(-1.2,1.2))
lines(lin[-ind,1],lin[-ind,2],type="p",col="red")

#Activation function f(\hat{B})
activation <- function(z) {
    1/(1 + exp(-z))
}

backprop <- function(a, b, epochs = 10, eta = 0.1) { #a is the input, b the output
    
    a <- cbind(a,rep(1,nrow(a))) #To include the bias: we add as many 1 as needed and we concatenate to the input neurons
    
    neurons <- c(ncol(a),ncol(b)) #Only an input and an output layer for now
    #We define a random set of weights to start
    Wold <- matrix(data = runif(prod(neurons), min = -1, max = 1), nrow = neurons[2], ncol = neurons[1])
    
    errors = c() #We also keep the errors squared in order to plot them
    
    for (j in 1:epochs) {
        
        #Let's propagate the values of the neurons until reaching the output
        #The output is then obtained by multiplying a by the transpose of the matrix of the weights and activating the result
        bout <- activation(a %*% t(Wold)) #The transpose has to be used for dimension purposes
        error <- bout-b 
        delta <- error*bout*(1-bout) #This is an extremly important parameters which will come back many times
        
        #Update the weights
        Wnew <- Wold - eta * t(delta)%*%a #According to the formula seen in class
        Wold <- Wnew #Getting ready to start again the loop for the next epoch
        
        errors[j] <- sum((error)^2) #Let's actually use the square of the difference between the output obtained and the actual output for the error in this exercise
        #print(paste("Error for epoch", j, " = ", sum(resid <- (error)^2)))
        
    }
    
    return(errors)
}

set.seed(1) #To always get the same results

etas <- c(0.01, 0.05, 0.1, 0.2) #Let's use different eta values and plot the error
par(mfrow=c(2,2))

for(i in 1:length(etas)){
    errors <- backprop(a, b, epochs = 150, eta = etas[i])
    plot(errors, main=paste("Quadratic error ( eta = ", etas[i], ")"), xlab="Epoch", ylab="Cuadratic sum of the error")
}

backprop_one <- function(x, b, h = 5, epochs = 10, eta = 0.1) { 
    #In this case, x is the input, a the values of the hidden layer and b the output, to follow the notation from the class
    #h is now the number of hidden neurons in the hidden layer, which defaults to 5
    
    #Let's initialize our matrices and lists
    x <- cbind(x,rep(1,nrow(x))) #Include the bias to the input, only once at the beginning
    neurons <- c(ncol(x), h, ncol(b)) #We add the hidden neurons h in the middle of this vector
    
    #Let's now define wXtoH the random weights of the input to the hidden layer, and wHtoB the second set of weights
    wXtoA <- matrix(data = runif(prod(neurons), min = -1, max = 1), nrow = neurons[2], ncol = neurons[1]) #Random set of weights to start
    wAtoB <- matrix(data = runif(prod(neurons), min = -1, max = 1), nrow = neurons[3], ncol = neurons[2])

    errors = c() #Keep the errors to plot them
    
    for (j in 1:epochs) {
        
        #Let's compute the values of the different layers for these weights
        a <- activation(x %*% t(wXtoA))
        bout <- activation(a %*% t(wAtoB))
        
        #Let's compute the different parameters we will need later on, such as delta
        error <- bout-b 
        delta <- error*bout*(1-bout)
        
        #Now, let's update the different weights using the backpropagation method
        wAtoB <- wAtoB - eta * t(delta) %*% a

        #The second weight is a bit harder to compute as it depends on many different facotrs, each with different dimensions
        fac1 <- delta %*% wAtoB
        fac2 <- fac1 * (a*(1-a))
        fac3 <- t(fac2) %*% x
        
        wXtoA <- wXtoA - eta * fac3 #We need to take care of the dimensions here
        
        errors[j] <- sum((error)^2)
        
    }
   
    return(errors)
}

set.seed(1) #To always get the same results

etas <- c(0.001, 0.002, 0.005, 0.01) #Let's use different eta values and plot the error (low values of eat since we are asked to use 500 epochs)
par(mfrow=c(2,2))

for(i in 1:length(etas)){
    errors <- backprop_one(a, b, h = 5, epochs = 500, eta = etas[i])
    plot(errors, main=paste("Quadratic error ( eta = ", etas[i], ")"), xlab="Epoch", ylab="Cuadratic sum of the error")
}

backprop_multiple <- function(x, b, h = c(5, 5, 5), epochs = 10, eta = 0.1) { 
    #In this case, x is the input and b the output, as before
    #h is now the number of hidden neurons in several hidden layers
    
    #Let's initialize our matrices and lists
    x <- cbind(x,rep(1,nrow(x))) #Include the bias to the input, only once at the beginning
    neurons <- c(ncol(x), h, ncol(b)) #We add the hidden neurons h in the middle of this list
    nLayers <- length(neurons) #The total number of layers
    
    #We will keep the values of all the different layers, not only the hidden layers ones, in a values list
    values <- list()
    values[[1]] <- x #The first layer is the input
    values[[nLayers]] <- b #The last layer is the output

    #Let's now define a list of random weights corresponding to the weights between the different layers
    weights <- list()
    for (i in 1:(nLayers-1)) { #If we have 4 total layers, we need to define 3 sets of weights
        weights[[i]] <- matrix(data = runif(prod(neurons), min = -1, max = 1), nrow = neurons[i+1], ncol = neurons[i])
    }
    
    #We will also keep the different delta parameters computed in a list
    delta <- list()
    
    errors = c() #Keep the errors to plot them

    for (j in 1:epochs) {
        
        #Let's compute the values for all the layers. We actually already know the value of the first one (input) and the last one (output)
        for (k in 2:(nLayers)) {
            values[[k]] <- activation(values[[k-1]] %*% t(weights[[k-1]]))
        }
        
        bout <- values[[nLayers]] #Estimated output value = value of the last layer
        error <- bout-b
        delta[[nLayers-1]] <- error*bout*(1-bout) #The first delta is computed out of the loop using the real value of b, which is not contained with the list values

        #Now we can loop backwards over the remaining layers to compute all the other deltas
        for (k in (nLayers-2):1) { #We expect to have nLayers-1 delta parameters, just as the weights
            factor <- delta[[k+1]] %*% weights[[k+1]] #Each delta is computed from the previous one and from the weights of the current layer
            delta[[k]] <- factor * (values[[k+1]]*(1-values[[k+1]])) 
        }   
        
        #Finally, let's update the different weights using the backpropagation method and the deltas just calculated
        for (k in 1:(nLayers-1)) { #We need nLayers-1 weights
            weights[[k]] <- weights[[k]] - eta * (t(delta[[k]]) %*% values[[k]])
        }
        
        errors[j] <- sum((error)^2) #The error is given by the difference between our output and the expected one, squared

    }
   
    return(errors)
}

set.seed(1) #To always get the same results

etas <- c(0.001, 0.002, 0.005, 0.01) #Let's use different eta values and plot the error (low values of eat since we are asked to use 500 epochs)
par(mfrow=c(2,2))

#This should give us exactly the same output as before
for(i in 1:length(etas)){
    errors <- backprop_multiple(a, b, h = c(5), epochs = 500, eta = etas[i])
    plot(errors, main=paste("Quadratic error ( eta = ", etas[i], ")"), xlab="Epoch", ylab="Cuadratic sum of the error")
}

#Now let's try adding more layers
etas <- c(0.001, 0.002, 0.005, 0.01) #Let's use different eta values and plot the error (low values of eat since we are asked to use 500 epochs)
par(mfrow=c(2,2))

for(i in 1:length(etas)){
    errors <- backprop_multiple(a, b, h = c(5, 6, 5), epochs = 500, eta = etas[i])
    plot(errors, main=paste("Quadratic error ( eta = ", etas[i], ")"), xlab="Epoch", ylab="Cuadratic sum of the error")
}

par(mfrow=c(2,2))

plot(backprop_multiple(a, b, h = c(1), epochs = 1000, eta = 0.0001),
     main=paste("Quadratic error ( 1 HN, eta = ", 0.0001, ")"), xlab="Epoch", ylab="Cuadratic sum of the error")
plot(backprop_multiple(a, b, h = c(2), epochs = 1000, eta = 0.0001),
     main=paste("Quadratic error ( 2 HN, eta = ", 0.0001, ")"), xlab="Epoch", ylab="Cuadratic sum of the error")
plot(backprop_multiple(a, b, h = c(5), epochs = 1000, eta = etas[i]),
     main=paste("Quadratic error ( 5 HN, eta = ", 0.0001, ")"), xlab="Epoch", ylab="Cuadratic sum of the error")
plot(backprop_multiple(a, b, h = c(10), epochs = 1000, eta = etas[i]),
     main=paste("Quadratic error ( 10 HN, eta = ", 0.0001, ")"), xlab="Epoch", ylab="Cuadratic sum of the error")
plot(backprop_multiple(a, b, h = c(5), epochs = 1000, eta = 0.00001),
     main=paste("Quadratic error ( 5 HN, eta = ", 0.00001, ")"), xlab="Epoch", ylab="Cuadratic sum of the error")
plot(backprop_multiple(a, b, h = c(5), epochs = 1000, eta = 0.005),
     main=paste("Quadratic error ( 5 HN, eta = ", 0.005, ")"), xlab="Epoch", ylab="Cuadratic sum of the error")
plot(backprop_multiple(a, b, h = c(5), epochs = 1000, eta = 0.01),
     main=paste("Quadratic error ( 5 HN, eta = ", 0.01, ")"), xlab="Epoch", ylab="Cuadratic sum of the error")
plot(backprop_multiple(a, b, h = c(5), epochs = 1000, eta = 1.0),
     main=paste("Quadratic error ( 5 HN, eta = ", 1.0, ")"), xlab="Epoch", ylab="Cuadratic sum of the error")

backprop_multiple_inertia <- function(x, b, h = c(5, 5, 5), epochs = 10, eta = 0.1, alpha = 0.1) { #We add the alpha parameter

    x <- cbind(x,rep(1,nrow(x)))
    neurons <- c(ncol(x), h, ncol(b))
    nLayers <- length(neurons)

    values <- list()
    values[[1]] <- x
    values[[nLayers]] <- b

    weights <- list()
    weightsNotUpdated <- list() #Needed to compute the delta weights
    previousWeights <- list() #List to keep the weights of the previous epoch for the inertia term
    for (i in 1:(nLayers-1)) {
        weights[[i]] <- matrix(data = runif(prod(neurons), min = -1, max = 1), nrow = neurons[i+1], ncol = neurons[i])
        previousWeights[[i]] <- 0
    }

    delta <- list()
    errors = c()

    for (j in 1:epochs) {
        
        for (k in 2:(nLayers)) {
            values[[k]] <- activation(values[[k-1]] %*% t(weights[[k-1]]))
        }
        
        bout <- values[[nLayers]]
        error <- bout-b
        delta[[nLayers-1]] <- error*bout*(1-bout)

        for (k in (nLayers-2):1) {
            factor <- delta[[k+1]] %*% weights[[k+1]]
            delta[[k]] <- factor * (values[[k+1]]*(1-values[[k+1]])) 
        }   
        
        for (k in 1:(nLayers-1)) { 
            #This is the main change in this function
            #We add a term depending on the alpha parameter and on the value of the delta weights computed for a previous epoch
            #Let's save the weights before the update to compute the delta weights
            weightsNotUpdated[[k]] <- weights[[k]]
            weights[[k]] <- weights[[k]] - eta * (t(delta[[k]]) %*% values[[k]]) + alpha * (weightsNotUpdated[[k]] - previousWeights[[k]])
            previousWeights[[k]] <- weights[[k]] #Let's save the weights for the inertia term of the next iteration
        }
        
        errors[j] <- sum((error)^2)

    }
   
    return(errors)
}

alphas <- c(0.001, 0.005, 0.01, 0.02, 0.05, 0.1) #Let's use different alpha values and plot the error (low values of eat since we are asked to use 500 epochs)
par(mfrow=c(2,2))

for(i in 1:length(alphas)){
    errors <- backprop_multiple_inertia(a, b, h = c(5, 6, 5), epochs = 500, eta = 0.001, alpha = alphas[i])
    plot(errors, main=paste("Quadratic error ( alpha = ", alphas[i], ")"), xlab="Epoch", ylab="Cuadratic sum of the error")
}
