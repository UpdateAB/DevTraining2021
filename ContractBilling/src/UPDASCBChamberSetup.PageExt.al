pageextension 50070 "UPD AS CB Chamber Setup" extends "UPD AS Chamber Setup"
{
    layout
    {
        addlast(content)
        {
            group("UPD ASContract")
            {
                Caption = 'Contract';

                field("UPD AS Contract Value Rate"; Rec."UPD AS Contract Value Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UPD AS Contract Value Rate field';
                }
                field("UPD AS Contract G/L Acct."; Rec."UPD AS Contract G/L Acct.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contract G/L Acct. field to be used on Sales Invoices.';
                }
            }
        }
    }
}
