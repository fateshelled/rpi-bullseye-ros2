#!/bin/bash
SCRIPT_DIR=$(cd $(dirname $0); pwd)
_USER=${SCRIPT_DIR##*home/}
USER=${_USER%%/*}

ROS_BUILD_DIR="/home/$USER/ros2_galactic"
ROS_INSTALL_DIR="/home/$USER/galactic"

sudo bash $SCRIPT_DIR/install-list/apt.bash $SCRIPT_DIR/install-list/apt-list.txt
pip3 install -r $SCRIPT_DIR/install-list/requirements.txt

# sudo pip install
sudo pip install vcstool colcon-common-extensions

# if ~/ros2_galactic/src is exist, skip
if [ ! -d $ROS_BUILD_DIR/src ]; then
    mkdir -p $ROS_BUILD_DIR/src
    cd $ROS_BUILD_DIR
    wget https://raw.githubusercontent.com/ros2/ros2/galactic/ros2.repos
    vcs import src < ros2.repos
else
    echo "$ROS_BUILD_DIR/src is exist"
fi

cp $SCRIPT_DIR/rcutils/CMakeLists.txt $ROS_BUILD_DIR/src/rcutils/

# Build ROS2
cd $ROS_BUILD_DIR/

colcon build --continue-on-error \
--install-base $ROS_INSTALL_DIR \
--packages-skip-build-finished \
--packages-skip-up-to \
rviz_ogre_vendor \
rviz_rendering \
rviz_common \
rviz_rendering_tests \
rviz_visual_testing_framework \
rviz2

rm -rf $ROS_BUILD_DIR