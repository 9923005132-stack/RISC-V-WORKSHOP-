
module atm_controller_tb;

    reg clk, reset;
    reg card_inserted;
    reg [3:0] pin;
    reg [1:0] choice;
    reg [7:0] withdraw_amount;

    wire pin_valid;
    wire dispense_cash;
    wire transaction_done;
    wire error;
    wire [7:0] balance;

    atm_controller uut (
        .clk(clk),
        .reset(reset),
        .card_inserted(card_inserted),
        .pin(pin),
        .choice(choice),
        .withdraw_amount(withdraw_amount),
        .pin_valid(pin_valid),
        .dispense_cash(dispense_cash),
        .transaction_done(transaction_done),
        .error(error),
        .balance(balance)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        card_inserted = 0;
        pin = 0;
        choice = 0;
        withdraw_amount = 0;

        #10 reset = 0;

        // Valid PIN
        #10 card_inserted = 1;
        pin = 4'd5;

        // Withdraw transaction
        #20 choice = 2'b01;
        withdraw_amount = 8'd50;

        #100;

        $display("Balance = %d", balance);

        $finish;
    end

endmodule
