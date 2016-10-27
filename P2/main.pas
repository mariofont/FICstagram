program main;
{$mode OBJFPC}

uses
	sysutils,
	Crt, // To use text colors
	UserList,
	RequestQueue,
	PhotoList;

const
	defaultIndent = '  '; // Change here how much the text will be indented. (Won't be applied to the headers)

procedure header(s:string);
	// Goal: Print a header of the program
	// Input: The message to be printed

	begin
		if s <> 'Fetching instructions' then
			writeln(chr(10));

		TextColor(Blue); // Change color to green
		writeln('*************************************************************');
		writeln(defaultIndent, s);
		writeln('*************************************************************');
		TextColor(White); // Back to the default color

		writeln(chr(10))
	end;

procedure printError(s:string; w: boolean = false);
	// Goal: Prints an error on screen
	// Input: The message to be printed. A boolean to choose if its a common error or a warning error
	begin
		if w then begin
			TextColor(Yellow);
			writeln(defaultIndent, '**** WARNING: ', s)
		end else begin
			TextColor(Red);
			writeln(defaultIndent, '++++ ERROR ', s)
		end;
		TextColor(White)
	end;

procedure echo(s:string; b:boolean = false); // To make code more readeable
	// Goal: Prints four asterisks on screen and a message or just a message
	// Input: The message to be printed and a boolean to choose if it's a normal message or a special one
	begin
		if b then
			writeln(defaultIndent, s)
		else
			writeln(defaultIndent, '**** ', s)
	end;

function strToAcc(a:string):tAccount;
	// Goal: Change a string into an account
	// Input: The string we want to turn into an account
	// Output: The account value
	// Posc: If the string is not "free" or "premium" (it doesn't matter if it's in uppercase) it would be taken as free
	begin
		if LowerCase(a) = 'premium' then // We know parameter2 has already been trimmed, we would do so otherwise
			strToAcc:= premium
		else
			strToAcc:= free
	end;

function accToStr(a:tAccount):string; // Needed to concatenate strings
	// Goal: Transfroms an account type into an string
	// Input: The account to be turned into an account
	begin
		case a of
			free: accToStr:= 'free';
			premium: accToStr:= 'premium'
		end
	end;


procedure deleteUserPhotos(var P:tListP);
	// Goal: Delete the whole gallery of a user
	// Output: A modified list without any photos
	// Input: A list of one user

 	begin
		while not isEmptyListP(P) do begin
			deleteAtPositionP(firstP(P), P)
		end
	end;

procedure selfDestruction(var U:tListU = NULLU);
	// Goal: Delete the whole user list
	// Output: A modified list without any users
	// Input: A list of users
	var
		a: tPosU;
 	begin
		while not isEmptyListU(U) do begin
			a:= firstU(U);
			deleteUserPhotos(getItemU(a, U).photos);
			deleteAtPositionU(a, U)
		end
	end;

function abuseStr(inputReported:tReported):string;
	// Goal: Transform an abuse into a predefined string
	// Input: The reported-type value
	// Output: A string
begin
	case inputReported of
		true: abuseStr:= 'Abuse';
		false: abuseStr:= 'No reported abuse'
	end;
end;

procedure createAccount(inputNickname:tNickname; inputUsername:tUsername; accountType:tAccount; var U:tListU);
	// Goal: Creates an user account
	// Input: The nickname, username, account type, user list
	// Output: a modified user list with a new account
	var
		n: tItemU; // The new user to be created
		P: tListP; // The new photo gallery of the previous user
	begin
		if (inputNickname <> '') or (inputUsername <> '') then
			if findItemU(inputNickname, U) = NULLU then begin // Checking whether there is already a user with this nickname
				createEmptyListP(P); // Initializes a new gallery
				with n do begin // Fills the new user with the input values
					nickname:= inputNickname;
					username:= inputUsername;
					account:= accountType;
					photos:= P;
				end;
				insertItemU(n, U); // Inserts the user in the user list
				echo('User account created: ' + inputNickname + ' ' + inputUsername + ' ' + accToStr(accountType))
			end else // There's already a user with that nickname
				printError('Creating user account: Nickname ' + inputNickname + ' already exists')
		else
			printError('Nickname and Username cannot be empty')
	end;

