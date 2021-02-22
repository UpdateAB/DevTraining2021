tableextension 50061 "UPD AS Sales Inv. Header" extends "Sales Invoice Header"
{
    fields
    {
        field(50060; "UPD AS Test Chamber Code"; Code[20])
        {
            Caption = 'Test Chamber Code';
            DataClassification = CustomerContent;
            TableRelation = "UPD AS Test Chamber".Code where("Customer No." = field("Sell-to Customer No."));
        }
    }
}
