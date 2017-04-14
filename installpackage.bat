@echo off

REM Adobe Creative Cloud Packager example installation script
REM Place this script inside your package directory, alongside the cpp package description file
REM and run it script with administrative privileges - please make certain that Creative Cloud Packager
REM is not running when executing this script
REM For support, please visit https://helpx.adobe.com/support.html
REM Adobe Enterprise Support EMEA

@setlocal enableextensions
@cd /d "%~dp0"


:check_Permissions

    net session >nul 2>&1
    if %errorLevel% == 0 (
        REM no message if admin privileges were detected
    ) else (
        echo Please run this script with administrative privileges.
        echo Press any key to exit.
        pause >nul
        goto END
    )

:close_Adobe_tools
taskkill /f /im "acrotray.exe" >nul 2>&1
taskkill /f /im "Acrobat Updater.exe" >nul 2>&1
taskkill /f /im "Adobe Desktop Service.exe" >nul 2>&1
taskkill /f /im "Creative Cloud.exe" >nul 2>&1
taskkill /f /im "CCLibrary.exe" >nul 2>&1
taskkill /f /im "CoreSync.exe" >nul 2>&1
taskkill /f /im "node.exe" >nul 2>&1
taskkill /f /im "AdobeARM.exe" >nul 2>&1
taskkill /f /im "AdobeCollabSync.exe" >nul 2>&1
taskkill /f /im "AAM Updater.exe" >nul 2>&1
taskkill /f /im "AdobeIPCBroker.exe" >nul 2>&1
taskkill /f /im "Adobe CEF Helper.exe" >nul 2>&1
taskkill /f /im "AcroCEF.exe" >nul 2>&1
taskkill /f /im "PDApp.exe" >nul 2>&1

:AcrobatXI
REM To explicitly specify the application language, use the additional parameter --installLanguage
REM e.g. ExceptionDeployer --workflow=install --mode=pre --installLanguage "fr_FR"
REM otherwise the operating system language will be used

IF NOT EXIST "Exceptions" GOTO BUILD
cd Exceptions
IF NOT EXIST "AcrobatProfessional11*" GOTO ACROBATXI_END
 echo Installing Acrobat XI...

 ExceptionDeployer --workflow=install --mode=pre
 IF %errorlevel% neq 0 exit /b %errorlevel%
:ACROBATXI_END
cd ..



:BUILD
REM Install applications from the "Build" subdirectory
IF NOT EXIST "Build" GOTO END
echo Installing license selection and any applications in the "Build" directory

cd Build
start /wait setup.exe --silent
IF %errorlevel% neq 0 exit /b %errorlevel%
cd ..


:PostExceptions
echo Installing any remaining applications from the "Exceptions" directory

cd Exceptions
 IF Exist ExceptionDeployer.exe ExceptionDeployer.exe --workflow=install --mode=post
 IF %errorlevel% neq 0 exit /b %errorlevel%
cd ..

:END
