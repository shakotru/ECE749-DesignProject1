module alu (
    input               i_clk,
    input               i_rst_n,
    input               i_valid,
    input signed [11:0] i_data_a,
    input signed [11:0] i_data_b,
    input        [2:0]  i_inst,
    output              o_valid,
    output       [11:0] o_data,
    output              o_overflow
);
    
// ---------------------------------------------------------------------------
// Wires and Registers
// ---------------------------------------------------------------------------
reg  signed[11:0] o_data_w, o_data_r;
reg         o_valid_w, o_valid_r;
reg         o_overflow_w, o_overflow_r;
// ---- Add your own wires and registers here if needed ---- //
reg [11:0] a_abs, b_abs;
reg [12:0] long_sum;

// ---------------------------------------------------------------------------
// Continuous Assignment
// ---------------------------------------------------------------------------
assign o_valid = o_valid_r;
assign o_data = o_data_r;
assign o_overflow = o_overflow_r;

// ---- Add your own wire data assignments here if needed ---- //

// ---------------------------------------------------------------------------
// Combinational Blocks
// ---------------------------------------------------------------------------
// ---- Write your conbinational block design here ---- //
always@(*) begin
    o_valid_w = ~o_overflow_w;
	
	case (i_inst)
		3'b000: begin   //ADD
			o_data_w = $signed(i_data_a )+ $signed(i_data_b);
			o_overflow_w = (~o_data_w[11] & i_data_a[11] & i_data_b[11]) | (o_data_w[11] & (~i_data_a[11]) & (~i_data_b[11]));
		end

		3'b001: begin  //SUBTRACT
			o_data_w = $signed(i_data_a) - $signed(i_data_b);
			o_overflow_w = ((i_data_a[11] ^ i_data_b[11]) && ((i_data_b[11] && o_data_w[11])) | (~i_data_b[11] && ~o_data_w[11]));
		end
		
		3'b010: begin //MULTIPLY
		
		end		
		
		3'b011: begin //MAC

		end	
		
		3'b100: begin  //bitwise XNOR
			o_data_w = i_data_a ~^ i_data_b;
			o_overflow_w = 0;  //no overflow possible
		end
		3'b101: begin //ReLU (checking the sign bit)
			o_data_w = i_data_a[11] ? 12'b0 : i_data_a[11:0];
			o_overflow_w=0; //no overflow possible
		end
		
		3'b110: begin  //MEAN
			 long_sum = ($signed(i_data_a) + $signed(i_data_b))>>> 1;
			 o_data_w = long_sum[11:0]; //intermediate sum used to store extra bit, then truncated.
			 o_overflow_w = 0;
		end

		3'b111: begin //ABS MAX --> max(|a|,|b|)
			a_abs = i_data_a[11] ? ((~i_data_a[11:0])+1) : i_data_a[11:0];
			b_abs = i_data_b[11] ? ((~i_data_b[11:0])+1) : i_data_b[11:0];
			o_data_w = (a_abs > b_abs) ? a_abs : b_abs;
			o_overflow_w = 0;
		end	
	endcase
end




// ---------------------------------------------------------------------------
// Sequential Block
// ---------------------------------------------------------------------------
// ---- Write your sequential block design here ---- //
always@(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        o_data_r <= 0;
        o_overflow_r <= 0;
        o_valid_r <= 0;
    end else if (i_valid) begin
        o_data_r <= o_data_w;
        o_overflow_r <= o_overflow_w;
        o_valid_r <= o_valid_w;
    end else begin
        o_data_r <= 0;
	o_overflow_r <= 0;
	o_valid_r <= 0;

    end
end


endmodule
