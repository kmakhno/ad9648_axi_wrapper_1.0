
`timescale 1 ns / 1 ps

	module ad9648_axi_wrapper_v1_0_M0_AXIS #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		parameter integer C_M_AXIS_TDATA_WIDTH	= 32
	)
	(
		// Users to add ports here
		input [31:0] num_packets_i, //num packets
		input [31:0] packet_size_i, //packet size in bytes 
		input [C_M_AXIS_TDATA_WIDTH-1:0] data_i,
		input valid_i,
		output ready_o,
		input start_adc_i,
		output wire record_complete_o,
		// User ports ends
		// Do not modify the ports beyond this line

		// Global ports
		input wire  M_AXIS_ACLK,
		// 
		input wire  M_AXIS_ARESETN,
		// Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
		output wire  M_AXIS_TVALID,
		// TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
		output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA,
		// TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
		// output wire [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] M_AXIS_TSTRB,
		// TLAST indicates the boundary of a packet.
		output wire  M_AXIS_TLAST,
		// TREADY indicates that the slave can accept a transfer in the current cycle.
		input wire  M_AXIS_TREADY
	);

	// Add user logic here
	reg [1:0] front_det;
	wire start_adc_d;
	wire [31:0] packet_size_d = {2'b00, packet_size_i[31:2]}; //packet size in a word unit, the word - 4 bytes

	always @(posedge M_AXIS_ACLK) begin
		if (!M_AXIS_ARESETN)
			front_det <= 2'b00;
		else
			front_det <= {front_det[0], start_adc_i};
	end

	reg [31:0] packet_size_q; //packet size in bytes should be configurable from AXI-Lite 
	always @(posedge M_AXIS_ACLK) begin
		if (!M_AXIS_ARESETN)
			packet_size_q <= 0;
		else if (start_adc_d)
			packet_size_q <= 0;
		else if (M_AXIS_TVALID && M_AXIS_TREADY) begin
			packet_size_q <= packet_size_q + 1'b1;
			if (packet_size_q == packet_size_d -1)
				packet_size_q <= 0;
		end
	end

	wire [31:0] packet_cnt_d;
	reg [31:0] packet_cnt_q;
	reg data_transfer_done_q;

	always @(posedge M_AXIS_ACLK) begin
		if (!M_AXIS_ARESETN) begin
			packet_cnt_q <= 0;
			data_transfer_done_q <= 1'b0;
		end else if (start_adc_d) begin
			data_transfer_done_q <= 1'b0;
			packet_cnt_q <= 0;
		end else begin
			packet_cnt_q <= packet_cnt_d;
			if ((packet_cnt_q == num_packets_i-1) && (packet_size_q == packet_size_d-1))
				data_transfer_done_q <= 1'b1;
		end
	end
	
	ila_0 ila0_inst(
        .clk(M_AXIS_ACLK),
        .probe0(num_packets_i),
        .probe1(packet_size_i),
        .probe2(valid_i),
        .probe3(start_adc_d),
        .probe4(packet_size_q),
        .probe5(packet_cnt_q),
        .probe6(data_transfer_done_q)
    );

	assign packet_cnt_d = packet_cnt_q + (packet_size_q == packet_size_d-1);

	assign M_AXIS_TVALID = valid_i && ~data_transfer_done_q;
	assign M_AXIS_TDATA  = data_i;
	assign ready_o       = M_AXIS_TREADY;
	assign M_AXIS_TLAST  = (packet_size_q == packet_size_d-1);
	assign start_adc_d   = (front_det == 2'b01);
	assign record_complete_o = data_transfer_done_q;
	// User logic ends

	endmodule
