#!/bin/sh

JAVA_START_HEAP=${JAVA_START_HEAP:-32m}
JAVA_MAX_HEAP=${JAVA_MAX_HEAP:-512m}
JAVA_DIR="/usr/share/java"
JAVACMD="/usr/bin/java"
LIB_DIR="/aws-kinesis-agent/lib"
CLASSPATH="$LIB_DIR":$(echo $(find "$LIB_DIR" -type f -name \*.jar) |sed 's# #:#g'):"${JAVA_DIR}/*":"${CLASSPATH}"
OOME_ARGS="-XX:OnOutOfMemoryError=\"/bin/kill -9 %p\""
JVM_ARGS="-server -Xms${JAVA_START_HEAP} -Xmx${JAVA_MAX_HEAP} $JVM_ARGS"
MAIN_CLASS="com.amazon.kinesis.streaming.agent.Agent"
exec $JAVACMD $JVM_ARGS "$OOME_ARGS" \
	-cp "$CLASSPATH" \
	$MAIN_CLASS "$@"
