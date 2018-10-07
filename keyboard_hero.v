module keyboard_hero
	(
		CLOCK_50,						//	On Board 50 MHz
      KEY,
		HEX0,
		HEX1,
		HEX2,
		HEX3,
		HEX4,
		HEX5,
		// The ports below are for the VGA output. Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,					//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   							//	VGA Blue[9:0]
	);

	input		CLOCK_50;				//	50 MHz
	input  [3:0]  KEY;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;

	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;			//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire go;
	assign go = ~KEY[0];
	wire resetn;
	assign resetn = KEY[3];
	
	// Create the colour, x, y and writeEn wires that are inputs to the VGA.
	wire [7:0] x;
	wire [6:0] y;
	wire [2:0] colour;
	wire writeEn;
	
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	wire [7:0] clear_screen_x_out;
	wire [6:0] clear_screen_y_out;
	wire [2:0] clear_screen_colour_out;
	wire clear_screen_enable;
	wire clear_screen_reset;
	wire clear_screen_finished;
	wire [7:0] draw_divider_x_out;
	wire [6:0] draw_divider_y_out;
	wire [2:0] draw_divider_colour_out;
	wire draw_divider_reset;
	wire [7:0] draw_divider_x;
	wire draw_divider_enable;
	wire draw_divider_finished;
	wire draw_horizontal_bar_reset;
	wire draw_horizontal_bar_enable;
	wire [6:0] draw_horizontal_bar_y;
	wire [7:0] draw_horizontal_bar_x_out;
	wire [6:0] draw_horizontal_bar_y_out;
	wire [2:0] draw_horizontal_bar_colour_out;
	wire draw_horizontal_bar_finished;
	wire y_counters_reset;
	wire y_counters_increment;
	wire [7:0] y_counter_1_x;
	wire [7:0] y_counter_1_x_out;
	wire [6:0] y_counter_1_y_out;
	wire [7:0] y_counter_2_x;
	wire [7:0] y_counter_2_x_out;
	wire [6:0] y_counter_2_y_out;
	wire [7:0] y_counter_3_x;
	wire [7:0] y_counter_3_x_out;
	wire [6:0] y_counter_3_y_out;
	wire draw_squares_reset;
	wire draw_square_1_enable;
	wire [2:0] draw_square_1_colour;
	wire [7:0] draw_square_1_x_out;
	wire [6:0] draw_square_1_y_out;
	wire [2:0] draw_square_1_colour_out;
	wire draw_square_1_finished;
	wire draw_square_2_enable;
	wire [2:0] draw_square_2_colour;
	wire [7:0] draw_square_2_x_out;
	wire [6:0] draw_square_2_y_out;
	wire [2:0] draw_square_2_colour_out;
	wire draw_square_2_finished;
	wire draw_square_3_enable;
	wire [2:0] draw_square_3_colour;
	wire [7:0] draw_square_3_x_out;
	wire [6:0] draw_square_3_y_out;
	wire [2:0] draw_square_3_colour_out;
	wire draw_square_3_finished;
	wire count_15_frames_finished;
	wire frame_counter_reset;
	wire delay_counter_out;
	wire rate_divider_reset;
	wire rate_divider_enable;
	wire rate_divider_out;
	wire rng_reset;
	wire [6:0] random_num;
	wire [2:0] square_wires;
	wire [2:0] square_speed_wires;
	wire [2:0] squares_within_range;
	wire countdown_timer_reset;
	wire [4:0] timer_out;
	wire [3:0] timer_1s_digit;
	wire [3:0] timer_10s_digit;
	wire points_counter_reset;
	wire [3:0] score_1s_digit;
	wire [3:0] score_10s_digit;
	wire [4:0] timer_val;	
	wire extra_countdown_timer_reset;
	wire [3:0] extra_timer_10s_digit;
	wire [3:0] extra_timer_1s_digit;
	wire extra_timer_start_enable;
	wire start_extra_timer;
	wire extra_timer_enabler_reset;
	
   // Instantiate FSM control
	control c0(
		.clock(CLOCK_50),
		.resetn(resetn),
		.go(go), 
		.timer_val(timer_out),
		.extra_timer_1s_digit(extra_timer_1s_digit),
		.extra_timer_10s_digit(extra_timer_10s_digit),
		.finished_clearing_screen(clear_screen_finished),
		.divider_finished_drawing(draw_divider_finished),
		.horizontal_bar_finished_drawing(draw_horizontal_bar_finished),
		.square_1_finished_drawing(draw_square_1_finished),
		.square_2_finished_drawing(draw_square_2_finished),
		.square_3_finished_drawing(draw_square_3_finished),
		.finished_15_frames(count_15_frames_finished),
		.clear_screen_enable(clear_screen_enable), 
		.points_counter_reset(points_counter_reset),
		.countdown_timer_reset(countdown_timer_reset),
		.rate_divider_reset(rate_divider_reset),
		.rate_divider_enable(rate_divider_enable),
		.rng_reset(rng_reset),
		.clear_screen_reset(clear_screen_reset),
		.draw_divider_x(draw_divider_x), 
		.draw_divider_enable(draw_divider_enable), 
		.draw_divider_reset(draw_divider_reset),
		.draw_horizontal_bar_y(draw_horizontal_bar_y),
		.draw_horizontal_bar_enable(draw_horizontal_bar_enable),
		.draw_horizontal_bar_reset(draw_horizontal_bar_reset),
		.draw_square_1_enable(draw_square_1_enable),
		.draw_square_1_colour(draw_square_1_colour),
		.y_counter_1_x(y_counter_1_x),
		.draw_square_2_enable(draw_square_2_enable),
		.draw_square_2_colour(draw_square_2_colour),
		.y_counter_2_x(y_counter_2_x),
		.draw_square_3_enable(draw_square_3_enable),
		.draw_square_3_colour(draw_square_3_colour),
		.y_counter_3_x(y_counter_3_x),
		.frame_counter_reset(frame_counter_reset),
		.draw_squares_reset(draw_squares_reset),
		.y_counters_reset(y_counters_reset),
		.y_counters_increment(y_counters_increment),
		.extra_countdown_timer_reset(extra_countdown_timer_reset),
		.extra_timer_start(start_extra_timer), 
		.extra_timer_enabled(extra_timer_start_enable), 
		.extra_timer_enabler_reset(extra_timer_enabler_reset)
	);
	
	// Instantiate datapath
	clear_screen cs0(
		.clk(CLOCK_50), 
		.resetn(clear_screen_reset), 
		.write_en(clear_screen_enable), 
		.x(clear_screen_x_out), 
		.y(clear_screen_y_out), 
		.colour(clear_screen_colour_out), 
		.finished_clear(clear_screen_finished)
	);
	
	draw_divider dd0(
		.clk(CLOCK_50), 
		.resetn(draw_divider_reset), 
		.x_in(draw_divider_x), 
		.write_en(draw_divider_enable), 
		.colour(draw_divider_colour_out), 
		.x(draw_divider_x_out), 
		.y(draw_divider_y_out), 
		.finished_drawing(draw_divider_finished)
	);
	
	draw_horizontal_bar dhb0(
		.clk(CLOCK_50), 
		.resetn(draw_horizontal_bar_reset), 
		.y_in(draw_horizontal_bar_y), 
		.write_en(draw_horizontal_bar_enable), 
		.colour(draw_horizontal_bar_colour_out), 
		.x(draw_horizontal_bar_x_out), 
		.y(draw_horizontal_bar_y_out), 
		.finished_drawing(draw_horizontal_bar_finished)
	);

	delay_counter dc0(
		.clk(CLOCK_50),
		.resetn(frame_counter_reset),
		.delay_pulse(delay_counter_out)
	);
	
	frame_counter c1(
		.delay_counter_in(delay_counter_out),
		.resetn(frame_counter_reset),
		.frame_enable(count_15_frames_finished)
	);
	
	rate_divider rd0(
		.clk(CLOCK_50),
		.resetn(rate_divider_reset),
		.rate_divider_enable(rate_divider_enable),
		.timer_enable(rate_divider_out)
	);
	
	countdown_timer ct0(
		.timer_enable(rate_divider_out), 
		.resetn(countdown_timer_reset), 
		.timer(timer_out), 
		.timer_10s_digit(timer_10s_digit), 
		.timer_1s_digit(timer_1s_digit)
	);
	
	random_num_generator rng0(
		.rng_enable(rate_divider_out),
		.resetn(rng_reset),
		.random_num(random_num)
	);
	
	square_generator sg0(
		.resetn(rng_reset),
		.random_num(random_num),
		.square_wires(square_wires),
		.square_speed_wires(square_speed_wires)
	);
	
	y_counter yc1(
		.clock(CLOCK_50), 
		.resetn(y_counters_reset), 
		.x_in(y_counter_1_x), 
		.horizontal_bar_y(draw_horizontal_bar_y),
		.enable(y_counters_increment), 
		.rng_update(square_wires[0]), 
		.speed(square_speed_wires[0]),
		.x(y_counter_1_x_out),
		.y(y_counter_1_y_out),
		.square_within_range(squares_within_range[2])
	);
	
		y_counter yc2(
		.clock(CLOCK_50), 
		.resetn(y_counters_reset), 
		.x_in(y_counter_2_x), 
		.horizontal_bar_y(draw_horizontal_bar_y),
		.enable(y_counters_increment), 
		.rng_update(square_wires[1]),
		.speed(square_speed_wires[1]),
		.x(y_counter_2_x_out),
		.y(y_counter_2_y_out),
		.square_within_range(squares_within_range[1])
	);
	
		y_counter yc3(
		.clock(CLOCK_50), 
		.resetn(y_counters_reset), 
		.x_in(y_counter_3_x), 
		.horizontal_bar_y(draw_horizontal_bar_y),
		.enable(y_counters_increment), 
		.rng_update(square_wires[2]), 
		.speed(square_speed_wires[2]),
		.x(y_counter_3_x_out),
		.y(y_counter_3_y_out),
		.square_within_range(squares_within_range[0])
	);
	
	draw_square ds1(
		.clock(CLOCK_50), 
		.resetn(draw_squares_reset), 
		.colour_in(draw_square_1_colour), 
		.x_in(y_counter_1_x_out), 
		.y_in(y_counter_1_y_out), 
		.write_en(draw_square_1_enable), 
		.colour(draw_square_1_colour_out), 
		.x(draw_square_1_x_out), 
		.y(draw_square_1_y_out), 
		.finished_drawing(draw_square_1_finished)
	);
	
	draw_square ds2(
		.clock(CLOCK_50), 
		.resetn(draw_squares_reset), 
		.colour_in(draw_square_2_colour), 
		.x_in(y_counter_2_x_out), 
		.y_in(y_counter_2_y_out), 
		.write_en(draw_square_2_enable), 
		.colour(draw_square_2_colour_out), 
		.x(draw_square_2_x_out), 
		.y(draw_square_2_y_out), 
		.finished_drawing(draw_square_2_finished)
	);
	
	draw_square ds3(
		.clock(CLOCK_50), 
		.resetn(draw_squares_reset), 
		.colour_in(draw_square_3_colour), 
		.x_in(y_counter_3_x_out), 
		.y_in(y_counter_3_y_out), 
		.write_en(draw_square_3_enable), 
		.colour(draw_square_3_colour_out), 
		.x(draw_square_3_x_out), 
		.y(draw_square_3_y_out), 
		.finished_drawing(draw_square_3_finished)
	);
	
	VGA_mux x_val(
		.clear_screen_enable(clear_screen_enable),
		.draw_divider_enable(draw_divider_enable),
		.draw_horizontal_bar_enable(draw_horizontal_bar_enable),
		.draw_square_1_enable(draw_square_1_enable),
		.draw_square_2_enable(draw_square_2_enable),
		.draw_square_3_enable(draw_square_3_enable),
		.clear_screen_val(clear_screen_x_out),
		.draw_divider_val(draw_divider_x_out),
		.draw_horizontal_bar_val(draw_horizontal_bar_x_out),
		.draw_square_1_val(draw_square_1_x_out),
		.draw_square_2_val(draw_square_2_x_out),
		.draw_square_3_val(draw_square_3_x_out),
		.out(x)
	);
	
	VGA_mux y_val(
		.clear_screen_enable(clear_screen_enable),
		.draw_divider_enable(draw_divider_enable),
		.draw_horizontal_bar_enable(draw_horizontal_bar_enable),
		.draw_square_1_enable(draw_square_1_enable),
		.draw_square_2_enable(draw_square_2_enable),
		.draw_square_3_enable(draw_square_3_enable),
		.clear_screen_val(clear_screen_y_out),
		.draw_divider_val(draw_divider_y_out),
		.draw_horizontal_bar_val(draw_horizontal_bar_y_out),
		.draw_square_1_val(draw_square_1_y_out),
		.draw_square_2_val(draw_square_2_y_out),
		.draw_square_3_val(draw_square_3_y_out),
		.out(y)
	);
	
	VGA_mux colour_val(
		.clear_screen_enable(clear_screen_enable),
		.draw_divider_enable(draw_divider_enable),
		.draw_horizontal_bar_enable(draw_horizontal_bar_enable),
		.draw_square_1_enable(draw_square_1_enable),
		.draw_square_2_enable(draw_square_2_enable),
		.draw_square_3_enable(draw_square_3_enable),
		.clear_screen_val(clear_screen_colour_out),
		.draw_divider_val(draw_divider_colour_out),
		.draw_horizontal_bar_val(draw_horizontal_bar_colour_out),
		.draw_square_1_val(draw_square_1_colour_out),
		.draw_square_2_val(draw_square_2_colour_out),
		.draw_square_3_val(draw_square_3_colour_out),
		.out(colour)
	);
	
	mux_2_to_1 mx210(
		.enable(start_extra_timer), 
		.countdown_timer(timer_out), 
		.extra_timer_1s_digit(extra_timer_1s_digit), 
		.extra_timer_10s_digit(extra_timer_10s_digit), 
		.timer_val(timer_val)
	);
	
	points_counter p0(
		.clock(CLOCK_50),
		.timer_val(timer_val),
		.resetn(points_counter_reset),
		.keys(KEY[2:0]), 
		.square_sig(squares_within_range), 
		.score1s(score_1s_digit),
		.score10s(score_10s_digit)
	);
		
	extra_timer_enabler(
		.clock(CLOCK_50), 
		.resetn(extra_timer_enabler_reset), 
		.flag(extra_timer_start_enable),
		.enable_out(start_extra_timer)
	);
		
	extra_countdown_timer ect0(
		.timer_enable(rate_divider_out), 
		.resetn(extra_countdown_timer_reset), 
		.points_1s_digit(score_1s_digit),
		.points_10s_digit(score_10s_digit),
		.extra_timer_10s_digit(extra_timer_10s_digit), 
		.extra_timer_1s_digit(extra_timer_1s_digit)
	);
	
	display_HEX hex_0(
		.u(score_1s_digit[0]),
		.v(score_1s_digit[1]),
		.w(score_1s_digit[2]),
		.x(score_1s_digit[3]),
		.m(HEX0)
	);
	
	display_HEX hex_1(
		.u(score_10s_digit[0]),
		.v(score_10s_digit[1]),
		.w(score_10s_digit[2]),
		.x(score_10s_digit[3]),
		.m(HEX1)
	);
	
	display_HEX hex_2(
		.u(timer_1s_digit[0]),
		.v(timer_1s_digit[1]),
		.w(timer_1s_digit[2]),
		.x(timer_1s_digit[3]),
		.m(HEX2)
	);
	
	display_HEX hex_3(
		.u(timer_10s_digit[0]),
		.v(timer_10s_digit[1]),
		.w(timer_10s_digit[2]),
		.x(timer_10s_digit[3]),
		.m(HEX3)
	);
		
	display_HEX hex_4(
		.u(extra_timer_1s_digit[0]),
		.v(extra_timer_1s_digit[1]),
		.w(extra_timer_1s_digit[2]),
		.x(extra_timer_1s_digit[3]),
		.m(HEX4)
	);
	
	display_HEX hex_5(
		.u(extra_timer_10s_digit[0]),
		.v(extra_timer_10s_digit[1]),
		.w(extra_timer_10s_digit[2]),
		.x(extra_timer_10s_digit[3]),
		.m(HEX5)
	);
	
	assign writeEn = clear_screen_enable || draw_divider_enable || draw_horizontal_bar_enable || 
							draw_square_1_enable || draw_square_2_enable || draw_square_3_enable;
