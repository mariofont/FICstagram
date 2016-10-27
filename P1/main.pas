program main;

uses
  sysutils,
  Crt, // To use text colors
  DynamicList; // Static List

const
  maxPhotos = 50; // Defines the maximum number of photographs the gallery can have


procedure uploadImage(id: tIdPhoto; inputFileName:tFileName; commentary: tComment; var L:tList; var length: integer);

  // --------------------------------------------------------------------------------------
  // GOAL: Adds a new photo to the gallery                                              ---
  // INPUT:                                                                             ---
  //  • An ID                                                                           ---
  //  • The gallery where the corresponding photo is stored                             ---
  //  • The image counter of the gallery                                                ---
  // OUTPUT: The gallery without the photo                                              ---
  // POSTC: The image will be set as non reported and will have zero likes by default   ---
  // PRECO: The gallery must have been already initialized                              ---
  // --------------------------------------------------------------------------------------

  var
    n: tItem; // Temporal variable to save an item information
  begin

    with n do begin // Initialize the temporal variable with the given and default values.
      idPhoto  := id;
      fileName := inputFileName;
      comment  := commentary;
      reported := false;
      likes    := 0
    end;

    writeln('  Uploading Photo ', id, ' ', inputFileName, ' ', commentary);

    { Check requirements of the photo. }

    if inputFileName = '' then // No name in file
      writeln('  ++++ ERROR Uploading: Invalid filename')
    else if findItem(id, L) <> NULL then // There already exists the ID
      writeln('  ++++ ERROR Uploading: Photo ID ''', id,''' already exists')
    else if length {>}= maxPhotos then // Full gallery
      writeln('  ++++ ERROR Uploading: Maximum number of photos exceeded')
    else if not insertItem(n, NULL, L) then // No free memory. In case function returns true, it'll also upload the image.
      writeln('  **** WARNING: Out of memory for uploading ', id,' photo')
    else // Everything's great
      length:= length + 1;
  end;

procedure likePhoto(id:tIdPhoto; var L:tList);

  // --------------------------------------------------------------------------------------
  // GOAL: Adds a like to the photo corresponding to the introduced ID                  ---
  // INPUT:                                                                             ---
  //  • An ID                                                                           ---
  //  • The gallery where the photo is stored                                           ---
  // Output: The gallery (the photo has one more like)                                  ---
  // Precondition: The gallery must have been already initialized and must not be empty ---
  // --------------------------------------------------------------------------------------

  var
    n: tItem; // Temporal variable to save the wanted photo while it's being added a like
    t: tPosL; // Auxiliar variable to check if there exists the wanted photo
  begin
    t := findItem(id, L);
    if t = NULL then // If photo doesn't exist
      writeln('  ++++ ERROR Like: IdPhoto ',id,' does not exist')
      else begin // If the photo exists
        writeln('  **** New Like Photo ', id);
        n := getItem(t, L);
        with n do begin
          likes := likes + 1; // Add one more like
          writeln('  * Current number of likes ', likes);
        end;
        updateItem(L, t, n) // Apply changes.
      end
  end;

procedure showGallery(L:tList);

  // --------------------------------------------------------------------------------------
  // GOAL: Shows the gallery with all its photos’ information                           ---
  // INPUT: The gallery to be shown                                                     ---
  // OUTPUT: All the information of the gallery                                         ---
  // PRECONDITION: The gallery must have been already initialized and must not be empty ---
  // --------------------------------------------------------------------------------------

  var
    n: tPosL; // Auxiliar variable to loop over the items
    s: string; // Keeps the value to be printed (whether is reported)
    g, x: tItem; // Both auxiliar variables. g keeps the item we're working in the itineration of the loop. x keeps the item with the most likes.
  begin
    if not isEmptyList(L) then begin
      writeln('  **** Photo gallery:');
      n:= last(L); // The gallery is required to not be empty
      x:= getItem(n, L);
      while n <> NULL do begin
        g:= getItem(n, L);
        with g do begin
          if likes > x.likes then // Strictly greater to get the most recent one in case two pictures have the same amount of likes
            x := g;
          case reported of
            false: s:= 'No reported abuse';
            true:  s:= 'Abuse'
          end;
          writeln('  * Photo ', idPhoto, ' (',fileName, '). Likes ', likes, '. ', s, chr(10), '   ', comment);
          n:= previous(n, L)
        end
      end;
      with x do
        writeln(chr(10), '  *** Photo with largest number of likes (', likes, '): ', idPhoto)
    end else
      writeln('  **** Photo gallery empty')
  end;


procedure removePhoto(id:tIdPhoto; var L:tList; var length: integer);

  // --------------------------------------------------------------------------------------
  // GOAL: Removes a photo of the list by its ID (if it does exists)                    ---
  // INPUT:                                                                             ---
  //  • An ID                                                                           ---
  //  • The gallery where the corresponding photo is stored                             ---
  //  • The image counter of the gallery.                                               ---
  // OUTPUT: The gallery without the photo                                              ---
  // PRECONDITION: The gallery must have been already initialized                       ---
  // --------------------------------------------------------------------------------------

  var
    i: tPosL; // Auxiliar variable to save the position of the searched item
  begin
    i:= findItem(id, L);
    if i <> NULL then begin
      writeln('  **** Removing Photo ', id);
      length:= length - 1; // One less photo on the gallery :(
      deleteAtPosition(i, L)
    end else
      writeln(' ++++ ERROR Removing: idPhoto ', id,' does not exist');
  end;

  procedure reportPhoto(id:tIdPhoto; var L:tList);

    // --------------------------------------------------------------------------------------
    // AIM: To report a photo in the gallery                                              ---
    // INPUT:                                                                             ---
    //  • The ID of the photo to be reported                                              ---
    //  • The list (gallery) where the photo is uploaded.                                 ---
    // OUTPUT: The list (gallery) containing the now reported photo (argument passed      ---
    //   by reference)                                                                    ---
    // --------------------------------------------------------------------------------------
    var
      i: tPosL; // Auxiliar variable to keep the position of the item to be reported
      t: tItem; // The item to be reported
    begin
      i:= findItem(id, L);
      if i <> NULL then begin // findItem can return NULL if the item doesn't exist
        t:= getItem(i, L);
        if t.reported then // Check if it's been already reported
          writeln('  ---- NOTICE: Thank you for your contribution', chr(10),'  The photograph ', id,' has been previously reported')
        else begin
          writeln('  **** Report Abuse Photo ', id);
          t.reported:= true;
          updateItem(L, i, t)
        end
      end else
        writeln('  ++++ ERROR Reporting Abuse: IdPhoto ', id,' does not exist')

    end;

procedure purgeGallery(var L:tList; var length: integer);

  // --------------------------------------------------------------------------------------
  // GOAL: Deletes every reported photo in the gallery                                  ---
  // INPUT:                                                                             ---
  //  • The gallery                                                                     ---
  //  • The counter of that gallery                                                     ---
  // OUTPUT: The gallery without the reported photos                                    ---
  // PRECON: The gallery must have been already initialized                             ---
  // --------------------------------------------------------------------------------------

  var
    i, j: tPosL; // Both axiliar variables. i will loop over the positions of the items of the gallery. j will keep the previous position of the current iteration of i
    n: tItem; // The item of the itineration
    z: integer = 0; // Counter of removed photos
  begin
    writeln('  **** Discard Reported:');

    if not isEmptyList(L) then begin
      i:= first(L); // The gallery is required to not be empty
      j:= NULL; // Is initialized in NULL cause the first time there's no predecesor of i

      while i <> NULL do begin

        n:= getItem(i, L);

        with n do

          if reported then begin // If the photo is reported

            writeln('  Removing Photo ', idPhoto);
            z:= z + 1;
            deleteAtPosition(i, L);
            // NOT WORKING FOR ONE ITEM, LAST
            if j = NULL then // In case we're in the first position...
              i:= first(L) // i is back to the first value
            else // otherwise
              i:= next(j, L) // i is back to it's current absolute position in the list

          end else begin // In case the pic is not reported
            i:= next(i, L); // i becomes the next position

            // j is set to the previous position of i
            if j = NULL then
              j:= first(L)
            else
              j:= next(j, L)
          end
      end
    end;

    if z = 0 then // If the use hasn't been naughty (AKA has no reported photos)
      writeln('  ---- NOTICE: No photos reported', chr(10), '       Thank you for an appropiated use of this service')
    else begin
      writeln('  ', z, 'photos removed because of reporting abuse');
      length:= length - z
      end
  end;

procedure readTasks(taskFile:string; var L:tList);

  // --------------------------------------------------------------------------------------
  // Read a file text with the different task to do by the program                      ---
  // It prints a message indicating the task to perform with the required parameters    ---
  // The allowed tasks are: [A]buse, [D]iscard, [L]ike, [R]emove, [S]status, [U]pload   ---
  // --------------------------------------------------------------------------------------

  var
    fileId : text;
    code : string;
    idPhoto : integer;
    filename : string;
    comment : string;
    line : string;
    galLength: integer = 0;
  begin
    {$i-}
    assign(fileId, taskFile);
    reset(fileId);
    {$i+}
    if IOResult<>0 then begin
      writeln('  **** Reading. Error when trying to open ', taskFile);
      halt(1)
    end;

    while (not EOF(fileId)) do begin
      readln(fileId, line);
      code:= trim(copy(line, 1, 2));

      case code[1] of
  			'U', 'u': val(trim(copy(line, 3, 8)), idPhoto);
  			'L', 'l': val(trim(copy(line, 3, 8)), idPhoto);
  			'R', 'r': val(trim(copy(line, 3, 8)), idPhoto);
  			'A', 'a': val(trim(copy(line, 3, 8)), idPhoto)
  		end;

  		if (code[1] ='U') or (code[1] ='u') then begin
        filename:= trim(copy(line, 12, 10));
        comment:= trim(copy(line, 23, 20))
		  end;

      TextColor(Green); // Change color to green
      writeln(' *************************************************************');
      write('  ');

  		case code[1] of
        'U', 'u': writeln('Task U:  Photo ', idPhoto, ' ', filename, ' ', comment);
  			'R', 'r': writeln('Task R ', idPhoto);
  			'L', 'l': writeln('Task L ', idPhoto);
  			'A', 'a': writeln('Task A ', idPhoto);
  			'D', 'd': writeln('Task D ');
        'S', 's': writeln('Task S ')
  		end;

      writeln(' *************************************************************');
      TextColor(White); // Back to the default color

      case code[1] of
        'U', 'u': uploadImage(idPhoto, filename, comment, L, galLength);
        'R', 'r': removePhoto(idPhoto, L, galLength);
        'L', 'l': likePhoto(idPhoto, L);
        'A', 'a': reportPhoto(idPhoto, L);
        'D', 'd': purgeGallery(L, galLength);
        'S', 's': showGallery(L)
        // Use galLength in delete
      end;

      writeln(chr(10))
    end
end;

procedure emptyGallery(VAR L:tList);

  // --------------------------------------------------------------------------------------
  // GOAL: Deletes every photo in the gallery                                           ---
  // INPUT: The gallery                                                                 ---
  // OUTPUT: The empty gallery                                                          ---
  // PRECON: The gallery must have been already initialized                             ---
  // --------------------------------------------------------------------------------------

  begin
    while not isEmptyList(L) do begin
    // Every time the loop does an itineration we check if the list is empty, so we can use first.
    //Then every time there's a first element, we delelete it.
      deleteAtPosition(first(L), L)
    end
  end;


// ---------------------------------------------------------------------------------------

var
  gallery: tList;

begin

  createEmptyList(gallery); // Creates an empty list 'gallery' to work with

	if (paramCount > 0) then // Checks if there's any parameter in the console command
    readTasks(ParamStr(1), gallery) //Use the file specified as parameter
	else
    readTasks('upload.txt', gallery); //Use a "hard-coded" filename

  emptyGallery(gallery); // Empties the gallery created to free memory
end.
