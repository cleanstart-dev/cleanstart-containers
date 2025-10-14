@echo off
REM NATS Server Test Script for Windows
REM This script tests basic NATS server functionality

setlocal enabledelayedexpansion

set NATS_HOST=localhost
set NATS_PORT=4222
set MONITOR_PORT=8222
set CONTAINER_NAME=nats-server

echo.
echo 🧪 NATS Server Test Script
echo ================================
echo.

REM Test 1: Check if container is running
echo 📦 Test 1: Checking if NATS container is running...
docker ps | findstr /C:"%CONTAINER_NAME%" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✅ Container is running
) else (
    echo ❌ Container is not running
    echo    Start with: docker-compose up -d
    exit /b 1
)
echo.

REM Test 2: Check container logs
echo 📋 Test 2: Checking container logs...
docker logs %CONTAINER_NAME% 2>&1 | findstr /C:"Server is ready" /C:"Listening for client connections" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✅ NATS server is ready
) else (
    echo ⚠️  Server status unclear, showing recent logs:
    docker logs %CONTAINER_NAME% 2>&1 | powershell -Command "$input | Select-Object -Last 5"
)
echo.

REM Test 3: Check monitoring endpoint
echo 📊 Test 3: Checking HTTP monitoring endpoint...
curl -s "http://%NATS_HOST%:%MONITOR_PORT%/varz" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✅ Monitoring endpoint is accessible
    echo    URL: http://%NATS_HOST%:%MONITOR_PORT%
) else (
    echo ❌ Monitoring endpoint is not accessible
)
echo.

REM Test 4: Get server statistics
echo 📈 Test 4: Fetching server statistics...
curl -s "http://%NATS_HOST%:%MONITOR_PORT%/varz" > nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✅ Successfully retrieved server stats
    echo.
    echo    You can view detailed stats at:
    echo    http://%NATS_HOST%:%MONITOR_PORT%/varz
) else (
    echo ❌ Failed to retrieve server stats
)
echo.

REM Summary
echo ================================
echo 🎉 Tests completed!
echo.
echo 📊 Monitoring URLs:
echo    Server Info:    http://%NATS_HOST%:%MONITOR_PORT%/varz
echo    Connections:    http://%NATS_HOST%:%MONITOR_PORT%/connz
echo    Routes:         http://%NATS_HOST%:%MONITOR_PORT%/routez
echo    Subscriptions:  http://%NATS_HOST%:%MONITOR_PORT%/subsz
echo.
echo 🔗 Connection String: nats://%NATS_HOST%:%NATS_PORT%
echo.
echo 🎯 To manually test publishing and subscribing:
echo.
echo    Terminal 1 (Subscribe):
echo    docker exec -it %CONTAINER_NAME% sh
echo.
echo    Terminal 2 (Publish):
echo    docker exec -it %CONTAINER_NAME% sh
echo.

endlocal

