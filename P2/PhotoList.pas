unit PhotoList;

interface
  const
    NULLP = 0;
    MAX = 10;
    firstPos = 1; // firstPos < MAX, MAX-firstPos = 'Number of items'

  type
    tIdPhoto = integer;
    tFileName = string;
    tComment = string;
    tReported = boolean;
    tLikesCounter = integer;

    tItemP = record
      idPhoto: tIdPhoto;
      fileName: tFileName;
      comment: tComment;
      reported: tReported;
      likes: tLikesCounter
    end;
    tPosP = NULLP..MAX;
    tListP = record
      data: array[firstPos..MAX] of tItemP;
      length: tPosP
    end;

  procedure createEmptyListP(var L:tListP);
  function isEmptyListP(L:tListP):boolean;
  function firstP(L:tListP):tPosP;
  function lastP(L:tListP):tPosP;
  function nextP(p:tPosP; L:tListP):tPosP;
  function previousP(p:tPosP; L:tListP):tPosP;
  function insertItemP(a:tItemP; p:tPosP; var L:tListP):boolean;
  procedure deleteAtPositionP(p:tPosP; var L:tListP);
  function getItemP(p:tPosP; L:tListP):tItemP;
  procedure updateItemP(var L:tListP; p:tPosP; a:tItemP);
  function findItemP(a:tIdPhoto; L:tListP):tPosP;

implementation

  procedure createEmptyListP(var L:tListP);

    // --------------------------------------------------------------------------------------
    // AIM: Creates an empty list                                                         ---
    // INPUT: A variable to initialize the list                                           ---
    // OUTPUT: A new list                                                                 ---
    // POSC: The list is initialised and has no elements                                  ---
    // --------------------------------------------------------------------------------------

    begin
      L.length:= NULLP;
    end;

  function isEmptyListP(L:tListP):boolean;

  // --------------------------------------------------------------------------------------
  // AIM: To check whether the list is empty                                            ---
  // INPUT: A list to check                                                             ---
  // OUTPUT: True if empty, false if contains something                                 ---
  // --------------------------------------------------------------------------------------

    begin
      isEmptyListP:= (L.length = NULLP)
    end;

  function firstP(L:tListP):tPosP;

  // --------------------------------------------------------------------------------------
  // AIM: To get the first position of the list                                         ---
  // INPUT: A list to get the position                                                  ---
  // OUTPUT: The position                                                               ---
  // PREC: The list must not be empty                                                   ---
  // --------------------------------------------------------------------------------------

    begin
      firstP:= firstPos
    end;

  function lastP(L:tListP):tPosP;

  // --------------------------------------------------------------------------------------
  // AIM: To get the last position of the list                                          ---
  // INPUT: A list to get the position                                                  ---
  // OUTPUT: The position                                                               ---
  // PREC: The list must not be empty                                                   ---
  // --------------------------------------------------------------------------------------

    begin
      lastP:= L.length
    end;

  function nextP(p:tPosP; L:tListP):tPosP;

  // --------------------------------------------------------------------------------------
  // AIM: Returns the position following the one we indicate                            ---
  // INPUT: A list to get the position and the original position                        ---
  // OUTPUT: The position                                                               ---
  // POSC: Returns NULLP if the specified position has no next element                  ---
  // --------------------------------------------------------------------------------------

    begin
      if p = L.length then
        nextP:= NULLP
      else
        nextP:= p + 1
    end;

  function previousP(p:tPosP; L:tListP):tPosP;
  // --------------------------------------------------------------------------------------
  // AIM: Returns the position preceding the one we indicate                            ---
  // INPUT: A list to get the position and the original position                        ---
  // OUTPUT: The position                                                               ---
  // POSC: Returns NULLP if the specified position has no previous element              ---
  // --------------------------------------------------------------------------------------
    begin
      { We could've just done previous := p - 1 but, since NULLP is a constant,
         if we wanted to change the definition this wouldn't work.
      }
      if p = firstPos then
        previousP:= NULLP
      else
        previousP:= p - 1
    end;

  function insertItemP(a:tItemP; p:tPosP; var L:tListP):boolean;

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
  // PREC: The specified position is a valid position in the list or a NULLP position   ---
  // POSC: If the specified position is NULLP, then the element is added                ---
  //  at the end of the list                                                            ---
  // --------------------------------------------------------------------------------------

    var
      i: integer; // It's an integer and not tPosL because it is an auxiliar variable and not an actual part of the adt
    begin
      insertItemP:= true;
      if L.length = MAX then // Case list is full
        insertItemP:= false
      else begin // There's room for at least one item
        L.length := L.length + 1; // One item is being added, length++
        if p = NULLP then // Insert it in the last position
          L.data[L.length] := a
        else begin // Insert it where you're asked to
          for i:=L.length downto p+1 do
            L.data[i]:= L.data[i-1];
          L.data[p] := a
        end
      end
    end;

  procedure deleteAtPositionP(p:tPosP; var L:tListP);

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
          L.data[i]:= L.data[i+1]
    end;

  function getItemP(p:tPosP; L:tListP):tItemP;

  // --------------------------------------------------------------------------------------
  // AIM: Retrieves the content of the element at the position we indicate              ---
  // INPUT:                                                                             ---
  //  • The position of the item want to get                                            ---
  //  • The list where the item is stored                                               ---
  // OUTPUT: The item                                                                   ---
  // PREC: The indicated position is a valid position in the list                       ---
  // --------------------------------------------------------------------------------------

    begin
      getItemP:= L.data[p]
    end;

  procedure updateItemP(var L:tListP; p:tPosP; a:tItemP);

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
      L.data[p] := a
    end;

  function findItemP(a:tIdPhoto; L:tListP):tPosP;

  // --------------------------------------------------------------------------------------
  // AIM: To search an item in a list                                                   ---
  // INPUT:                                                                             ---
  //  • The search key (photo ID)                                                       ---
  //  • The list where where you want to searh                                          ---
  // OUTPUT: The position of the item you looked for or NULLP if it isn't in the list   ---
  // --------------------------------------------------------------------------------------

    var
      i: integer = 1; // It's an integer and not tPosL because it is an auxiliar variable and not an actual part of the adt
    begin
      if L.length = NULLP then // Case it's empty
        findItemP:= NULLP
      else begin // Not empty
        while (i <> L.length) and (L.data[i].idPhoto <> a) do // The loop will stop if you've got to the last item or you've found the one you're looking for
          i:= i + 1;
        if L.data[i].idPhoto = a then
          findItemP := i
        else
          findItemP := NULLP
      end
    end;
end.