endmodule

module draw_square(clock, resetn, colour_in, x_in, y_in, write_en, colour, x, y, finished_drawing);
	input clock;
	input resetn;
	input [2:0] colour_in;
	input [7:0] x_in;
	input [6:0] y_in;
	input write_en;
	output [2:0] colour;
	output [7:0] x;
	output [6:0] y;
	output finished_drawing;
	
	reg [2:0] colour_out;
	reg [7:0] x_out;
	reg [6:0] y_out;
	reg [3:0] four_bit_counter;
	reg finished_drawing;
	
	always @ (posedge clock) begin
            x_out[6:0] <= x_in[6:0];
				x_out[7] <= 1'b0;
				y_out <= y_in;
				colour_out <= colour_in;
    end
	 
	always @(posedge clock, posedge resetn) begin
		if (resetn) begin
			four_bit_counter <= 4'd0;
			finished_drawing <= 1'b0;
		end
		else if (write_en) begin
			if (four_bit_counter == 4'd15) begin
				four_bit_counter <= 4'd0;
				finished_drawing <= 1'b1;
			end
			else begin 
				four_bit_counter <= four_bit_counter + 1;
				finished_drawing <= 1'b0;
			end
		end
	end
					
	assign colour = colour_out;
	assign x = x_out + four_bit_counter[1:0];
	assign y = y_out + four_bit_counter[3:2];
endmodule

module rate_divider(clk, resetn, rate_divider_enable, timer_enable);
	input clk;
	input resetn;
	input rate_divider_enable;
	output timer_enable;
	
	reg [27:0] q;
	reg timer_enable;
	
	always @(posedge clk, posedge resetn)
	begin
		if (resetn)
			q <= (28'd50000000 - 28'd1);
		else if (rate_divider_enable)
		begin
			if (q == 28'd0) begin
				q <= (28'd50000000 - 28'd1);
				timer_enable <= 1;
			end
			else begin
				timer_enable <= 0;
				q <= q - 28'd1;
			end
		end
	end
endmodule

module countdown_timer(timer_enable, resetn, timer, timer_10s_digit, timer_1s_digit);
	input timer_enable;
	input resetn;
	output [4:0] timer;
	output [3:0] timer_10s_digit;
	output [3:0] timer_1s_digit;
	
	reg [4:0] timer;
	reg [3:0] timer_10s_digit;
	reg [3:0] timer_1s_digit;
	
	always @(posedge timer_enable, posedge resetn)
	begin
		if (resetn)
		begin
			timer <= 5'd30;
			timer_10s_digit <= 4'd3;
			timer_1s_digit <= 4'd0;
		end
		else if (timer > 5'd0)
		begin 
			if (timer_enable) begin
				timer <= timer - 1;
				
				if (timer_1s_digit == 4'd0)
				begin
					timer_1s_digit <= 4'd9;
					timer_10s_digit <= timer_10s_digit - 1;
				end
				else
				begin
					timer_1s_digit <= timer_1s_digit - 1;
				end
			end
		end
	end
endmodule

module extra_timer_enabler(clock, resetn, flag, enable_out);
	input clock;
	input resetn;
	input flag;
	output enable_out;
	
	reg enable_out;
	
	always @(posedge clock, posedge resetn) begin
		if (resetn) begin
			enable_out <= 0;
		end
		else if (flag) begin 
			enable_out <= 1;
		end
	end
endmodule 

module extra_countdown_timer(timer_enable, resetn, points_1s_digit, points_10s_digit, extra_timer_10s_digit, extra_timer_1s_digit);
	input timer_enable;
	input resetn;
	input [3:0] points_1s_digit;
	input [3:0] points_10s_digit;
	output [3:0] extra_timer_10s_digit;
	output [3:0] extra_timer_1s_digit;
	
	reg [3:0] extra_timer_10s_digit;
	reg [3:0] extra_timer_1s_digit;
	
	always @(posedge timer_enable, posedge resetn)
	begin
		if (resetn)
		begin
			extra_timer_10s_digit <= points_10s_digit;
			extra_timer_1s_digit <= points_1s_digit;
		end
		else if ((extra_timer_10s_digit >= 4'd0 && extra_timer_1s_digit > 0) || (extra_timer_10s_digit > 4'd0 && extra_timer_1s_digit >= 0))
		begin 
			if (timer_enable) begin
				if (extra_timer_1s_digit == 4'd0)
				begin
					extra_timer_1s_digit <= 4'd9;
					extra_timer_10s_digit <= extra_timer_10s_digit - 1;
				end
				else
				begin
					extra_timer_1s_digit <= extra_timer_1s_digit - 1;
				end
			end
		end
	end
endmodule

module points_counter(clock, timer_val, resetn, keys, square_sig, score1s, score10s);
	input clock;
	input [4:0] timer_val;
	input resetn;
	input [2:0] keys;
	input [2:0] square_sig;
	output [3:0] score1s;
	output [3:0] score10s;
	
	reg [3:0]score_10s_digit;
	reg [3:0]score_1s_digit;
	reg [4:0] time_of_last_score;
	
	always @(posedge clock, posedge resetn) begin
		if (resetn) begin
			score_10s_digit <= 4'd0;
			score_1s_digit <= 4'd0;
			time_of_last_score <= 5'd0;
		end
		else begin
			if (score_1s_digit == 4'd10) begin
				score_1s_digit <= 4'd0;
				score_10s_digit <= score_10s_digit + 4'd1;
			end
			if (square_sig == 3'b001 && keys[0] == 1'b0 && keys[1] == 1'b1 && keys[2] == 1'b1)
				if (time_of_last_score != timer_val) begin
					time_of_last_score <= timer_val;
					score_1s_digit <= score_1s_digit + 4'd1;
				end
			if (square_sig == 3'b010 && keys[0] == 1'b1 && keys[1] == 1'b0 && keys[2] == 1'b1)
				if (time_of_last_score != timer_val) begin
					time_of_last_score <= timer_val;
					score_1s_digit <= score_1s_digit + 4'd1;
				end
			if (square_sig == 3'b011 && keys[0] == 1'b0 && keys[1] == 1'b0 && keys[2] == 1'b1)
				if (time_of_last_score != timer_val) begin
					time_of_last_score <= timer_val;
					score_1s_digit <= score_1s_digit + 4'd1;
				end
			if (square_sig == 3'b100 && keys[0] == 1'b1 && keys[1] == 1'b1 && keys[2] == 1'b0)
				if (time_of_last_score != timer_val) begin
					time_of_last_score <= timer_val;
					score_1s_digit <= score_1s_digit + 4'd1;
				end
			if (square_sig == 3'b101 && keys[0] == 1'b0 && keys[1] == 1'b1 && keys[2] == 1'b0)
				if (time_of_last_score != timer_val) begin
					time_of_last_score <= timer_val;
					score_1s_digit <= score_1s_digit + 4'd1;
				end
			if (square_sig == 3'b110 && keys[0] == 1'b1 && keys[1] == 1'b0 && keys[2] == 1'b0)
				if (time_of_last_score != timer_val) begin
					time_of_last_score <= timer_val;
					score_1s_digit <= score_1s_digit + 4'd1;
				end
			if (square_sig == 3'b111 && keys[0] == 1'b0 && keys[1] == 1'b0 && keys[2] == 1'b0)
				if (time_of_last_score != timer_val) begin
					time_of_last_score <= timer_val;
					score_1s_digit <= score_1s_digit + 4'd1;
				end
		end
	end
	
	assign score1s = score_1s_digit;
	assign score10s = score_10s_digit;
endmodule 

module random_num_generator(rng_enable, resetn, random_num);
	input rng_enable;
	input resetn;
	output [6:0] random_num;
	
	reg [6:0] random_num;
	wire feedback;
	
	assign feedback = random_num[6] ^ random_num[3];
	
	always @(posedge resetn, posedge rng_enable)
	begin
		if (resetn)
		begin
			random_num <= 7'b1111111;
		end
		else 
		begin
			random_num <= {random_num[5:0], feedback};
		end
	end
endmodule

module square_generator(resetn, random_num, square_wires, square_speed_wires);
	input resetn;
	input [6:0] random_num;
	output [2:0] square_wires;
	output [2:0] square_speed_wires;
	
	reg [2:0] square_wires;
	reg [2:0] square_speed_wires;
	wire [3:0] random_num_mod_10;
	
	assign random_num_mod_10 = random_num % 10;
	
	// Decide which squares to light up depending on the value of the random number
	always @(*)
	begin
		if (resetn)
		begin
			square_wires = 3'b000;
		end
		else
		begin
			square_wires = 3'b000;
			
			if (4'd0 <= random_num_mod_10 && random_num_mod_10 <= 4'd5)
			begin
				square_wires[0] = 1'b1;
			end
			if (4'd4 <= random_num_mod_10 && random_num_mod_10 <= 4'd8)
			begin
				square_wires[1] = 1'b1;
			end
			if (4'd6 <= random_num_mod_10 && random_num_mod_10 <= 4'd9)
			begin
				square_wires[2] = 1'b1;
			end
		end
	end
	
	// Decide which squares to speed up depending on the value of the random number
	always @(*)
	begin
		if (resetn)
		begin
			square_speed_wires = 3'b000;
		end
		else
		begin
			square_speed_wires = 3'b000;
			
			if (4'd0 <= random_num_mod_10 && random_num_mod_10 <= 4'd3)
			begin
				square_speed_wires[0] = 1'b1;
			end
			if (4'd2 <= random_num_mod_10 && random_num_mod_10 <= 4'd7)
			begin
				square_speed_wires[1] = 1'b1;
			end
			if (4'd5 <= random_num_mod_10 && random_num_mod_10 <= 4'd9)
			begin
				square_speed_wires[2] = 1'b1;
			end
		end
	end 
endmodule

module y_counter(clock, resetn, x_in, horizontal_bar_y, enable, rng_update, speed, x, y, square_within_range);
	input clock;
	input resetn;
	input [7:0] x_in;
	input [6:0] horizontal_bar_y;
	input enable;
	input rng_update;
	input speed;
	output [7:0] x;
	output [6:0] y;
	output square_within_range;
	
	reg [6:0] y;
	reg square_within_range;
		
	always @(posedge clock, posedge resetn) begin
		if (resetn) begin
			y <= 7'd0;
			square_within_range <= 1'b0;
		end
		else begin
			if (y < 7'd120 && enable) begin
				if (speed == 1'b0) begin
					y <= y + 7'd1;
				end
				else begin
					y <= y + 7'd2;
				end
			end
			else if (y >= 7'd120 && rng_update) begin
				y <= 7'd0;
				square_within_range <= 1'b0;
			end
			
			if (y >= (horizontal_bar_y - 2'd3) && y <= horizontal_bar_y) begin
				square_within_range <= 1'b1;
			end
			else if (y < (horizontal_bar_y - 2'd3) || y > horizontal_bar_y) begin
				square_within_range <= 1'b0;
			end
		end
	end
	
	assign x = x_in;
endmodule

module frame_counter(delay_counter_in, resetn, frame_enable);
	input delay_counter_in;
	input resetn;
	output frame_enable;
	
	reg [3:0] frame_counter;
	reg frame_enable;

	always @(posedge delay_counter_in, posedge resetn) begin
		if (resetn) begin
			frame_counter <= 4'd0;
			frame_enable <= 1'b0;
		end
		else begin
			if (frame_counter == 4'd15) begin
				frame_counter <= 4'd0;
				frame_enable <= 1'b1;
			end
			else begin
				frame_enable <= 1'b0;
				frame_counter <= frame_counter + 4'd1;
			end
		end
	end
endmodule

module delay_counter(clk, resetn, delay_pulse);
	input clk;
	input resetn;
	output delay_pulse;
	
	reg [15:0] clock_counter;
	reg delay_pulse;
	
	always @(posedge clk, posedge resetn) begin
		if (resetn) begin
			clock_counter <= 16'd0;
			delay_pulse <= 1'b0;
		end
		else begin
			if (clock_counter == 16'd50000) begin
				clock_counter <= 16'd0;
				delay_pulse <= 1'b1;
			end
			else begin
				delay_pulse <= 1'b0;
				clock_counter <= clock_counter + 16'd1;
			end
		end
	end
endmodule

module draw_divider(clk, resetn, x_in, write_en, colour, x, y, finished_drawing);
	input clk;
	input resetn;
	input [7:0] x_in;
	input write_en;
	output [2:0] colour;
	output [7:0] x;
	output [6:0] y;
	output finished_drawing;
	
	reg [6:0] y_counter;
	reg finished_drawing;
	 
	always @(posedge clk, posedge resetn) begin
		if (resetn) begin
			y_counter <= 8'd0;
			finished_drawing <= 1'b0;
		end
		else if (write_en) begin
			if (y_counter == 7'd127) begin
				y_counter <= 8'd0;
				finished_drawing <= 1'b1;
			end
			else begin 
				y_counter <= y_counter + 8'd1;
				finished_drawing <= 1'b0;
			end
		end
	end
	
	assign colour = 3'b101;
	assign x = x_in;
	assign y = y_counter;
endmodule

module draw_horizontal_bar(clk, resetn, y_in, write_en, colour, x, y, finished_drawing);
	input clk;
	input resetn;
	input [6:0] y_in;
	input write_en;
	output [2:0] colour;
	output [7:0] x;
	output [6:0] y;
	output finished_drawing;
	
	reg [7:0] x_counter;
	reg finished_drawing;
	 
	always @(posedge clk, posedge resetn) begin
		if (resetn) begin
			x_counter <= 8'd0;
			finished_drawing <= 1'b0;
		end
		else if (write_en) begin
			if (x_counter == 8'd163) begin
				x_counter <= 8'd0;
				finished_drawing <= 1'b1;
			end
			else begin 
				x_counter <= x_counter + 8'd1;
				finished_drawing <= 1'b0;
			end
		end
	end
	
	assign colour = 3'b101;
	assign x = x_counter;
	assign y = y_in;
endmodule

module clear_screen(clk, resetn, write_en, x, y, colour, finished_clear);
	input clk;
	input resetn;
	input write_en;
	output [7:0] x;
	output [6:0] y;
	output [2:0] colour;
	output finished_clear;
	
	reg [7:0] x;
	reg [6:0] y;
	reg finished_clear;
	
	always @(posedge clk, posedge resetn) begin
		if (resetn) begin
			x <= 8'd0;
			y <= 7'd0;
			finished_clear <= 1'b0;
		end
		else if (write_en) begin
			if (x == 8'd163 && y == 7'd127) begin
				finished_clear <= 1'b1;
			end
			else if (x == 8'd163) begin
				x <= 8'd0;
				y <= y + 1;
				finished_clear <= 1'b0;
			end
			else begin 
				x <= x + 1;
				finished_clear <= 1'b0;
			end
		end
	end
	
	assign colour = 3'b000;
endmodule

module mux_2_to_1(enable, countdown_timer, extra_timer_1s_digit, extra_timer_10s_digit, timer_val);
	input enable;
	input [4:0] countdown_timer;
	input extra_timer_1s_digit;
	input extra_timer_10s_digit;
	output [4:0] timer_val;
	
	reg [4:0] timer_val;
	 
	always @(*)
	begin
		timer_val = countdown_timer;
		
		if (enable) begin
			timer_val = (extra_timer_10s_digit * 10) + extra_timer_1s_digit;
		end
	end
endmodule

module VGA_mux(clear_screen_enable, draw_divider_enable, draw_horizontal_bar_enable, draw_square_1_enable, draw_square_2_enable,
					draw_square_3_enable, clear_screen_val, draw_divider_val, draw_horizontal_bar_val, draw_square_1_val, 
					draw_square_2_val, draw_square_3_val, out);
	input clear_screen_enable;
	input draw_divider_enable;
	input draw_horizontal_bar_enable;
	input draw_square_1_enable;
	input draw_square_2_enable;
	input draw_square_3_enable;
	input [7:0] clear_screen_val;
	input [7:0] draw_divider_val;
	input [7:0] draw_horizontal_bar_val;
	input [7:0] draw_square_1_val;
	input [7:0] draw_square_2_val;
	input [7:0] draw_square_3_val;
	output [7:0] out;
	
	reg [7:0] out;
	
	always @(*) begin
		if (clear_screen_enable)
			out = clear_screen_val;
		else if (draw_divider_enable)
			out = draw_divider_val;
		else if (draw_horizontal_bar_enable)
			out = draw_horizontal_bar_val;
		else if (draw_square_1_enable)
			out = draw_square_1_val;
		else if (draw_square_2_enable)
			out = draw_square_2_val;
		else if (draw_square_3_enable)
			out = draw_square_3_val;
	end
endmodule

module display_HEX(u, v, w, x, m);
	input u, v, w, x;
	output [6:0] m;
	
	assign m[0] = (~x & ~w & ~v & u) | (~x & w & ~v & ~u) | (x & w & ~v & u) | (x & ~w & v & u);
	assign m[1] = (~x & w & ~v & u) | (x & w & ~u) | (w & v & ~u) | (x & v & u);
	assign m[2] = (~x & ~w & v & ~u) | (x & w & v) | (x & w & ~u);
	assign m[3] = (~x & ~w & ~v & u) | (~x & w & ~v & ~u) | (w & v & u) | (x & ~w & v & ~u);
	assign m[4] = (~x & u) | (~x & w & ~v) | (~w & ~v & u);
	assign m[5] = (~x & ~w & u) | (~x & ~w & v) | (~x & v & u) | (x & w & ~v & u);
	assign m[6] = (~x & ~w & ~v) | (~x & w & v & u) | (x & w & ~v & ~u);
endmodule

module control(clock, resetn, go, timer_val, extra_timer_1s_digit, extra_timer_10s_digit, finished_clearing_screen, divider_finished_drawing, horizontal_bar_finished_drawing, 
					square_1_finished_drawing, square_2_finished_drawing, square_3_finished_drawing, finished_15_frames, 
					clear_screen_enable, points_counter_reset, countdown_timer_reset, rate_divider_reset, rate_divider_enable, rng_reset, 
					clear_screen_reset, draw_divider_x, draw_divider_enable, draw_divider_reset, draw_horizontal_bar_y, draw_horizontal_bar_enable, 
					draw_horizontal_bar_reset, draw_square_1_enable, draw_square_1_colour, y_counter_1_x, draw_square_2_enable, draw_square_2_colour, 
					y_counter_2_x, draw_square_3_enable, draw_square_3_colour, y_counter_3_x, frame_counter_reset, draw_squares_reset, y_counters_reset, 
					y_counters_increment, extra_countdown_timer_reset, extra_timer_start, extra_timer_enabled, extra_timer_enabler_reset);
	input clock;
	input resetn;
	input go;
	input [4:0] timer_val;
	input [3:0] extra_timer_1s_digit;
	input [3:0] extra_timer_10s_digit;
	input extra_timer_start;
	input finished_clearing_screen;
	input divider_finished_drawing;
	input horizontal_bar_finished_drawing;
	input square_1_finished_drawing;
	input square_2_finished_drawing;
	input square_3_finished_drawing;
	input finished_15_frames;
	output clear_screen_enable;
	output points_counter_reset;
	output countdown_timer_reset;
	output rate_divider_reset;
	output rate_divider_enable;
	output rng_reset;
	output clear_screen_reset;
	output [7:0] draw_divider_x;
	output draw_divider_enable;
	output draw_divider_reset;
	output [6:0] draw_horizontal_bar_y;
	output draw_horizontal_bar_enable;
	output draw_horizontal_bar_reset;
	output draw_square_1_enable;
	output [2:0] draw_square_1_colour;
	output [7:0] y_counter_1_x;
	output draw_square_2_enable;
	output [2:0] draw_square_2_colour;
	output [7:0] y_counter_2_x;
	output draw_square_3_enable;
	output [2:0] draw_square_3_colour;
	output [7:0] y_counter_3_x;
	output frame_counter_reset;
	output draw_squares_reset;
	output y_counters_reset;
	output y_counters_increment;
	output extra_countdown_timer_reset;
	output extra_timer_enabled;
	output extra_timer_enabler_reset;
	
	reg clear_screen_enable;
	reg points_counter_reset;
	reg countdown_timer_reset;
	reg rate_divider_reset;
	reg rate_divider_enable;
	reg rng_reset;
	reg clear_screen_reset;
	reg [7:0] draw_divider_x;
	reg draw_divider_enable;
	reg draw_divider_reset;
	reg [6:0] draw_horizontal_bar_y;
	reg draw_horizontal_bar_enable;
	reg draw_horizontal_bar_reset;
	reg draw_square_1_enable;
	reg [2:0] draw_square_1_colour;
	reg [7:0] y_counter_1_x;
	reg draw_square_2_enable;
	reg [2:0] draw_square_2_colour;
	reg [7:0] y_counter_2_x;
	reg draw_square_3_enable;
	reg [2:0] draw_square_3_colour;
	reg [7:0] y_counter_3_x;
	reg frame_counter_reset;
	reg draw_squares_reset;
	reg y_counters_reset;
	reg y_counters_increment;
	reg extra_countdown_timer_reset;
	reg extra_timer_enabled;
	reg extra_timer_enabler_reset;
	
	reg [4:0] current_state;
	reg [4:0] next_state; 
	
	localparam	S_RESET								= 5'd0,
					 S_CLEAR_SCREEN					= 5'd1,
					 S_DRAW_DIVIDER_1					= 5'd2,
                S_DRAW_DIVIDER_1_RESET			= 5'd3,
					 S_DRAW_DIVIDER_2					= 5'd4,
					 S_DRAW_DIVIDER_2_RESET			= 5'd5,
					 S_BEGIN_GAME						= 5'd6,
					 S_BEGIN_GAME_WAIT				= 5'd7,
					 S_DRAW_HORIZONTAL_BAR			= 5'd8,
					 S_DRAW_HORIZONTAL_BAR_RESET 	= 5'd9,
					 S_DRAW_SQUARE_1					= 5'd10,
					 S_DRAW_SQUARE_2					= 5'd11,
					 S_DRAW_SQUARE_3					= 5'd12,
					 S_DRAW_SQUARES_RESET			= 5'd13, 
					 S_FRAME_COUNTER_RESET			= 5'd14,
					 S_ERASE_SQUARE_1					= 5'd15,
					 S_ERASE_SQUARE_2					= 5'd16,
					 S_ERASE_SQUARE_3					= 5'd17,	
					 S_ERASE_SQUARES_RESET			= 5'd18, 
					 S_UPDATE							= 5'd19,
					 S_EXTRA_TIMER_RESET				= 5'd20,
					 S_EXTRA_TIMER_COUNTDOWN		= 5'd21,
					 S_END_GAME							= 5'd22,
					 S_END_GAME_WAIT					= 5'd23;
					 
	// Next state logic aka our state table
    always@(*)
    begin: state_table
            case (current_state)
					S_RESET: next_state = S_CLEAR_SCREEN;
					S_CLEAR_SCREEN: next_state = finished_clearing_screen ? S_DRAW_DIVIDER_1 : S_CLEAR_SCREEN;
					S_DRAW_DIVIDER_1: next_state = divider_finished_drawing ? S_DRAW_DIVIDER_1_RESET : S_DRAW_DIVIDER_1;
					S_DRAW_DIVIDER_1_RESET: next_state = S_DRAW_DIVIDER_2;
					S_DRAW_DIVIDER_2: next_state = divider_finished_drawing ? S_DRAW_DIVIDER_2_RESET : S_DRAW_DIVIDER_2;
					S_DRAW_DIVIDER_2_RESET: next_state = S_BEGIN_GAME;
					S_BEGIN_GAME: next_state = go ? S_BEGIN_GAME_WAIT : S_BEGIN_GAME;
					S_BEGIN_GAME_WAIT: next_state = go ? S_BEGIN_GAME_WAIT : S_DRAW_HORIZONTAL_BAR;
					S_DRAW_HORIZONTAL_BAR: next_state = horizontal_bar_finished_drawing ? S_DRAW_HORIZONTAL_BAR_RESET : S_DRAW_HORIZONTAL_BAR;
					S_DRAW_HORIZONTAL_BAR_RESET: next_state = S_DRAW_SQUARE_1;
					S_DRAW_SQUARE_1: next_state = square_1_finished_drawing ? S_DRAW_SQUARE_2 : S_DRAW_SQUARE_1;
					S_DRAW_SQUARE_2: next_state = square_2_finished_drawing ? S_DRAW_SQUARE_3 : S_DRAW_SQUARE_2;
					S_DRAW_SQUARE_3: next_state = square_3_finished_drawing ? S_DRAW_SQUARES_RESET : S_DRAW_SQUARE_3;
					S_DRAW_SQUARES_RESET: next_state = finished_15_frames ? S_FRAME_COUNTER_RESET : S_DRAW_SQUARES_RESET;
					S_FRAME_COUNTER_RESET: next_state = S_ERASE_SQUARE_1;
					S_ERASE_SQUARE_1: next_state = square_1_finished_drawing ? S_ERASE_SQUARE_2 : S_ERASE_SQUARE_1;
					S_ERASE_SQUARE_2: next_state = square_2_finished_drawing ? S_ERASE_SQUARE_3 : S_ERASE_SQUARE_2;
					S_ERASE_SQUARE_3: next_state = square_3_finished_drawing ? S_ERASE_SQUARES_RESET : S_ERASE_SQUARE_3;
					S_ERASE_SQUARES_RESET: next_state = S_UPDATE;
					S_UPDATE: if (extra_timer_start)
										next_state = S_EXTRA_TIMER_COUNTDOWN;
								  else
										next_state = (timer_val <= 5'd0) ? S_EXTRA_TIMER_RESET : S_DRAW_HORIZONTAL_BAR;
					S_EXTRA_TIMER_RESET: next_state = S_EXTRA_TIMER_COUNTDOWN;
					S_EXTRA_TIMER_COUNTDOWN: next_state = (extra_timer_10s_digit <= 4'd0 && extra_timer_1s_digit <= 4'd0) ? S_END_GAME : S_DRAW_HORIZONTAL_BAR;
					S_END_GAME: next_state = go ? S_END_GAME_WAIT : S_END_GAME;
					S_END_GAME_WAIT: next_state = go ? S_END_GAME_WAIT : S_RESET;
            default: next_state = S_RESET;
        endcase
    end // state_table
	 
	 // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
		  clear_screen_enable = 1'b0;
		  points_counter_reset = 1'b0;
		  countdown_timer_reset = 1'b0;
		  rate_divider_reset = 1'b0;
		  rate_divider_enable = 1'b0;
		  rng_reset = 1'b0;
		  draw_divider_x = 8'd0;
		  draw_divider_enable = 1'b0;
		  draw_divider_reset = 1'b0;
		  clear_screen_reset = 1'b0;
		  draw_horizontal_bar_y = 7'd0;
		  draw_horizontal_bar_enable = 1'b0;
		  draw_horizontal_bar_reset = 1'b0;
		  draw_square_1_enable = 1'b0;
		  draw_square_1_colour = 3'b000;
		  y_counter_1_x = 8'd0;
		  draw_square_2_enable = 1'b0;
		  draw_square_2_colour = 3'b000;
		  y_counter_2_x = 8'd0;
		  draw_square_3_enable = 1'b0;
		  draw_square_3_colour = 3'b000;
		  y_counter_3_x = 8'd0;
		  frame_counter_reset = 1'b0;
		  draw_squares_reset = 1'b0;
		  y_counters_reset = 1'b0;
		  y_counters_increment = 1'b0;
		  extra_countdown_timer_reset = 1'b0;
		  extra_timer_enabled = 1'b0;
		  extra_timer_enabler_reset = 1'b0;

        case (current_state)
				S_RESET: begin
					points_counter_reset = 1'b1;
					countdown_timer_reset = 1'b1;
					rate_divider_reset = 1'b1;
					rng_reset = 1'b1;
					draw_divider_reset = 1'b1;
					clear_screen_reset = 1'b1;
					draw_horizontal_bar_reset = 1'b1;
					frame_counter_reset = 1'b1;
					draw_squares_reset = 1'b1;
					y_counters_reset = 1'b1;
					extra_countdown_timer_reset = 1'b1;
					extra_timer_enabler_reset = 1'b1;
				end
				S_CLEAR_SCREEN: begin
					clear_screen_enable = 1'b1;
					frame_counter_reset = 1'b1;
				end
				S_DRAW_DIVIDER_1: begin
					draw_divider_x = 8'd52;
					draw_divider_enable = 1'b1;
					frame_counter_reset = 1'b1;
				end
				S_DRAW_DIVIDER_2: begin
					draw_divider_x = 8'd105;
					draw_divider_enable = 1'b1;
					frame_counter_reset = 1'b1;
				end
				S_DRAW_DIVIDER_1_RESET, S_DRAW_DIVIDER_2_RESET: begin
					draw_divider_reset = 1'b1;
					frame_counter_reset = 1'b1;
				end
				S_DRAW_HORIZONTAL_BAR: begin
					draw_horizontal_bar_y = 7'd110;
					draw_horizontal_bar_enable = 1'b1;
					frame_counter_reset = 1'b1;
					rate_divider_enable = 1'b1;
				end
				S_DRAW_HORIZONTAL_BAR_RESET: begin
					draw_horizontal_bar_reset = 1'b1;
					frame_counter_reset = 1'b1;
					rate_divider_enable = 1'b1;
				end
				S_DRAW_SQUARE_1: begin
					y_counter_1_x = 8'd24;
					draw_square_1_enable = 1'b1;
					draw_square_1_colour = 3'b100;
					frame_counter_reset = 1'b1;
					rate_divider_enable = 1'b1;
				end
				S_DRAW_SQUARE_2: begin
					y_counter_2_x = 8'd76;
					draw_square_2_enable = 1'b1;
					draw_square_2_colour = 3'b010;
					frame_counter_reset = 1'b1;
					rate_divider_enable = 1'b1;
				end
				S_DRAW_SQUARE_3: begin
					y_counter_3_x = 8'd125;
					draw_square_3_enable = 1'b1;
					draw_square_3_colour = 3'b001;
					frame_counter_reset = 1'b1;
					rate_divider_enable = 1'b1;
				end
				S_FRAME_COUNTER_RESET: begin
					frame_counter_reset = 1'b1;
					rate_divider_enable = 1'b1;
				end
				S_ERASE_SQUARE_1: begin
					draw_square_1_enable = 1'b1;
					y_counter_1_x = 8'd24;
					frame_counter_reset = 1'b1;
					rate_divider_enable = 1'b1;
				end
				S_ERASE_SQUARE_2: begin
					draw_square_2_enable = 1'b1;
					y_counter_2_x = 8'd76;
					frame_counter_reset = 1'b1;
					rate_divider_enable = 1'b1;
				end
				S_ERASE_SQUARE_3: begin
					draw_square_3_enable = 1'b1;
					y_counter_3_x = 8'd125;
					frame_counter_reset = 1'b1;
					rate_divider_enable = 1'b1;
				end
				S_DRAW_SQUARES_RESET, S_ERASE_SQUARES_RESET: begin
					draw_squares_reset = 1'b1;
					rate_divider_enable = 1'b1;
				end
				S_UPDATE: begin
					y_counters_increment = 1'b1;
					frame_counter_reset = 1'b1;
					rate_divider_enable = 1'b1;
				end
				S_EXTRA_TIMER_RESET: begin
					frame_counter_reset = 1'b1;
					rate_divider_enable = 1'b1;
					extra_countdown_timer_reset = 1'b1;
					extra_timer_enabled = 1'b1;
				end
				S_EXTRA_TIMER_COUNTDOWN: begin
					frame_counter_reset = 1'b1;
					rate_divider_enable = 1'b1;
					extra_timer_enabled = 1'b1;
				end
			endcase
    end // enable_signals
   
    // current_state registers
    always @(posedge clock, negedge resetn)
    begin: state_FFs
			if(!resetn)
				current_state <= S_RESET;
			else
				current_state <= next_state;
    end // state_FFS
endmodule