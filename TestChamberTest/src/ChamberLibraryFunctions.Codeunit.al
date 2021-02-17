codeunit 70060 "Chamber Library Functions"
{
    var
        LibraryUtility: Codeunit "Library - Utility";

    procedure GetFieldOnTableTxt(FieldCaption: Text; TableCaption: Text): Text
    var
        FieldOnTableTxt: Label '%1 on %2';
    begin
        exit(StrSubstNo(
                FieldOnTableTxt,
                FieldCaption,
                TableCaption))
    end;

    procedure CreateChamberForCustomer(var UPDASTestChamber: Record "UPD AS Test Chamber"; var Customer: record Customer)
    begin
        UPDASTestChamber.Init();
        UPDASTestChamber."Customer No." := Customer."No.";
        //UPDASTestChamber.Code := CopyStr(LibraryRandom.RandText(20), 1, MaxStrLen(UPDASTestChamber.Code));
        UPDASTestChamber.Insert(true);
    end;
}
