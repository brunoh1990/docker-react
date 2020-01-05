#build phase to build the image to run in production
FROM node:alpine as builder
#builder is a tag so that this image can be called on another part of this dockerfile
WORKDIR '/app'

#with AWS maybe you have to change the . to ./ because sometimes it is not supported so you may need to change if an error occurs
COPY package.json . 
RUN npm install
COPY . .

RUN npm run build

#run phase to put the image running in a nginx server
FROM nginx
EXPOSE 80 
#used to expose ports inside the elasticbeanstalk so it can run with mapped ports

#here we grab what is left from the build phase and we say that from
#that container /app/build we want to pass it to the new image of nginx
#into a default folder where the app is deployed to the server
COPY --from=builder /app/build /usr/share/nginx/html 


