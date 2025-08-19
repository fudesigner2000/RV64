module PC(
    // PC程序计数器的输入信号
    input wire clk,
    input wire rst,
    input wire Jump_en,
    input wire [63:0] Jump_addr_i,
    input wire hold_flag_i,  //流水线暂停或冲刷标志
    // PC程序计数器提供给取址模块的信号:指令的地址
    output wire [63;0] inst_addr_o
)
    reg [63:0] pc_o;

    alway@(posedge clk or negedge rst)
          begin
             if(rst == 1) 
                   pc_o <= 64'h0000_0000_0000_0000;
             else if(Jump_en) 
                   pc_o <= Jump_addr_i;
             else if(hold_flag_i == 2'b01 | hold_flag_i == 2'b10)
                   pc_o <= pc_o;
             else pc_o <= pc_o+64'h4;  //既不存在流水线暂停也不存在流水线冲刷
          end
	DFF_SET 
	#
	(
		.DW(64)
	) 
	dff1
	(
		.clk        (clk          ),
		.rst        (rst          ),
		.hold_flag_i(hold_flag_i  ),
		.set_data   (64'b0        ),
	    .data_i     (pc_o         ),
        .data_o     (inst_addr_o  )
	);
    //使用D触发器是为了在全局存在流水线暂停的时候，方便控制。根据D触发器的含义，01是流水线冲刷，10是流水线暂停