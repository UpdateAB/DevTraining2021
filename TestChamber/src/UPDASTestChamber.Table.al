table 50060 "UPD AS Test Chamber"
{
    Caption = 'UPD AS Test Chamber';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(20; Active; Boolean)
        {
            Caption = 'Active';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Customer No.", Code)
        {
            Clustered = true;
        }
    }

}
