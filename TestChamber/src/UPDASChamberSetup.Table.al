table 50061 "UPD AS Chamber Setup"
{
    Caption = 'UPD AS Chamber Setup';
    DataClassification = ToBeClassified;
    DrillDownPageId = "UPD AS Chamber Setup";

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(10; "Chamber No Series."; Code[20])
        {
            Caption = 'Chamber No Series.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

}
