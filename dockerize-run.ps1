#!/usr/bin/env pwsh

. ./dockerize-lib.ps1
Clear-Host;
Invoke-DockerizeRailsDev;
Exit-PSHostProcess;