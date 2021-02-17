pageextension 55060 "UPD AS Customer" extends "Customer Card"
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