procedure deleteAccount(inputNickname:tNickname; var U:tListU);
	// Goal: Deletes an account
	// Input: The nickname of the user to be reported, the user list
	// Output: The modified user list without the account
	var
		v: tPosU; // Position of the user we're tryna delete
	begin
		if inputNickname <> '' then begin
			v:= findItemU(inputNickname, U);
			if v <> NULLU then begin // In case it's found...
				echo('User ' + inputNickname + ' has removed his/her account');
				deleteUserPhotos(getItemU(v, U).photos);
				deleteAtPositionU(v, U) // ...we remove the user
			end else // No user with that name
				printError('Removing user account: Nickname ' + inputNickname + ' not found')
		end else
			printError('Nickname cannot be empty')
	end;

procedure transformAccount(inputNickname:tNickname; accountType:tAccount; var U:tListU);
	// Goal: Transforms an account into the one given
	// Input: the nickname of the account, the new type of account and the user list
	// Output: A modified user list
	var
		p: tPosU;
		v: tItemU;
	begin
		p:= findItemU(inputNickname, U);
		if p <> NULLU then begin // In case it's found...
			v:= getItemU(p, U);
			echo('User ' + inputNickname + ' has changed its account to ' + accToStr(accountType));
			if v.account <> accountType then begin
				v.account:= accountType;
				updateItemU(U, p, v)
			end
		end else // No user with that name
			printError('Transforming user account: Nickname ' + inputNickname + ' not found')
	end;

procedure reportPhoto(inputNickname:tNickname; inputID:tIdPhoto; var U:tListU);
	// Goal: Add an abuse report to an exsiting photo
	// Input: The nickname of the user, the id and the user list
	// Output: A modified user list with an user with a new report

	var
		v: tPosU;
		i: tItemU;
		p: tPosP;
		y: tItemP;

	begin
		v:= findItemU(inputNickname, U);

		echo('Report Abuse Photo ' + inputNickname + ' ' + IntToStr(inputID));

		if v <> NULLU then begin
			i:= getItemU(v, U);
			p:= findItemP(inputID, i.photos);

			if p <> NULLP then begin // Checks if the photo exists
				y:= getItemP(p, i.photos);
				with y do begin
					if reported = true then begin
						echo('NOTICE: Thank you for your contribution');
						echo('The photograph ' + IntToStr(inputID) + ' has been previously reported', true)
					end else
						reported:= true;
				end;
				updateItemP(i.photos, p, y); // Applies changes to the gallery
				updateItemU(U, v, i) // Applies changes to the user
			end else
				printError('Reporting Abuse: IdPhoto ' + IntToStr(inputID) + ' does not exist')
		end else
			printError('Reporting Abuse: Nickname ' + inputNickname + ' not found')
	end;

function galleryReady(user:tItemU):boolean;
	// Goal: Tells if a new photo can be inserted
	// Input: A user
	// Output: A boolean (true if there's space)
	var
		q: tPosP;
		i: integer = 0;
	begin
		with user do begin
			if not isEmptyListP(photos) then begin
				q:= firstP(photos);
				while q <> NULLP do begin
					i:= i + 1;
					q:= nextP(q, photos);
				end;
				case account of
					free: galleryReady:= (i < 2);
					premium: galleryReady:= (i < 10)
				end
			end else
				galleryReady:= true;
		end
	end;

