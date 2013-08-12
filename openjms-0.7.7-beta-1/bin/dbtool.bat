@echo off
rem ---------------------------------------------------------------------------
rem Script for the OpenJMS database tool
rem
rem Required Environment Variables
rem
rem   JAVA_HOME       Points to the Java Development Kit installation.
rem
rem Optional Environment Variables
rem 
rem   OPENJMS_HOME    Points to the OpenJMS installation directory.
rem
rem   JAVA_OPTS       Java runtime options
rem
rem $Id: dbtool.bat,v 1.1 2004/11/26 02:59:09 tanderson Exp $
rem ---------------------------------------------------------------------------

if "%OS%" == "Windows_NT" setlocal

if not "%JAVA_HOME%" == "" goto gotJavaHome
echo The JAVA_HOME environment variable is not set.
echo This is required to run OpenJMS.
exit /B 1

:gotJavaHome

if exist "%JAVA_HOME%\bin\java.exe" goto okJavaHome
echo The JAVA_HOME environment variable is not set correctly.
echo This is required to run OpenJMS.
exit /B 1

:okJavaHome

set _RUNJAVA="%JAVA_HOME%\bin\java"

rem Guess OPENJMS_HOME if it is not set
if not "%OPENJMS_HOME%" == "" goto gotOpenJMSHome
set OPENJMS_HOME=.
if exist "%OPENJMS_HOME%\bin\dbtool.bat" goto okOpenJMSHome
set OPENJMS_HOME=..
if exist "%OPENJMS_HOME%\bin\dbtool.bat" goto okOpenJMSHome
echo The OPENJMS_HOME variable is not set.
echo This is required to run OpenJMS.
exit /B 1

:gotOpenJMSHome

if exist "%OPENJMS_HOME%\bin\dbtool.bat" goto okOpenJMSHome
echo The OPENJMS_HOME variable is not set correctly.
echo This is required to run OpenJMS.
exit /B 1

:okOpenJMSHome

rem Set CLASSPATH to empty by default. User jars can be added via the 
rem setenv.bat script
set CLASSPATH=
if exist "%OPENJMS_HOME%\bin\setenv.bat" call "%OPENJMS_HOME%\bin\setenv.bat"

rem Add on extra jar files to CLASSPATH
if "%JSSE_HOME%" == "" goto noJSSE
set CLASSPATH=%CLASSPATH%;%JSSE_HOME%\lib\jcert.jar;%JSSE_HOME%\lib\jnet.jar;%JSSE_HOME%\lib\jsse.jar
:noJSSE

set CLASSPATH=%CLASSPATH%;%OPENJMS_HOME%\lib\openjms-tools-0.7.7-beta-1.jar
set POLICY_FILE=%OPENJMS_HOME%\config\openjms.policy

rem Execute the requested command

echo Using OPENJMS_HOME: %OPENJMS_HOME%
echo Using JAVA_HOME:    %JAVA_HOME%
echo Using CLASSPATH:    %CLASSPATH%

rem Get remaining unshifted command line arguments and save them 
set CMD_LINE_ARGS=
:setArgs
if ""%1""=="""" goto doneSetArgs
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto setArgs
:doneSetArgs

rem Execute Java with the applicable properties

%_RUNJAVA% %JAVA_OPTS% -classpath "%CLASSPATH%" -Djava.security.manager -Djava.security.policy="%POLICY_FILE%" -Dopenjms.home="%OPENJMS_HOME%" org.exolab.jms.tools.db.DBTool %CMD_LINE_ARGS%
