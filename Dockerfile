# Base image
##https://stackoverflow.com/questions/60394291/error-node-modules-node-sass-command-failed
FROM node:14 

## Set the working directory inside the container
WORKDIR /app

# Copy the package.json and yarn.lock files
COPY package.json yarn.lock ./


# Install the dependencies
RUN yarn install

# Copy the entire project
COPY . .

# Build the Vue.js app for production
RUN yarn run build 

# Install serve globally
RUN npm install -g serve

# Expose the port the app runs on
EXPOSE 8080

# Start Nginx when the container runs
CMD ["yarn","serve"]
