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
reg  [11:0] o_data_w, o_data_r;
reg         o_valid_w, o_valid_r;
reg         o_overflow_w, o_overflow_r;
// ---- Add your own wires and registers here if needed ---- //




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
    //o_data_w = ;
    //o_overflow_w = ;
    //o_valid_w = ;

    case (i_inst)
        3'b100: begin
		o_data_r = i_data_a ~^ i_data_b;        // Bitwise XNOR
		o_overflow_r = 0;	 		//overflow not possible
		o_valid_r = 1;
	end
	3'b101: begin
		o_data_r = !i_data_a[11] ? i_data_a[11]:0;   //ReLU checks sign bit (0=positive)
		o_overflow_r = 0;			//overflow not possible	
		o_valid_r = 1;
	end
        default: begin
		o_data_r = 0;  //no data
		o_valid_r = 0; //operand will be invalid if != any of the above cases
		o_overflow_w = 0; //no overflow if no operation conducted
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
    end else begin
        o_data_r <= o_data_w;
        o_overflow_r <= o_overflow_w;
        o_valid_r <= o_valid_w;
    end
end


endmodule
