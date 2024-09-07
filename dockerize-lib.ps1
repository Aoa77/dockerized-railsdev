#!/usr/bin/env pwsh

function Invoke-DockerizeRailsDev {

    Write-Host -ForegroundColor Blue " ====================="; 
    Write-Host -ForegroundColor Cyan "[ dockerized-railsdev ]"; 
    Write-Host -ForegroundColor Blue " =====================";

    [bool] $decision = $false;
    [string] $container_name = "railsdev";
    [string] $image_name = "ubuntu";
    [string] $image_tag = "aoa77-railsdev";

    Write-Host;
    [string] $status = Get-ContainerStatus $container_name;
    if ($status.Length -gt 0) {
        # $decision = Confirm-DockerAction "Stop and remove?" -default 0;
        # if ($decision -eq $false) {
        #     return;
        # }
        docker stop $container_name > $null;
        docker rm $container_name > $null;
    }

    Write-Host;
    Write-Host;

    $status = Get-ImageStatus $image_name $image_tag;
    [string] $display_name = $image_name + ":" + $image_tag;
    if ($status.Length -gt 0) {
        # $decision = Confirm-DockerAction "Remove and rebuild?" -default 1;
        # if ($decision -eq $true) {
            docker image rm $display_name --force;
        #}
    }
    
    Write-Host;
    Write-Host;

    $status = Get-ImageStatus $image_name $image_tag;
    if ($status.Length -eq 0) {
        Write-Host -ForegroundColor Green "Building image [$display_name]...";
        docker build -t $display_name .;
    }

    Write-Host;
    Write-Host;
    Write-Host -ForegroundColor Green "Connecting to interactive session...";
    docker run -it --name $container_name $display_name;
}

function Confirm-DockerAction([string] $message, [int] $default) {
    [string] $title = "";
    $choices = "&Yes", "&No"
    $decision = $Host.UI.PromptForChoice($title, $message, $choices, $default);
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
