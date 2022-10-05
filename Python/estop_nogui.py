# Narit Trikasemsak 2022
# Colby College insite Lab

"""Configures the Motor Power Authority (software E-Stop) for Spot. 

Allows operators to kill motor power immediately if needed. 
"""

from bosdyn.client.estop import EstopEndpoint, EstopKeepAlive, EstopClient
from bosdyn.client.robot_state import RobotStateClient
import bosdyn.client.util


class EstopNoGui():
    """Provides a software estop without a GUI.
    
    To use this estop, create an instance of the EstopNoGui class and use the stop() and allow()
    functions.
    """

    def __init__(self, client, timeout_sec, name=None):
        # Force server to set up a single endpoint system
        ep = EstopEndpoint(client, name, timeout_sec)
        ep.force_simple_setup()

        # Begin periodic check-in between keep-alive and robot
        self.estop_keep_alive = EstopKeepAlive(ep)

        # Release the estop
        self.estop_keep_alive.allow()

    def __enter__(self):
        pass

    def __exit__(self, exc_type, exc_val, exc_tb):
        """Cleanly shut down estop on exit."""
        self.estop_keep_alive.end_periodic_check_in()

    def stop(self):
        self.estop_keep_alive.stop()

    def allow(self):
        self.estop_keep_alive.allow()

    def settle_then_cut(self):
        self.estop_keep_alive.settle_then_cut()

