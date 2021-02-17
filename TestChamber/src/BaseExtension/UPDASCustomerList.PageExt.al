pageextension 55061 "UPD AS Customer List" extends "Customer List"
{
    actions
    {
        addlast("&Customer")
        {
            action("UPD ASTestChambers")
            {
                ApplicationArea = All;
                Caption = 'Test Chambers';
                Image = WorkCenter;
                Promoted = true;
                PromotedCategory = Category8;
                RunObject = Page "UPD AS Test Chambers";
                RunPageLink = "Customer No." = field("No.");
                ToolTip = 'Show all Test Chambers for Customer.';
            }
        }
    }
}
