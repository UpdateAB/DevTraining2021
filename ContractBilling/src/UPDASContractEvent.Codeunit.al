codeunit 50070 "UPD AS Contract Event"
{
    [EventSubscriber(ObjectType::Table, Database::"UPD AS Test Chamber", 'OnAfterInsertEvent', '', true, true)]
    local procedure GenerateContractForChamber(var Rec: Record "UPD AS Test Chamber"; RunTrigger: Boolean)
    var
        Contract: Record "UPD AS Contract";
    begin
        if not RunTrigger then
            exit;

        if Rec.IsTemporary then
            exit;

        Contract.Init();
        Contract.Validate("Customer No.", Rec."Customer No.");
        Contract.Validate("Chamber Code", rec.Code);
        Contract.Validate(Active, true);
        Contract.Insert();
    end;
}