procedure uploadImage(inputNickname: tNickname; inputFileName:tFileName; commentary: tComment; var U:tListU; var lastUsedID: integer);

	// Goal: Uploads the image to an user
	// Input: the nickname, filename, comment, user list and a variable to keep the IDs used in the system
	// Output: A modified user list and ID counter

	var
		p: tPosU; // The position of the user we're looking for
		t: tItemP; // The new photo we're inserting into the gallery
		v: tItemU;
	begin
		p:= findItemU(inputNickname, U);
		if p <> NULLU then begin

			v:= getItemU(p, U);

			with t do begin // Initialize the temporal variable with the given and default values.
				idPhoto  := lastUsedID + 1;
				fileName := inputFileName;
				comment  := commentary;
				reported := false;
				likes    := 0
			end;

			if inputFileName = '' then // No name in file

				printError('Uploading: Invalid filename')

			else if not galleryReady(v) then // Full gallery

				printError('Uploading: Maximum number of photos exceeded [' + accToStr(v.account) + ' account]')

			else if not insertItemP(t, NULLP, v.photos) then

			// No free memory. In case function returns true, it'll also upload the image. As the user gallery is static it won't actually never return false, but we don't know the implementation of insertItem
				printError('Out of memory for uploading ' + IntToStr(lastUsedID + 1) + ' photo', true)

			else begin // Everything's great

				updateItemU(U, p, v);
				lastUsedID:= lastUsedID + 1;
				echo('Uploading Photo ' + inputNickname + ' ' + IntToStr(lastUsedID) + ' ' + inputFileName + ' ' + commentary)

			end
		end else
			printError('Uploading photo: Nickname ' + inputNickname + ' not found')
	end;

procedure purgeGallery(var inputUser:tItemU; position:tPosU; var U:tPosU; var z:integer);
	// Goal: Deletes all the reported photos of a photo list of one user
	// Input: The user, position user list and a variable to add the amount of removed items
	// Output: A modified user in a user list and a modified counter of deleted photos
	var
		i, j: tPosP;
		n: tItemP;
		r: integer = 0;
	begin
		with inputUser do
		 	if not isEmptyListP(photos) then begin
	 			i:= firstP(photos); // The gallery is required to not be empty
	 			j:= NULLP; // Is initialized in NULL cause the first time there's no predecesor of i

		 		while i <> NULLP do begin
		 			n:= getItemP(i, photos);
		 			with n do
		 				if reported then begin // If the photo is reported
		 					echo('* Removing Photo ' + IntToStr(idPhoto));
		 					r:= r + 1;
		 					deleteAtPositionP(i, photos);
		 					// NOT WORKING FOR ONE ITEM, LAST

		 					if isEmptyListP(photos) then
		 						i:= NULLP
		 					else if j = NULLP then // In case we're in the first position...
		 						i:= firstP(photos) // i is back to the first value
		 					else // otherwise
		 						i:= nextP(j, photos) // i is back to it's current absolute position in the list
						end else begin // In case the pic is not reported
							i:= nextP(i, photos); // i becomes the next position
							// j is set to the previous position of i
							if j = NULLP then
								j:= firstP(photos)
							else
								j:= nextP(j, photos)
						end
				end;
				if r <> 0 then begin
					z:= z + r;
					updateItemU(U, position, inputUser);
				end
			end
	end;

procedure purgeUsers(var U:tListU);
	// Goal: Remove all the reported photos of the system
	// Input: The user list
	// Output: The modified user list
 	var
 		i: tPosU;
 		z: integer = 0; // Counter of removed photos
 		a: tItemU;
 	begin

 		if not isEmptyListU(U) then begin
 			i:= firstU(U);
 			while i <> NULLU do begin
 				a:= getItemU(i, U);
 				purgeGallery(a, i, U, z);
 				i:= nextU(i, U);
 			end;
 		end else
 			echo('Discarding photos: no user accounts found');

 		if z = 0 then begin
 			echo('---- NOTICE: No photos reported', true);
 			echo( 'Thank you for an appropiated use of this service', true);
 		end else
 			echo(IntToStr(z) + ' photos removed because of reporting abuse');
	end;

