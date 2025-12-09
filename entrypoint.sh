#!/bin/bash

# Check required env variables
if [ -z "$OWNER" ] || [ -z "$REPO" ] || [ -z "$RUNNER_TOKEN" ]; then
  echo "Missing OWNER, REPO, or RUNNER_TOKEN environment variables."
  exit 1
fi

# Configure the runner
./config.sh --url https://github.com/${OWNER}/${REPO} --token $RUNNER_TOKEN

# Run the runner
./run.sh
