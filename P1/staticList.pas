unit staticList;

interface
  const
    NULL = 0;
    MAX = 50;
    firstPos = 1; // firstPos < MAX, MAX-firstPos = 'Number of items'

  type
    tIdPhoto = integer;
    tFileName = string;
    tComment = string;
    tReported = boolean;
    tLikesCounter = integer;

    tItem = record
      idPhoto: tIdPhoto;
      fileName: tFileName;
      comment: tComment;
      reported: tReported;
      likes: tLikesCounter;
    end;
    tPosL = NULL..MAX;
    tList = record
      data: array[firstPos..MAX] of tItem;
      length: tPosL;
    end;

  procedure createEmptyList(var L:tList);
  function isEmptyList(L:tList):boolean;
  function first(L:tList):tPosL;
  function last(L:tList):tPosL;
  function next(p:tPosL; L:tList):tPosL;
  function previous(p:tPosL; L:tList):tPosL;
  function insertItem(a:tItem; p:tPosL; var L:tList):boolean;
  procedure deleteAtPosition(p:tPosL; var L:tList);
  function getItem(p:tPosL; L:tList):tItem;
  procedure updateItem(var L:tList; p:tPosL; a:tItem);
  function findItem(a:tIdPhoto; L:tList):tPosL;

implementation

  procedure createEmptyList(var L:tList);

    // --------------------------------------------------------------------------------------
    // AIM: Creates an empty list                                                         ---
    // INPUT: A variable to initialize the list                                           ---
    // OUTPUT: A new list                                                                 ---
    // POSC: The list is initialised and has no elements                                  ---
    // --------------------------------------------------------------------------------------

    begin
      with L
        do length:= NULL;
    end;

  function isEmptyList(L:tList):boolean;

  // --------------------------------------------------------------------------------------
  // AIM: To check whether the list is empty                                            ---
  // INPUT: A list to check                                                             ---
  // OUTPUT: True if empty, false if contains something                                 ---
  // --------------------------------------------------------------------------------------

    begin
      isEmptyList:= (L.length = NULL);
    end;

  function first(L:tList):tPosL;

  // --------------------------------------------------------------------------------------
  // AIM: To get the first position of the list                                         ---
  // INPUT: A list to get the position                                                  ---
  // OUTPUT: The position                                                               ---
  // PREC: The list must not be empty                                                   ---
  // --------------------------------------------------------------------------------------

    begin
      first:= firstPos;
    end;

  function last(L:tList):tPosL;

  // --------------------------------------------------------------------------------------
  // AIM: To get the last position of the list                                          ---
  // INPUT: A list to get the position                                                  ---
  // OUTPUT: The position                                                               ---
  // PREC: The list must not be empty                                                   ---
  // --------------------------------------------------------------------------------------

    begin
      last:= L.length;
    end;

  function next(p:tPosL; L:tList):tPosL;

  // --------------------------------------------------------------------------------------
  // AIM: Returns the position following the one we indicate                            ---
  // INPUT: A list to get the position and the original position                        ---
  // OUTPUT: The position                                                               ---
  // POSC: Returns NULL if the specified position has no next element                   ---
  // --------------------------------------------------------------------------------------

    begin
      if p = L.length then
        next:= NULL
      else
        next:= p + 1;
    end;

  function previous(p:tPosL; L:tList):tPosL;
  // --------------------------------------------------------------------------------------
  // AIM: Returns the position preceding the one we indicate                            ---
  // INPUT: A list to get the position and the original position                        ---
  // OUTPUT: The position                                                               ---
  // POSC: Returns NULL if the specified position has no previous element               ---
  // --------------------------------------------------------------------------------------
    begin
      { We could've just done previous := p - 1 but, since NULL is a constant,
         if we wanted to change the definition this wouldn't work.
      }
      if p = firstPos then
        previous:= NULL
      else
        previous:= p - 1;
    end;

  function insertItem(a:tItem; p:tPosL; var L:tList):boolean;

  // --------------------------------------------------------------------------------------
  // AIM: Inserts an element containing the provided data item before the given         ---
  //  position in the list                                                              ---
  // INPUT:                                                                             ---
  //  • The item to insert                                                              ---
  //  • The position where you want to insert the item                                  ---
  //  • The list where you want to insert the item                                      ---
  // OUTPUT:                                                                            ---
  //  • If the element could be inserted, the value true is returned,                   ---
  //     otherwise false is returned                                                    ---
  //  • A modified list with the new element                                            ---
  // PREC: The specified position is a valid position in the list or a NULL position    ---
  // POSC: If the specified position is NULL, then the element is added                 ---
  //  at the end of the list                                                            ---
  // --------------------------------------------------------------------------------------

    var
      i: integer; // It's an integer and not tPosL because it is an auxiliar variable and not an actual part of the adt
    begin
      insertItem:= true;
      if L.length = MAX then // Case list is full
        insertItem:= false
      else begin // There's room for at least one item
        L.length := L.length + 1; // One item is being added, length++
        if p = NULL then // Insert it in the last position
          L.data[L.length] := a
        else begin // Insert it where you're asked to
          for i:=L.length downto p+1 do
            L.data[i]:= L.data[i-1];
          L.data[p] := a
        end
      end
    end;

  procedure deleteAtPosition(p:tPosL; var L:tList);

    // --------------------------------------------------------------------------------------
    // AIM: Deletes the element at the given position from the list                       ---
    // INPUT:                                                                             ---
    //  • The position you want to delete                                                 ---
    //  • The list where the item is stored                                               ---
    // OUTPUT: The modified list                                                          ---
    // PREC: The indicated position is a valid position in the list                       ---
    // POSC: The deleted position and the positions of the elements of the list           ---
    //  subsequent to it become invalid.                                                  ---
    // --------------------------------------------------------------------------------------

    var
      i: integer; // It's an integer and not tPosL because it is an auxiliar variable and not an actual part of the adt
    begin
      L.length := L.length - 1; // One less pic left, baby. length--
        for i:=p to L.length do
          L.data[i]:= L.data[i+1];
    end;

  function getItem(p:tPosL; L:tList):tItem;

  // --------------------------------------------------------------------------------------
  // AIM: Retrieves the content of the element at the position we indicate              ---
  // INPUT:                                                                             ---
  //  • The position of the item want to get                                            ---
  //  • The list where the item is stored                                               ---
  // OUTPUT: The item                                                                   ---
  // PREC: The indicated position is a valid position in the list                       ---
  // --------------------------------------------------------------------------------------

    begin
      getItem:= L.data[p];
    end;

  procedure updateItem(var L:tList; p:tPosL; a:tItem);

    // --------------------------------------------------------------------------------------
    // AIM: Modifies the content of the element at the position we indicate               ---
    // INPUT:                                                                             ---
    //  • The position of the item want to update                                         ---
    //  • The item to overwrite                                                           ---
    //  • The list where the item is stored                                               ---
    // OUTPUT: The updated list                                                           ---
    // PREC: The indicated position is a valid position in the list                       ---
    // POSC: The order of the elements in the list has not been modified                  ---
    // --------------------------------------------------------------------------------------

    begin
      L.data[p] := a;
    end;

  function findItem(a:tIdPhoto; L:tList):tPosL;

  // --------------------------------------------------------------------------------------
  // AIM: To search an item in a list                                                   ---
  // INPUT:                                                                             ---
  //  • The search key (photo ID)                                                       ---
  //  • The list where where you want to searh                                          ---
  // OUTPUT: The position of the item you looked for or NULL if it isn't in the list    ---
  // --------------------------------------------------------------------------------------

    var
      i: integer = 1; // It's an integer and not tPosL because it is an auxiliar variable and not an actual part of the adt
    begin
      if L.length = NULL then // Case it's empty
        findItem:= NULL
      else begin // Not empty
        while (i <> L.length) and (L.data[i].idPhoto <> a) do // The loop will stop if you've got to the last item or you've found the one you're looking for
          i:= i + 1;
        if L.data[i].idPhoto = a then
          findItem := i
        else
          findItem := NULL;
      end
    end;
end.