procedure likePhoto(inputNickname: tNickname; inputID:tIdPhoto; var U:tListU);
	//  Goal: Adds a like to a photo
	// Input: the nickname of the user, the id of the photo and the user list
	// Output: A modified user list
	var
		v: tPosU; // Owner of the photo
		p: tPosP; // The position of the photo
		i: tItemU; // The user itself
		y: tItemP;
	begin
		v:= findItemU(inputNickname, U);

		if v <> NULLU then begin // Checks if the user exists
			i:= getItemU(v, U);
			p:= findItemP(inputID, i.photos);

			if p <> NULLP then begin // Checks if the photo exists
				y:= getItemP(p, i.photos);
				with y do begin
					likes:= likes + 1;
					echo('New like Photo ' + inputNickname + ' ' + IntToStr(inputID) + chr(10) + '  *    Current number of likes ' + IntToStr(likes))
				end;
				updateItemP(i.photos, p, y); // Applies changes to the gallery
				updateItemU(U, v, i) // Applies changes to the user
			end else
				printError('Increasing likes: IdPhoto ' + IntToStr(inputID) + ' does not exist')
	end else
		printError('Increasing Likes: Nickname ' + inputNickname + ' not found')
	end;

procedure removePhoto(inputNickname: tNickname; inputID:tIdPhoto;  var U:tListU);
	// Goal: Removes a photo
	// Input: the nickname of the user, the id of the photo and the user list
	// Output: The modified user list
	var
		v: tPosU;
		i: tItemU;
 		p: tPosP;

	begin
		v:= findItemU(inputNickname, U);
		if v <> NULLU then begin
			i:= getItemU(v, U);
			with i do begin
				p:= findItemP(inputID, photos);

				if p <> NULLP then begin
					echo('Photo removed ' + inputNickname + ' ' + IntToStr(inputID));
					deleteAtPositionP(p, photos);
					updateItemU(U, v, i);
				end else
					printError('Removing photo: idPhoto ' + IntToStr(inputID) + ' does not exist')
			end
		end else
			printError('Removing photo: Nickname ' + inputNickname + ' not found')
	end;


procedure showUserGallery(inputUser:tItemU);
	// Goal: Shows a single user gallery
	// Input: the user
	// PREC: User must be valid
	var
		p: tPosP;
		g, x: tItemP;

	begin
		with inputUser do begin
			echo('===> User account: Nickname ' + nickname + ' Username ' + username + ' Account ' + accToStr(account), true);
			if not isEmptyListP(photos) then begin
				echo('Photo Gallery:');
				p:= lastP(photos);
				x:= getItemP(p, photos);
				while p <> NULLP do begin
					g:= getItemP(p, photos);
					with g do begin
						if likes > x.likes then
							x:= g;
						echo('Photo ' + IntToStr(idPhoto) + ' (' + fileName  +'). Likes ' + IntToStr(likes) + '. ' + abuseStr(reported) + '. Comment ' + comment , true)
					end;
					p:= previousP(p, photos)
				end;
				with x do
					echo('Photo with largest number of likes (' + IntToStr(likes) + '): ' + IntToStr(idPhoto));
			end else
				printError('Photo gallery empty')
		end
	end;

procedure systemStatus(inputNickname:tNickname; U:tListU);
	// Goal: Shows the status of either an user or  the whole system
	// Input: The nickname of the user you want to see the status of, the whole system if "nickname" is empty and the UserList
	var
		p: tPosU;
	begin
		if not isEmptyListU(U) then
			if inputNickname = '' then begin
				p:= firstU(U);
				while p <> NULLU do begin
					showUserGallery(getItemU(p, U));
					p:= nextU(p, U)
				end
			end else begin
				p:= findItemU(inputNickname, U);
				if p <> NULLU then
					showUserGallery(getItemU(p, U))
				else
					printError('Showing user account: Nickname ' + inputNickname + ' not found')
			end
		else
			echo('Showing user accounts: no user accounts found');
	end;

