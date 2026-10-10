// Name: register_file_nwidth
// Date: August 10th, 2026
// Description: Parameterized generic N-width register file 
// with 2 asynch. read ports and one synch. write port. 
// Features a configurable asynchronous or synchronous reset. For 32-bit CPU and other projects.

// DESIGNER: ANDRE AVIZ VASCONCELOS, Wed August 19 2026, 11:17:47,
// Miami FL, United States

module register_file_nwidth #(
    parameter REG_WIDTH   = 32,
    parameter NUM_REG     = 32,
    parameter ADDR_WIDTH  = $clog2(NUM_REG),   // ** revision 2 fixed this from OLD: 'REG_WIDTH'
    parameter ASYNC_RESET = 1'b0               // ** revision 2 adds parameter for choosing a
                                               // synchronous or asynchronous reset
)(
    input  logic                  CLK,        // all signals active-high
    input  logic                  RESET,
    input  logic                  WRITE_EN,
    input  logic [ADDR_WIDTH-1:0] READ_ADDR1,
    input  logic [ADDR_WIDTH-1:0] READ_ADDR2,
    input  logic [ADDR_WIDTH-1:0] WRITE_ADDR,
    input  logic [REG_WIDTH-1:0]  WRITE_DATA,

    output logic [REG_WIDTH-1:0]  READ_DATA1,
    output logic [REG_WIDTH-1:0]  READ_DATA2
);
    logic [REG_WIDTH-1:0] REGISTERS [0:NUM_REG-1];  // width of each register, no. of registers in array
    integer i;

generate    // ** revision 2 uses 'generate' to have scenarios for synchronous or asynchronous reset
            // only one 'always_ff' block will exist after elaborating ASYNCH_RESET parameter
    if (ASYNC_RESET) begin: asynch_reset
        always_ff @(posedge CLK or posedge RESET) begin
            if (RESET) begin
                for (i = 0; i < NUM_REG; i++)
                    REGISTERS[i] <= '0;
            end
            else if (WRITE_EN && (WRITE_ADDR != '0)) begin
                REGISTERS[WRITE_ADDR] <= WRITE_DATA;
            end
        end
    end

    else begin: synch_reset
        always_ff @(posedge CLK) begin
            if (RESET) begin
                for (i = 0; i < NUM_REG; i++)
                    REGISTERS[i] <= '0;               // ** revision 2 using integer 'i', OLD: '0:NUM_REG-1'  
            end
            else if (WRITE_EN && (WRITE_ADDR != '0)) begin
                REGISTERS[WRITE_ADDR] <= WRITE_DATA;
            end
        end
    end
endgenerate

always_comb begin
    if (READ_ADDR1 == '0) begin
        READ_DATA1 = '0;
    end
    else
        READ_DATA1 = REGISTERS[READ_ADDR1];

    if (READ_ADDR2 == '0) begin
        READ_DATA2 = '0;
    end
    else
        READ_DATA2 = REGISTERS[READ_ADDR2];
end
endmodule