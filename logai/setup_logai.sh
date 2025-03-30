#!/bin/bash
set -e

echo "Updating package lists and installing dependencies..."
apt-get update && \
    apt-get install -y --no-install-recommends wget build-essential libffi-dev \
        libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev git && \
    rm -rf /var/lib/apt/lists/*

echo "Upgrading pip and installing LogAI dependencies..."
python3.10 -m pip install --upgrade pip
python3.10 -m pip install "logai[all]"

echo "Downloading required NLTK datasets..."
python3.10 -m nltk.downloader punkt punkt_tab

echo "Starting LogAI GUI and Log Processor..."
python3.10 gui/application.py --host 0.0.0.0 --port 8050 --reload &

echo "LogAI is running. Processes are in the background."
wait  # Wait for all background processes to complete
