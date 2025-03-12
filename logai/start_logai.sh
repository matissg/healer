#!/bin/bash
python3.10 gui/application.py --host 0.0.0.0 --port 8050 --reload &
python3.10 gui/log_processor.py --host 0.0.0.0 --port 5000 --reload &
wait
