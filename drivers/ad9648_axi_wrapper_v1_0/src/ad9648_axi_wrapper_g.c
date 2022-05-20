#include "xparameters.h"
#include "ad9648_axi_wrapper.h"

/**
 * This table contains configuration information for each GPIO device
 * in the system.
 */
Ad9648_Config Ad9648_ConfigTable[] = {
	{
#ifdef XPAR_AD9648_AXI_WRAPPER_NUM_INSTANCES
	 XPAR_AD9648_AXI_WRAPPER_0_DEVICE_ID,
	 XPAR_AD9648_AXI_WRAPPER_0_S0_AXI_BASEADDR
#endif
	}
};