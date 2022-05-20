
#ifndef AD9648_AXI_WRAPPER_H
#define AD9648_AXI_WRAPPER_H


/****************** Include Files ********************/
#include "xil_types.h"
#include "xstatus.h"

#define AD_CNTRL_OFFSET 0
#define AD_SPI_TX_BUFF_OFFSET 4
#define AD_SPI_CNTRL_OFFSET 8
#define AD_RELAY_CNTRL_OFFSET 12
#define AD_NUM_PACKETS_OFFSET 16
#define AD9648_AXI_WRAPPER_S0_AXI_SLV_REG5_OFFSET 20
#define AD9648_AXI_WRAPPER_S0_AXI_SLV_REG6_OFFSET 24
#define AD_STS_OFFSET 28
#define AD_SPI_RX_BUFF_OFFSET 32
#define AD_SPI_STATUS_OFFSET 36
#define AD_PACKET_SIZE_OFFSET 40

#define AD9648_RL_AC_COUPLING 0
#define AD9648_RL_DC_COUPLING 1


/**************************** Type Definitions *****************************/
/**
 * This typedef contains configuration information for the device.
 */
typedef struct {
	u16 DeviceId;		/* Unique ID  of device */
	UINTPTR BaseAddress;	/* Device base address */
} Ad9648_Config;

/**
 * Driver instance data. The user is required to allocate a
 * variable of this type for every GPIO device in the system. A pointer
 * to a variable of this type is then passed to the driver API functions.
 */
typedef struct {
	UINTPTR BaseAddress;	/* Device base address */
	u32 IsReady;
} Ad9648;

extern Ad9648_Config Ad9648_ConfigTable[];

/**
 *
 * Write a value to a AD9648_AXI_WRAPPER register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the AD9648_AXI_WRAPPERdevice.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void AD9648_AXI_WRAPPER_mWriteReg(u32 BaseAddress, unsigned RegOffset, u32 Data)
 *
 */
#define AD9648_AXI_WRAPPER_mWriteReg(BaseAddress, RegOffset, Data) \
  	Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))

/**
 *
 * Read a value from a AD9648_AXI_WRAPPER register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the AD9648_AXI_WRAPPER device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	u32 AD9648_AXI_WRAPPER_mReadReg(u32 BaseAddress, unsigned RegOffset)
 *
 */
#define AD9648_AXI_WRAPPER_mReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))

/************************** Function Prototypes ****************************/
/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the AD9648_AXI_WRAPPER instance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
XStatus AD9648_AXI_WRAPPER_Reg_SelfTest(void * baseaddr_p);

Ad9648_Config *Ad9648_LookupConfig(u16 DeviceId);

int Ad9648_CfgInitialize(Ad9648 * InstancePtr, Ad9648_Config * Config, UINTPTR EffectiveAddr);

int Ad9648_Initialize(Ad9648 * InstancePtr, u16 DeviceId);

void Ad9648_StartADC(Ad9648 *InstancePtr);

void Ad9648_SpiWrite(Ad9648 *InstancePtr, u16 Addr, u8 Data);

u32 Ad9648_SpiRead(Ad9648 *InstancePtr, u16 Addr);

void Ad9648_AcDcCoupling(Ad9648 *InstancePtr, u8 AcDc);

void Ad9648_SetNumPackets(Ad9648 *InstancePtr, u32 num_pkt);

void Ad9648_SetPacketSize(Ad9648 *InstancePtr, u32 pkt_size);

u32 Ad9648_RecordComplete(Ad9648 *InstancePtr);

#endif // AD9648_AXI_WRAPPER_H
