
`timescale 1 ns / 1 ps

	module ad9648_axi_wrapper_v1_0_M0_AXIS #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		parameter integer C_M_AXIS_TDATA_WIDTH	= 32,
		parameter integer FIFO_WIDTH = 16
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

	always @(posedge M_AXIS_ACLK) begin
		if (!M_AXIS_ARESETN)
			front_det <= 2'b00;
		else
			front_det <= {front_det[0], start_adc_i};
	end
	
    wire [31:0] word_num_d = {2'b00, packet_size_i[31:2]};
    
    wire fifo_empty_d, fifo_full_d;
    wire [C_M_AXIS_TDATA_WIDTH-1:0] fifo_dout_d;
    wire fifo_valid_d;
    
    reg [C_M_AXIS_TDATA_WIDTH-1:0] fifo_q[0:FIFO_WIDTH-1];
    reg [$clog2(FIFO_WIDTH):0] rptr_q, wptr_q;
    reg [31:0] word_cnt_q;
    reg [31:0] pkt_cnt_q;
    reg [C_M_AXIS_TDATA_WIDTH-1:0] m_axis_data_q;
    reg pkt_sent_q;
    reg record_complete_q;
    reg m_axis_valid_q;
    
    assign fifo_empty_d = (rptr_q == wptr_q);
    assign fifo_full_d = (rptr_q == {~wptr_q[$clog2(FIFO_WIDTH)], {wptr_q[$clog2(FIFO_WIDTH)-1:0]}});
    
    always @(posedge M_AXIS_ACLK) begin
        if (!M_AXIS_ARESETN || start_adc_d) begin
            wptr_q <= 0;
        end else if (ready_o && valid_i) begin
            fifo_q[wptr_q[$clog2(FIFO_WIDTH)-1:0]] <= data_i;
            wptr_q <= wptr_q + 1'b1;    
        end
    end
    
    always @(posedge M_AXIS_ACLK) begin
        if (!M_AXIS_ARESETN || start_adc_d) begin
            rptr_q <= 0;
        end else if (fifo_valid_d && M_AXIS_TREADY) begin
            rptr_q <= rptr_q + 1'b1;
        end
    end
    
    assign fifo_dout_d =  fifo_valid_d ? fifo_q[rptr_q[$clog2(FIFO_WIDTH)-1:0]] : 0;
    assign fifo_valid_d = ~fifo_empty_d;
    
    always @(posedge M_AXIS_ACLK) begin
        if (!M_AXIS_ARESETN || start_adc_d) begin
            word_cnt_q <= 0;
        end else begin
            if ((word_cnt_q == word_num_d-1) && M_AXIS_TREADY)
                word_cnt_q <= 0;
            else if (fifo_valid_d && M_AXIS_TREADY)
                word_cnt_q <= word_cnt_q + 1'b1;
        end
    end
    
    always @(posedge M_AXIS_ACLK) begin
        if (!M_AXIS_ARESETN || start_adc_d) begin
            pkt_sent_q <= 1'b0;
        end else begin
            if ((word_cnt_q == word_num_d-1)&& M_AXIS_TREADY)
                pkt_sent_q <= 1'b1;
            else 
                pkt_sent_q <= 1'b0;
        end
    end
    
    always @(posedge M_AXIS_ACLK) begin
        if (!M_AXIS_ARESETN || start_adc_d)
            pkt_cnt_q <= 0;
        else if (pkt_sent_q)
            pkt_cnt_q <= pkt_cnt_q + 1'b1;
    end
    
    always @(posedge M_AXIS_ACLK) begin
        if (!M_AXIS_ARESETN || start_adc_d)
            m_axis_data_q <= 0;
        else
            m_axis_data_q <= fifo_dout_d;
    end
    
    always @(posedge M_AXIS_ACLK) begin
        if (!M_AXIS_ARESETN || start_adc_d)
            record_complete_q <= 1'b0;
        else if (M_AXIS_TREADY) begin
            if ((word_cnt_q == word_num_d-1) && (pkt_cnt_q == num_packets_i-1))
                record_complete_q <= 1'b1;
            else
                record_complete_q <= 1'b0;
        end
    end
    
    always @(posedge M_AXIS_ACLK) begin
        if (!M_AXIS_ARESETN || start_adc_d)
            m_axis_valid_q <= 1'b0;
        else
            m_axis_valid_q <= fifo_valid_d;
    end
    
    
    assign M_AXIS_TDATA = m_axis_data_q;
    assign M_AXIS_TVALID = m_axis_valid_q;
    assign M_AXIS_TLAST = pkt_sent_q;
    assign ready_o = ~fifo_full_d;
    assign record_complete_o = record_complete_q;
	assign start_adc_d   = (front_det == 2'b01);
	// User logic ends

	endmodule
