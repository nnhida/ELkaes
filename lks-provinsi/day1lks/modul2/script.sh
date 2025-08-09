#!/bin/bash
sudo apt update -y
sudo apt install ansible -y
sudo snap list amazon-ssm-agent
sudo snap start amazon-ssm-agent
sudo snap services amazon-ssm-agent