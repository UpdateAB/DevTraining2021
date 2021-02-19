tableextension 50070 "UPD AS CB Chamber Setup" extends "UPD AS Chamber Setup"
{
    fields
    {
        field(50070; "UPD AS Contract Value Rate"; Decimal)
        {
            BlankZero = true;
            Caption = 'Contract Value Rate';
            DataClassification = SystemMetadata;
            DecimalPlaces = 0 : 2;
            MinValue = 0;
        }
    }
}
