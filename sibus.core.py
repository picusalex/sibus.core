#!/usr/bin/env python
# -*- coding: utf-8 -*-

import signal
import sys
import time

from sibus_lib import BusCore
from sibus_lib import sibus_init

PROGRAM_NAME = "bus.core"
logger, cfg_data = sibus_init(PROGRAM_NAME)

logger.info("####################################################")
buscore = BusCore()
buscore.start()

def sigterm_handler(_signo=None, _stack_frame=None):
    buscore.stop()
    logger.info("Program terminated correctly")
    sys.exit(0)

signal.signal(signal.SIGTERM, sigterm_handler)

try:
    while 1:
        time.sleep(10)
except KeyboardInterrupt:
    logger.info("Ctrl+C detected !")
except Exception as e:
    buscore.stop()
    logger.exception("Program terminated incorrectly ! ", e)
    sys.exit(1)
finally:
    sigterm_handler()