procedure favorites(inputNumber:tLikesCounter; var U:tListU);
	// Goal: Shows the photos with at least the minimum amount of likes given
	// Input: The number of minimum likes and the user list
	var
		p: tPosU;
		q: tPosP;
		b: boolean = true;
	begin
		if not isEmptyListU(U) then begin
			p:= firstU(U);
			while p <> NULLU do begin
				with getItemU(p, U) do
					if not isEmptyListP(photos) then begin
						q:= lastP(photos);
						while q <> NULLP do begin
							with getItemP(q, photos) do begin
								if likes >= inputNumber then begin
									b:= false;
									echo('* ' + nickname + ' Photo ' + IntToStr(idPhoto) + ' (' + fileName + '). Likes ' + IntToStr(likes) + '. ' + abuseStr(reported) + '. Comment ' + comment, true)
								end
							end;
							q:= previousP(q, photos)
						end
					end;
				p:= nextU(p, U);
			end
		end else
			echo('Showing favorites: no user accounts found');
		if b then
			echo('No favorites found')
	end;

procedure runTasks(var Q:tQueue; var U:tListU);
	// Goal: Gets the instructions from the Q
	// Input: the queue of the instructions and the user list
	// Output: an empty queue and a modified user list according to the instructions
	var
		f: tItemQ;
		idCounter: integer = -1;
	begin
		while not isEmptyQueue(Q) do begin
			f:= front(Q);

			with f do begin
				if parameter3 <> '' then
					header('Task ' + code + ': Param1 ' + parameter1 + ' - Param2 ' + parameter2 + ' Param3 ' + parameter3)
				else if parameter2 <> '' then
					header('Task ' + code + ': Param1 ' + parameter1 + ' - Param2 ' + parameter2)
				else if parameter1 <> '' then
					header('Task ' + code + ': Param1 ' + parameter1)
				else
					header('Task ' + code);

				case code of
					'C', 'c': createAccount(parameter1, parameter2, strToAcc(parameter3), U);
					'Q', 'q': deleteAccount(parameter1, U);
					'T', 't': transformAccount(parameter1, strToAcc(parameter2), U);
					'U', 'u': uploadImage(parameter1, parameter2, parameter3, U, idCounter);
					'R', 'r': removePhoto(parameter1, StrToInt(parameter2), U);
					'L', 'l': likePhoto(parameter1, StrToInt(parameter2), U);
					'A', 'a': reportPhoto(parameter1, StrToInt(parameter2), U);
					'D', 'd': purgeUsers(U);
					'S', 's': systemStatus(parameter1, U);
					'F', 'f': favorites(StrToInt(parameter1), U)
				end
			end;
			dequeue(Q)
		end
	end;

procedure readTasks(taskFile:string; var Q:tQueue);
	var
		fileId : text;
		line,
		param1,
		param2,
		param3,
		code : string;
		p: tItemQ;

	begin
		header('Fetching tasks');
		{$i-}
		assign(fileId, taskFile);
		reset(fileId);
		{$i+}
		if IOResult <> 0 then begin
			printError('Reading. Error when trying to open ' + taskFile);
			halt(1)
		end;

		while not EOF(fileId) do begin
			readln(fileId, line);

			code:= trim(copy(line, 1, 2));
			param1 := trim(copy(line, 3, 10));
			param2 := trim(copy(line, 14, 15));
			param3 := trim(copy(line, 30, 20));

			echo('Code: ' + code + ' Param1: ' + param1 + ' Param2: ' + param2 + ' Param3: ' + param3);

			p.code:= code[1];
			p.parameter1:= param1;
			p.parameter2:= param2;
			p.parameter3:= param3;

			// Comprobar que no entran parametros vacios

			if not enqueue(p, Q) then
				printError('There is not enought space');
		end
end;


// ---------------------------------------------------------------------------------------

var
	usersList: tListU;
	inputBuffer: tQueue;

begin

	createEmptyQueue(inputBuffer); // Creates an empty queue 'inputBuffer' to work with

	if paramCount > 0 then // Checks if there's any parameter in the console command
		readTasks(ParamStr(1), inputBuffer) // Use the file specified as parameter
	else
		readTasks('create-users.txt', inputBuffer); // Use a "hard-coded" filename

	runTasks(inputBuffer, usersList);

	selfDestruction(usersList); // Deletes all the users and their content in order to free the memory
end.
