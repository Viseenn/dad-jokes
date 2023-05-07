#1 Use an official Node.js runtime as a parent image
FROM node:16-alpine as build-stage
#2 Make /app as working directory
WORKDIR /app
#3 Copy package.json and package-lock.json files to container
COPY package*.json ./
#4 Install app dependencies
RUN npm install
#5 Copy the remaining app files to the /app directory
COPY . .
#6 Build the app
RUN npm run build 

# Production stage
FROM nginx:stable-alpine as production-stage
#7 Copy dist folder from build stage to nginx public folder
COPY --from=build-stage /app/dist /usr/share/nginx/html
#8 This tells Docker your webserver will listen on port 80
EXPOSE 80
#9 Start the server
CMD ["nginx", "-g", "daemon off;"]