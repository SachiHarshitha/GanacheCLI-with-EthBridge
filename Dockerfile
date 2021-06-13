FROM mhart/alpine-node:14 as builder
# Insert nodejs and npm to the original installation
RUN apk add --no-cache make gcc g++ python git bash nodejs npm 
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json
WORKDIR /app
RUN git config --global url.https://github.com/.insteadOf ssh://git@github.com/
RUN npm ci
COPY . .
RUN npx webpack-cli --config ./webpack/webpack.docker.config.js
FROM mhart/alpine-node:14 as runtime
# Get and install the NPM package for ethereum-bridge
RUN npm install -g ethereum-bridge
WORKDIR /app

COPY --from=builder "/app/build/ganache-core.docker.cli.js" "./ganache-core.docker.cli.js"
COPY --from=builder "/app/build/ganache-core.docker.cli.js.map" "./ganache-core.docker.cli.js.map"
# Copy the new entry point bash script into the opt/bin path of the image
COPY 1entrypoint.sh /opt/bin/1entrypoint.sh

ENV DOCKER true

EXPOSE 8545
# Set the default entry point to the new bash script.
ENTRYPOINT ["sh","/opt/bin/1entrypoint.sh"]

#ENTRYPOINT ["node", "/app/ganache-core.docker.cli.js"]

