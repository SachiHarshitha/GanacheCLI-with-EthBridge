#!/bin/bash
node /app/ganache-core.docker.cli.js & # Start the Ganache CLI as a background process.
sleep 10 # Add a small delay to let the Ganache CLI configuration complete.
ethereum-bridge -a 1 --dev # Run the Ethereum Bridge on the second account available in the network.
