#!/bin/bash

system_usage()
{
    echo " CPU and Memory Usage"
    echo
    echo "CPU Load"
    uptime
    echo
    echo "Memory usage"
    echo
    free -h
    echo
    log_action "Displayed CPU and Memory usage"
}

system_usage