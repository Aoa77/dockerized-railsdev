#!/usr/bin/env pwsh

function Invoke-DockerizeRailsDev {

    Write-Host -ForegroundColor Blue " ====================="; 
    Write-Host -ForegroundColor Cyan "[ dockerized-railsdev ]"; 
    Write-Host -ForegroundColor Blue " =====================";

    [bool] $decision = $false;
    [string] $container_name = "railsdev";
    [string] $image_name = "ubuntu";
    [string] $base_tag = "aoa77-railsdev-base";
    [string] $image_tag = "aoa77-railsdev";

    Write-Host;
    [string] $container_status = Get-ContainerStatus $container_name;
    if ($container_status.Length -gt 0) {
        $decision = Confirm-DockerAction "Stop and remove?";
        if ($decision -eq $false) {
            return;
        }
        docker stop $container_name > $null;
        docker rm $container_name > $null;
    }

    Write-Host;
    Write-Host;

    [string] $base_status = Get-ImageStatus $image_name $base_tag;
    [string] $display_name = $image_name + ":" + $base_tag;
    if ($base_status.Length -gt 0) {
        $decision = Confirm-DockerAction "Remove and rebuild?";
        if ($decision -eq $true) {
            docker image rm $display_name --force;
        }
    }
    
    Write-Host;
    Write-Host;

    $base_status = Get-ImageStatus $image_name $base_tag;
    if ($base_status.Length -eq 0) {
        Write-Host -ForegroundColor Green "Building base image [$display_name]...";
        docker build -t $display_name -f Dockerfile.base .;
    }
    
    $display_name = $image_name + ":" + $image_tag;
    docker image rm $display_name --force;
    docker build -t $display_name .;
    docker run -it --name $container_name $display_name;
}

function Confirm-DockerAction([string] $message) {
    [string] $title = "";
    $choices = "&Yes", "&No"
    $decision = $Host.UI.PromptForChoice($title, $message, $choices, 1);
    return ($decision -eq 0);
}

function Get-ContainerStatus {
    [string] $resx = "Container";
    [string] $status = "";
    [string] $name = $args[0];

    if ($name.Length -eq 0) {
        Write-LogInvalid $resx;
        return $status;
    }
    docker ps -a --format "{{.Names}}: {{.Status}}" | ForEach-Object {
        if ($_ -match $name + ":") {
            $status = $_;
            return;
        }
    }
    if ($status.Length -eq 0) {
        Write-LogNotFound $resx $name;
    }
    else {
        Write-LogFound $resx $status;
    }
    return $status;
}

function Get-ImageStatus {
    [string] $resx = "Image";
    [string] $status = "";
    [string] $name = $args[0];
    [string] $tag = $args[1];
    [string] $combined = $name + ":" + $tag;

    if ($name.Length -eq 0 -or $tag.Length -eq 0) {
        Write-LogInvalid $resx;
        return $status;
    }
    docker images --format "{{.Repository}}:{{.Tag}}:{{.Size}}" | ForEach-Object {
        if ($_ -match $combined + ":") {
            $status = $_;
        }
    }
    if ($status.Length -eq 0) {
        Write-LogNotFound $resx $combined;
    }
    else {
        Write-LogFound $resx $combined;
    }
    return $status;
}


function Write-LogFound {
    [string] $resx = $args[0];
    [string] $display = $args[1];
    Write-Host -ForegroundColor Green "$resx found: [$display]";
}

function Write-LogInvalid {
    [string] $resx = $args[0];
    Write-Host -ForegroundColor Red "$resx query invalid.";
}



function Write-LogNotFound {
    [string] $resx = $args[0];
    [string] $display = $args[1];
    Write-Host -ForegroundColor Yellow "$resx not found: [$display]";
}
