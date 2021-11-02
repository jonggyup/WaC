#!/bin/bash

#rd_size=ramdisk size in kb
modprobe -r brd
modprobe brd rd_nr=1 rd_size=8388608
