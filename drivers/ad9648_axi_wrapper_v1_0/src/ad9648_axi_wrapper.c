

/***************************** Include Files *******************************/
#include "xparameters.h"
#include "xil_io.h"
#include "ad9648_axi_wrapper.h"

/************************** Function Definitions ***************************/
Ad9648_Config *Ad9648_LookupConfig(u16 DeviceId)
{
	Ad9648_Config *CfgPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_AD9648_AXI_WRAPPER_NUM_INSTANCES; Index++) {
		if (Ad9648_ConfigTable[Index].DeviceId == DeviceId) {
			CfgPtr = &Ad9648_ConfigTable[Index];
			break;
		}
	}

	return CfgPtr;
}

int Ad9648_CfgInitialize(Ad9648 * InstancePtr, Ad9648_Config * Config, UINTPTR EffectiveAddr)
{
	/* Assert arguments */
	Xil_AssertNonvoid(InstancePtr != NULL);

	/* Set some default values. */
	InstancePtr->BaseAddress = EffectiveAddr;

	/*
	 * Indicate the instance is now ready to use, initialized without error
	 */
	InstancePtr->IsReady = XIL_COMPONENT_IS_READY;
	return (XST_SUCCESS);
}

int Ad9648_Initialize(Ad9648 * InstancePtr, u16 DeviceId)
{
	Ad9648_Config *ConfigPtr;

	/*
	 * Assert arguments
	 */
	Xil_AssertNonvoid(InstancePtr != NULL);

	/*
	 * Lookup configuration data in the device configuration table.
	 * Use this configuration info down below when initializing this
	 * driver.
	 */
	ConfigPtr = Ad9648_LookupConfig(DeviceId);
	if (ConfigPtr == (Ad9648_Config *) NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return Ad9648_CfgInitialize(InstancePtr, ConfigPtr,
				   ConfigPtr->BaseAddress);
}

void Ad9648_StartADC(Ad9648 *InstancePtr)
{
	/* Assert arguments */
	Xil_AssertNonvoid(InstancePtr != NULL);

	/* Clear start bit*/
	AD9648_AXI_WRAPPER_mWriteReg(InstancePtr->BaseAddress, AD_CNTRL_OFFSET, 0);

	/* Set start bit */
	AD9648_AXI_WRAPPER_mWriteReg(InstancePtr->BaseAddress, AD_CNTRL_OFFSET, 1);
}

void Ad9648_SpiWrite(Ad9648 *InstancePtr, u16 Addr, u8 Data)
{
	/* Assert arguments */
	Xil_AssertNonvoid(InstancePtr != NULL);

	/* Create SPI command */
	u32 cmd = (((Addr & 0x1fff) << 8) | Data) & 0x00ffffff;

	/* Write cmd to SPI TX buffer */
	AD9648_AXI_WRAPPER_mWriteReg(InstancePtr->BaseAddress, AD_SPI_TX_BUFF_OFFSET, cmd);

	/* Initiate transaction */
	AD9648_AXI_WRAPPER_mWriteReg(InstancePtr->BaseAddress, AD_SPI_CNTRL_OFFSET, 0x80000000);

	/* Check that data is transmited */
	while (AD9648_AXI_WRAPPER_mReadReg(InstancePtr->BaseAddress, AD_SPI_STATUS_OFFSET) == 0);

	/* Clear transaction flag */
	AD9648_AXI_WRAPPER_mWriteReg(InstancePtr->BaseAddress, AD_SPI_CNTRL_OFFSET, 0x0);
}

u32 Ad9648_SpiRead(Ad9648 *InstancePtr, u16 Addr)
{
	u32 Data;
	/* Assert arguments */
	Xil_AssertNonvoid(InstancePtr != NULL);

	/* Create SPI command */
	u32 cmd = ((1 << 23) | ((Addr & 0x1fff) << 8)) & 0x00ffffff;

	/* Write cmd to SPI TX buffer */
	AD9648_AXI_WRAPPER_mWriteReg(InstancePtr->BaseAddress, AD_SPI_TX_BUFF_OFFSET, cmd);

	/* Initiate transaction */
	AD9648_AXI_WRAPPER_mWriteReg(InstancePtr->BaseAddress, AD_SPI_CNTRL_OFFSET, 0x80000000);

	/* Check that data is transmited */
	while (AD9648_AXI_WRAPPER_mReadReg(InstancePtr->BaseAddress, AD_SPI_STATUS_OFFSET) == 0);

	/* Read data from RX buffer */
	Data = AD9648_AXI_WRAPPER_mReadReg(InstancePtr->BaseAddress, AD_SPI_RX_BUFF_OFFSET);

	return Data;
}

/*
*	AcDc=0 -- AC coupling, low gain  (-25 < V < 25 )
*	AcDc=1 -- DC coupling, high gain (-1 < V < 1)
*   for more details see https://digilent.com/reference/zmod/scope/reference-manual 
*/
void Ad9648_AcDcCoupling(Ad9648 *InstancePtr, u8 AcDc)
{
	/* Assert arguments */
	Xil_AssertNonvoid(InstancePtr != NULL);

	AD9648_AXI_WRAPPER_mWriteReg(InstancePtr->BaseAddress, AD_RELAY_CNTRL_OFFSET, AcDc ? 0x80000000 : 0);
}

void Ad9648_SetNumPackets(Ad9648 *InstancePtr, u32 num_pkt)
{
	/* Assert arguments */
	Xil_AssertNonvoid(InstancePtr != NULL);

	AD9648_AXI_WRAPPER_mWriteReg(InstancePtr->BaseAddress, AD_NUM_PACKETS_OFFSET, num_pkt);
}

/*
*	pkt_size -- in bytes
*/
void Ad9648_SetPacketSize(Ad9648 *InstancePtr, u32 pkt_size)
{
	/* Assert arguments */
	Xil_AssertNonvoid(InstancePtr != NULL);

	AD9648_AXI_WRAPPER_mWriteReg(InstancePtr->BaseAddress, AD_PACKET_SIZE_OFFSET, pkt_size);
}

u32 Ad9648_RecordComplete(Ad9648 *InstancePtr)
{
	u32 Data;
	/* Assert arguments */
	Xil_AssertNonvoid(InstancePtr != NULL);

	Data = AD9648_AXI_WRAPPER_mReadReg(InstancePtr->BaseAddress, AD_STS_OFFSET);

	return Data;
}