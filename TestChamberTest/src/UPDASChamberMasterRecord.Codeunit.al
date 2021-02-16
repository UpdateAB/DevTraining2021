codeunit 70061 "UPD AS Chamber Master Record"
{
    Subtype = Test;

    var
        Customer: Record Customer;
        Item: Record Item;
        LibrarySales: Codeunit "Library - Sales";
        LibraryRandom: Codeunit "Library - Random";



    //[FEATURE] Test Chamber Master Record


    //[SCENARIO #0001] Create New Test Chamber
    [Test]
    procedure CreateNewTestChamber()
    var
        Chamber: Record "UPD AS Test Chamber";
    begin
        //[GIVEN] Customer
        LibrarySales.CreateCustomer(Customer);

        //[WHEN] User creates new Test Chamber
        Chamber.Init();
        Chamber."Customer No." := Customer."No.";
        Chamber.Code := CopyStr(LibraryRandom.RandText(20), 1, MaxStrLen(Chamber.Code));
        Chamber.Insert(true);

        //[THEN] Test Chamber exists for Customer
        Chamber.Find('=');
    end;


    //[SCENARIO #0002] Customer is Deleted
    //[GIVEN] Customer
    //[GIVEN] Test Chamber exists for Customer
    //[WHEN] Customer is deleted
    //[THEN] Test Chamber is deleted



    //[SCENARIO #0003] Prevent Chamber Deletion if Inventory
    //[GIVEN] Customer
    //[GIVEN] Item
    //[GIVEN] Test Chamber
    //[GIVEN] No Test Chamber Ledger Entry Exists
    //[WHEN] Test Chamber is deleted
    //[THEN] Test Chamber is deleted


    //[SCENARIO #0004] Prevent Chamber Deletion if Inventory
    //[GIVEN] Customer
    //[GIVEN] Item
    //[GIVEN] Test Chamber
    //[GIVEN] Test Chamber Ledger Entry Exists
    //[WHEN] Test Chamber is deleted
    //[THEN] Test Chamber is not deleted, error is shown


    //[SCENARIO #0005] Create New from Customer Card
    //[GIVEN] Customer
    //[WHEN] User creates new Test Chamber
    //[THEN] Test Chamber exists for Customer

}
