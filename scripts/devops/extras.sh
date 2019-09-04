#!/bin/bash -eux

#moved to Kickstart
# show IP at login
#echo '#!/bin/sh' > /etc/rc.d/rc.local
#echo $'IP0=$(/sbin/ip addr show | grep global | grep brd | grep \'inet \' | cut -d: -f2 | awk \'{ print $2}\')' >> /etc/rc.d/rc.local
#echo 'echo "IP: $IP0" > /etc/issue' >> /etc/rc.d/rc.local
#echo 'exit 0' >> /etc/rc.d/rc.local
#chmod a+x /etc/rc.d/rc.local

#copySSHKey($USERNAME,$KEYNAME)
function copySSHKey() {
    local USER=${1?Need user name}
    local KEYNAME=${2?Need key name}

    mkdir -pm 700 /home/$USER/.ssh

    cp /tmp/$KEYNAME.pub /home/$USER/.ssh/
    cp /tmp/$KEYNAME /home/$USER/.ssh/

    touch /home/$USER/.ssh/authorized_keys
    cat /tmp/$KEYNAME.pub >> /home/$USER/.ssh/authorized_keys

    chmod -R go-rwsx /home/$USER/.ssh
    chown -R $USER:$USER /home/$USER
}

#createUser($USERNAME,$USERID,$KEYNAME)
function createUser() {
    local USER=${1?Need user name}
    local USERID=${2?Need user id}
    local GROUPID=${3?Need group id}
    local KEYNAME=${4:-$USER}

    # create group with ID and call it same as the user
    groupadd -g ${GROUPID} ${USER}

    useradd -r -u ${USERID} -m -c "account for container volumes" -G sudo -g ${GROUPID} -s /bin/false ${USER}

    #adduser --system --shell /bin/bash --groups wheel --groups root --groups sudo --create-home --user-group -g ${GROUPID} --uid $USERID $USER

    copySSHKey "$USER" "$KEYNAME"

}

groupadd -r sudo

groupadd docker

usermod -aG docker aemdesign

# allow users part of sudo group to do paswordless sudo
#sed -i '$ a\%sudo ALL=(ALL) NOPASSWD:ALL' /etc/sudoers

copySSHKey "root" "docker"
copySSHKey "aemdesign" "aemdesign"
copySSHKey "aemdesign" "gitlab"

createUser "jenkins" 10001 10001
createUser "nexus" 10002 10002
createUser "deploy" 10003 10003
createUser "esb" 10004 10004
createUser "devops" 10005 10005

