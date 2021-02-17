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
        field(30; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = SystemMetadata;
            TableRelation = "No. Series";
        }
    }
    keys
    {
        key(PK; "Customer No.", Code)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        UPDASChamberSetup: Record "UPD AS Chamber Setup";
        NoSeriesMgmt: Codeunit NoSeriesManagement;
    begin
        if Rec.Code = '' then begin
            UPDASChamberSetup.Get();
            UPDASChamberSetup.TestField("Chamber No Series.");
            NoSeriesMgmt.InitSeries(UPDASChamberSetup."Chamber No Series.", xRec."No. Series", 0D, "Code", "No. Series");
        end;
    end;
}
