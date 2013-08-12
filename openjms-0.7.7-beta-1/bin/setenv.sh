# ---------------------------------------------------------------------------
# Sample environment script for OpenJMS
#
# This is invoked by openjms.sh to configure:
# . the CLASSPATH, for JDBC drivers
# . JVM options
# . JSSE, when using the TCPS connector
# ---------------------------------------------------------------------------

# Configure the JDBC driver
#
CLASSPATH=$OPENJMS_HOME/lib/derby-10.1.1.0.jar

# Configure JVM options
#
#    JAVA_OPTS=-Xmx256m

# Configure JSSE
#
#  The following line is optional, and is only required if JDK 1.2 or 
#  JDK 1.3 is being used, and JSSE isn't installed as an extension
#
#    JSSE_HOME=<insert JSSE directory path here>

# Configure Derby
JAVA_OPTS="$JAVA_OPTS -Dderby.system.home=$OPENJMS_HOME/db"
