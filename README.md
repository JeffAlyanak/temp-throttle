# temp-throttle

## Introduction

Need a quick and dirty way to throttle a process based on a desired CPU temperature? `temp-throttle` is the answer! Simply provide a _target temperature_ and a _process_!

Great for limiting programs like Folding@Home that want to max your CPU and turn your computer into a heater. Now you can control the heat output of that heater!

_Warning: This script was written hastily with minimal testing. Use at your own risk!_

## Example
Simply run the script and provide the temperature and process.

For example:
```bash
./temp-throttle.sh --temp 72 --process FahCore_a7
```

## Requirements

This script requires `cpulimit`.