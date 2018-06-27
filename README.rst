Enigma Docker Network
=====================

The Enigma Docker Network is the first release of the Enigma Protocol in a 
containerized environment that offers a complete minimum viable test network 
(testnet). This release is aimed at developers to familiarize themselves with 
the unique and powerful features that the Enigma Protocol offers, and to 
provide a sandbox to start writing `secret contracts`.

For more information, please refer to the 
`Enigma Protocol Documenatation <https://enigma.co/protocol>`_.

Requirements
------------

- A host machine with Intel `Software Guard Extensions <https://software.intel.com/en-us/sgx>`_ (SGX) enabled.

	- The `SGX hardware <https://github.com/ayeks/SGX-hardware>`_ repository 
	  provides a list of hardware that supports Intel SGX, as well as a simple
	  script to check if SGX is enabled on your system.

- A host machine running Ubuntu 16.04
- A host machine with `Linux SGX driver <https://github.com/intel/linux-sgx-driver>`_ 
  installed. Upon successful installation of the driver ``/dev/isgx`` should be
  present in the system.
- `Docker <https://docs.docker.com/install/overview/>`_
- `Docker Compose <https://docs.docker.com/compose/install/>`_ 

Usage
-----

Launch the ``Enigma Docker Network`` by running:

``./launch_network.bash``

The first time that runs in your system, it will build all the required images.
If you need to rebuild them in the future, run ``docker-compose build``.

Stop the network by running:

``docker-compose down``


Testing
-------

To run the Enigma Docker Network unit tests, run:

``./run_tests.bash``
