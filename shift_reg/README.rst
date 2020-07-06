Serial In Parallel Out (SIPO) and Parallel In Serial Out (PISO) Shift Registers
-------------------------------------------------------------------------------

These cores were originally designed to wrap IP cores for stand-alone synthesis in
devices that have fewer IO pins than the core. Intel's Quartus tools have the
``VIRTUAL_PIN`` functionality that supports this use case. However, the virtual
pin flow does not support netlist generation for timing simulation or power
estimation. In Vivado Xilinx offers the out-of-context flow for cores, but this
still seems to require a physical region of the device to be allocated.
Xilinx's ISE for older devices doesn't seem to offer anything other than
disabling pin insertion and logic trimming, which will not give an accurate
result. These shift registers can be used to connect all of the core input
(except for clock and reset signals) and output to a couple of device pins.

Given this use case the focus was to use minimal logic and allow the placer
flexibility in where to put the core. Therefore, the cores use Verilog
attributes to disable use of shift register cells that would tie the IP core
close to device pins. Useful control signals such as ready, valid, etc. are not
included to reduce logic usage.

Similar work is performed by the `SymbiFlow fpga-tool-perf`_ project's `wrapper
script`_. Using these modules adds external dependencies for simple
functionality, but is easier for manually developed wrappers, adds hierarchy to
ease removal of the wrapper during resource analysis, and isolates complexities
such as HDL directives.

.. _`SymbiFlow fpga-tool-perf`: https://github.com/SymbiFlow/fpga-tool-perf
.. _`wrapper script`: https://github.com/SymbiFlow/fpga-tool-perf/blob/master/wrapper.py

