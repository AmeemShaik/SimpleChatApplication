#!/bin/sh
# -----------------------------------------------------------------------------
# Start/Stop Script for the OpenJMS Server
#
# Required Environment Variables
#
#   JAVA_HOME       Points to the Java Development Kit installation.
#
# Optional Environment Variables
# 
#   OPENJMS_HOME    Points to the OpenJMS installation directory.
#
#   JAVA_OPTS       Java runtime options used when the "run", "start", or
#                   "stop" command is executed.
#
#   JSSE_HOME       Points to the  Java Secure Sockets Extension
#                   (JSSE) installation, whose JAR files will be added to the
#                   system class path used to start OpenJMS.
#
# $Id: openjms.sh,v 1.2 2005/06/13 23:10:15 tanderson Exp $
# -----------------------------------------------------------------------------

# OS specific support.  $var _must_ be set to either true or false.
cygwin=false
case "`uname`" in
CYGWIN*) cygwin=true;;
esac

# For Cygwin, ensure paths are in UNIX format before anything is touched
if $cygwin; then
  [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --unix "$JAVA_HOME"`
  [ -n "$OPENJMS_HOME" ] && OPENJMS_HOME=`cygpath --unix "$OPENJMS_HOME"`
  [ -n "$CLASSPATH" ] && CLASSPATH=`cygpath --path --unix "$CLASSPATH"`
  [ -n "$JSSE_HOME" ] && JSSE_HOME=`cygpath --path --unix "$JSSE_HOME"`
fi

if [ -z "$JAVA_HOME" ]; then
  echo "The JAVA_HOME environment variable is not set."
  echo "This is required to run OpenJMS."
  exit 1
fi
if [ ! -r "$JAVA_HOME"/bin/java ]; then
  echo "The JAVA_HOME environment variable is not set correctly."
  echo "This is required to run OpenJMS."
  exit 1
fi
_RUNJAVA="$JAVA_HOME"/bin/java


# Guess OPENJMS_HOME if it is not set
if [ -z "$OPENJMS_HOME" ]; then
# resolve links - $0 may be a softlink
  PRG="$0"
  while [ -h "$PRG" ]; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '.*/.*' > /dev/null; then
      PRG="$link"
    else
      PRG=`dirname "$PRG"`/"$link"
    fi
  done

  PRGDIR=`dirname "$PRG"`
  OPENJMS_HOME=`cd "$PRGDIR/.." ; pwd`
elif [ ! -r "$OPENJMS_HOME"/bin/openjms.sh ]; then
  echo "The OPENJMS_HOME environment variable is not set correctly."
  echo "This is required to run OpenJMS."
  exit 1
fi

# Set CLASSPATH to empty by default. User jars can be added via the setenv.sh
# script
CLASSPATH=

if [ -r "$OPENJMS_HOME"/bin/setenv.sh ]; then
  . "$OPENJMS_HOME"/bin/setenv.sh
fi

# Add on extra jar files to CLASSPATH
if [ -n "$JSSE_HOME" ]; then
  CLASSPATH="$CLASSPATH":"$JSSE_HOME"/lib/jcert.jar:"$JSSE_HOME"/lib/jnet.jar:"$JSSE_HOME"/lib/jsse.jar
fi
CLASSPATH="$CLASSPATH":"$OPENJMS_HOME"/lib/openjms-0.7.7-beta-1.jar:"$OPENJMS_HOME"/lib/openjms-tools-0.7.7-beta-1.jar

# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
  JAVA_HOME=`cygpath --path --windows "$JAVA_HOME"`
  OPENJMS_HOME=`cygpath --path --windows "$OPENJMS_HOME"`
  CLASSPATH=`cygpath --path --windows "$CLASSPATH"`
  JSSE_HOME=`cygpath --path --windows "$JSSE_HOME"`
fi

POLICY_FILE="$OPENJMS_HOME"/config/openjms.policy

# Execute the requested command

echo "Using OPENJMS_HOME: $OPENJMS_HOME"
echo "Using JAVA_HOME:    $JAVA_HOME"

if [ "$1" = "run" ]; then

  shift
  exec "$_RUNJAVA" $JAVA_OPTS -Dopenjms.home="$OPENJMS_HOME" \
      -classpath "$CLASSPATH" \
      -Djava.security.manager -Djava.security.policy="$POLICY_FILE" \
      org.exolab.jms.server.JmsServer "$@"

elif [ "$1" = "start" ] ; then

  shift
  "$_RUNJAVA" $JAVA_OPTS -Dopenjms.home="$OPENJMS_HOME" \
      -classpath "$CLASSPATH" \
      -Djava.security.manager -Djava.security.policy="$POLICY_FILE" \
      org.exolab.jms.server.JmsServer "$@"

elif [ "$1" = "stop" ] ; then

  shift
  exec "$_RUNJAVA" $JAVA_OPTS -Dopenjms.home="$OPENJMS_HOME" \
      -classpath "$CLASSPATH" \
      -Djava.security.manager -Djava.security.policy="$POLICY_FILE" \
      org.exolab.jms.tools.admin.AdminMgr "$@" -stopServer

elif [ "$1" = "admin" ] ; then

  shift
  exec "$_RUNJAVA" $JAVA_OPTS -Dopenjms.home="$OPENJMS_HOME" \
      -classpath "$CLASSPATH" \
      -Djava.security.manager -Djava.security.policy="$POLICY_FILE" \
      org.exolab.jms.tools.admin.AdminMgr "$@"

else

  echo "usage: openjms.sh (commands)"
  echo "commands:"
  echo "  run          Start OpenJMS in the current window"
  echo "  start        Start OpenJMS in a separate window"
  echo "  stop         Stop OpenJMS"
  echo "  admin        Start OpenJMS Administrator"
  exit 1

fi
