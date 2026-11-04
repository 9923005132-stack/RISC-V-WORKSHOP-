
module atm_controller (
    input clk,
    input reset,
    input card_inserted,
    input [3:0] pin,
    input [1:0] choice,
    input [7:0] withdraw_amount,

    output reg pin_valid,
    output reg dispense_cash,
    output reg transaction_done,
    output reg error,
    output reg [7:0] balance
);

    // State encoding
    parameter IDLE          = 4'd0,
              PIN_CHECK     = 4'd1,
              MENU          = 4'd2,
              CHECK_BALANCE = 4'd3,
              WITHDRAW      = 4'd4,
              DISPENSE      = 4'd5,
              UPDATE        = 4'd6,
              ERROR_STATE   = 4'd7,
              DONE          = 4'd8;

    reg [3:0] state;
    reg [3:0] entered_pin;

    // Initial account balance
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            balance <= 8'd200;
            pin_valid <= 0;
            dispense_cash <= 0;
            transaction_done <= 0;
            error <= 0;
        end
        else begin

            // Default outputs
            dispense_cash <= 0;
            transaction_done <= 0;
            error <= 0;

            case(state)

                IDLE: begin
                    if(card_inserted) begin
                        entered_pin <= pin;
                        state <= PIN_CHECK;
                    end
                end

                PIN_CHECK: begin
                    if(entered_pin == 4'd5) begin
                        pin_valid <= 1;
                        state <= MENU;
                    end
                    else begin
                        pin_valid <= 0;
                        state <= ERROR_STATE;
                    end
                end

                MENU: begin
                    case(choice)
                        2'b00: state <= CHECK_BALANCE;
                        2'b01: state <= WITHDRAW;
                        default: state <= ERROR_STATE;
                    endcase
                end

                CHECK_BALANCE: begin
                    state <= DONE;
                end

                WITHDRAW: begin
                    if(withdraw_amount <= balance)
                        state <= DISPENSE;
                    else
                        state <= ERROR_STATE;
                end

                DISPENSE: begin
                    dispense_cash <= 1;
                    state <= UPDATE;
                end

                UPDATE: begin
                    balance <= balance - withdraw_amount;
                    state <= DONE;
                end

                ERROR_STATE: begin
                    error <= 1;
                    state <= DONE;
                end

                DONE: begin
                    transaction_done <= 1;
                    state <= IDLE;
                    pin_valid <= 0;
                end

                default: state <= IDLE;

            endcase
        end
    end

endmodule
