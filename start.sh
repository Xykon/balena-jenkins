#!/bin/bash

# Start sshd
/usr/sbin/sshd -D -e &

start_jenkins_master () {
    # Starting Jenkins for master
    echo "[ JENKINS ] : Starting Jenkins master ..."
    java -Dhudson.DNSMultiCast.disabled=true -Dhudson.udp=-1 -jar /usr/src/app/jenkins.war &
}

start_jenkins_slave () {
    # Starting Jenkins for slave/agent
    if [ -z ${PROTOCOL} ]; then
        PROTOCOL='http'
    fi
    echo "[ JENKINS ] : Starting Jenkins slave/agent: '{$SLAVE_NAME}' ..."
    java -jar /usr/src/app/agent.jar -jnlpUrl $PROTOCOL://$MASTER_IP:$MASTER_PORT/computer/$SLAVE_NAME/slave-agent.jnlp -secret $MASTER_SECRET -workDir $SLAVE_WORK_DIR -noReconnect &
}

# Starting all local processes
if [ -z ${RUN_MASTER+x} ]; then
    # Jenkins Slave Device
    start_jenkins_slave
else
    # Jenkins Master Device
    start_jenkins_master
fi
