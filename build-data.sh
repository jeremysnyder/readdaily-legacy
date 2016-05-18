#!/bin/bash

cd data
python3 process-reading-plan-csv.py
rm -rf ../src/assets/data/chapter-bible-reading-plan
rm -rf ../src/assets/data/verse-bible-reading-plan
mv ./chapter-bible-reading-plan ../src/assets/data
mv ./verse-bible-reading-plan ../src/assets/data
