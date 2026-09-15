#!/bin/bash
# Helper script to build and run the test Docker container

# Exit immediately if a command exits with a non-zero status.
set -e

# Capture absolute path of the dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Building test Docker image..."
docker build -t dotfiles-test -f "$DOTFILES_DIR/test/Dockerfile" "$DOTFILES_DIR"

echo "Running install.sh inside the test container..."
docker run --rm dotfiles-test

echo "✅ Test completed successfully!"
