#Narit Trikasemsak 2022
#Colby College insite Lab

"""Provides movement functions for Spot Robot."""

import argparse
import sys
import time

from bosdyn.client.lease import LeaseClient, LeaseKeepAlive
from bosdyn.client.robot_command import RobotCommandClient, RobotCommandBuilder, blocking_stand, blocking_sit, blocking_selfright
from bosdyn.client.robot_state import RobotStateClient
from bosdyn.client.time_sync import TimeSyncError
from bosdyn.client.estop import EstopEndpoint, EstopKeepAlive, EstopClient
import bosdyn.client.util

from estop_nogui import EstopNoGui

VELOCITY_BASE_SPEED = 0.5  # m/s
VELOCITY_BASE_ANGULAR = 0.4 # rad/sec
VELOCITY_CMD_DURATION = 2.5  # seconds

class Movement(): 
    """Handles robot movements."""

    def __init__(self, user, password, spotAddress, **kwargs):
        self._user = user
        self._password = password
        self.spotAddress = spotAddress 

        self._isPoweredOn = False
    
            
    def auth(self):
        """Build robot object and authenticate"""
        try:
            #create robot SDK
            sdk = bosdyn.client.create_standard_sdk("Spot BVI")
            #create robot object 
            self._robot = sdk.create_robot(self.spotAddress)
            #authenticate
            self._robot.authenticate(self._user, self._password)

            #Create robot state, robot command, and lease clients
            self._robot_state_client = self._robot.ensure_client(RobotStateClient.default_service_name)
            self._robot_command_client = self._robot.ensure_client(RobotCommandClient.default_service_name)
            self._lease_client = self._robot.ensure_client(LeaseClient.default_service_name)
            self._lease = self._lease_client.acquire()
 
            #create estop
            self._create_estop()

            # Construct our lease keep-alive object, which begins RetainLease calls in a thread.
            self._lease_keep_alive = LeaseKeepAlive(self._lease_client)

            print('lease')

            return True
        except:
            return False

    def _create_estop(self):
        """Create an estop and assign endpoint"""
        self._estop_client = self._robot.ensure_client(EstopClient.default_service_name)
        self._estop_endpoint = bosdyn.client.estop.EstopEndpoint(client=self._estop_client, name='estopper', estop_timeout=9.0)
        self._estop_endpoint.force_simple_setup()
        self._estop_keep_alive = bosdyn.client.estop.EstopKeepAlive(self._estop_endpoint)
        
    def toggle_estop(self):
        """Toggle estop on/off. Initial state is ON"""
        if self._estop_client is not None and self._estop_endpoint is not None:
            if not self._estop_keep_alive:
                self._estop_keep_alive = EstopKeepAlive(self._estop_endpoint)
                print("estop on")
            else:
                self._estop_keep_alive.settle_then_cut()
                self._estop_keep_alive = None
                print("estop off")

    def toggle_lease(self):
        """Toggle lease acquisition. Initial state is acquired"""
        if self._lease_client is not None:
            if self._lease_keep_alive is None:
                self._lease = self._lease_client.acquire()
                self._lease_keep_alive = LeaseKeepAlive(self._lease_client)
            else:
                self._lease_client.return_lease(self._lease)
                self._lease_keep_alive.shutdown()
                self._lease_keep_alive = None

    def toggle_power(self):
        try:
            if self._isPoweredOn:
                self._robot.power_off(cut_immediately=False)
                self._isPoweredOn = False
            else:
                self._robot.power_on()
                self._isPoweredOn = True
            return self._isPoweredOn
        except:
            return self._isPoweredOn

    def _start_command(self, desc, command_proto, end_time_secs=None):
        current_cmd = self._robot_command_client.robot_command_async(lease=None, command=command_proto, end_time_secs=end_time_secs)
        time.sleep(VELOCITY_CMD_DURATION)

    def self_right(self):
        self._start_command('self_right', RobotCommandBuilder.selfright_command())

    def battery_change_pose(self):
        # Default HINT_RIGHT, maybe add option to choose direction?
        self._start_command(
            'battery_change_pose',
            RobotCommandBuilder.battery_change_pose_command(
                dir_hint=basic_command_pb2.BatteryChangePoseCommand.Request.HINT_RIGHT),
                end_time_secs=VELOCITY_CMD_DURATION)

    def sit(self):
        self._start_command('sit', RobotCommandBuilder.synchro_sit_command())

    def stand(self):
        self._start_command('stand', RobotCommandBuilder.synchro_stand_command())

    def move_forward(self):
        self._velocity_cmd_helper('move_forward', v_x=VELOCITY_BASE_SPEED)

    def move_backward(self):
        self._velocity_cmd_helper('move_backward', v_x=-VELOCITY_BASE_SPEED)

    def strafe_left(self):
        self._velocity_cmd_helper('strafe_left', v_y=VELOCITY_BASE_SPEED)

    def strafe_right(self):
        self._velocity_cmd_helper('strafe_right', v_y=-VELOCITY_BASE_SPEED)

    def turn_left(self):
        self._velocity_cmd_helper('turn_left', v_rot=VELOCITY_BASE_ANGULAR)

    def turn_right(self):
        self._velocity_cmd_helper('turn_right', v_rot=-VELOCITY_BASE_ANGULAR)

    def stop(self):
        self._start_command('stop', RobotCommandBuilder.stop_command())

    def _velocity_cmd_helper(self, desc='', v_x=0.0, v_y=0.0, v_rot=0.0):
        """Helper command for movement"""
        self._start_command(
            desc, RobotCommandBuilder.synchro_velocity_command(v_x=v_x, v_y=v_y, v_rot=v_rot),
            end_time_secs=time.time() + VELOCITY_CMD_DURATION)

