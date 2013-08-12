rem ---------------------------------------------------------------------------
rem Sample environment script for OpenJMS
rem
rem This is invoked by openjms.bat to configure:
rem . the CLASSPATH, for JDBC drivers
rem . JVM options
rem . JSSE, when using the TCPS connector
rem ---------------------------------------------------------------------------

rem Configure the JDBC driver
rem
set CLASSPATH=%OPENJMS_HOME%/lib/derby-10.1.1.0.jar

rem Configure JVM options
rem
rem    set JAVA_OPTS=-Xmx256m

rem Configure JSSE
rem
rem  The following line is optional, and is only required if JDK 1.2 or 
rem  JDK 1.3 is being used, and JSSE isn't installed as an extension
rem
rem    set JSSE_HOME=<insert JSSE directory path here>

rem Configure Derby
set JAVA_OPTS=%JAVA_OPTS% -Dderby.system.home=%OPENJMS_HOME%\db
