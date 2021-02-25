pageextension 50060 "UPD AD Chamber Sales Order" extends "Sales Order"
{
    layout
    {
        addafter("Sell-to Contact")
        {

            field("UPD AS Test Chamber Code"; Rec."UPD AS Test Chamber Code")
            {
                ApplicationArea = All;
                ToolTip = 'Which Test Chamber is getting the items';
            }
        }
    }
}
