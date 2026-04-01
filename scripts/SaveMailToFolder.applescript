-- SaveMailToFolder.applescript
-- Saves the currently selected Apple Mail message(s) to a specified folder as .eml files.
-- Usage: osascript SaveMailToFolder.applescript /path/to/destination/folder [--archive]

on run argv
	if (count of argv) is 0 then
		error "Usage: osascript SaveMailToFolder.applescript /path/to/folder [--archive]"
	end if

	set destFolder to item 1 of argv

	-- Check for --archive flag
	set shouldArchive to false
	if (count of argv) > 1 then
		if item 2 of argv is "--archive" then
			set shouldArchive to true
		end if
	end if

	-- Ensure trailing slash
	if destFolder does not end with "/" then
		set destFolder to destFolder & "/"
	end if

	-- Verify destination folder exists
	do shell script "mkdir -p " & quoted form of destFolder

	tell application "Mail"
		set selectedMessages to selection

		if (count of selectedMessages) is 0 then
			error "No messages selected in Mail."
		end if

		set savedFiles to {}

		repeat with msg in selectedMessages
			set msgSubject to subject of msg
			set msgDate to date received of msg
			set msgSender to sender of msg
			set msgSource to source of msg

			-- Build a safe filename: YYYY-MM-DD_HHMMSS_Subject.eml
			set dateStr to my formatDate(msgDate)
			set safeSubject to my sanitizeFilename(msgSubject)

			-- Truncate subject to avoid overly long filenames
			if (count of safeSubject) > 80 then
				set safeSubject to text 1 thru 80 of safeSubject
			end if

			set fileName to dateStr & "_" & safeSubject & ".eml"
			set filePath to destFolder & fileName

			-- Handle duplicate filenames
			set filePath to my uniquePath(filePath)

			-- Write the raw message source to the .eml file
			do shell script "cat > " & quoted form of filePath & " <<'ENDOFMAILMSG'\n" & msgSource & "\nENDOFMAILMSG"

			set end of savedFiles to filePath
		end repeat

		-- Archive messages if flag was passed
		if shouldArchive then
			repeat with msg in selectedMessages
				set mailbox of msg to mailbox "Archive" of account (account of mailbox of msg)
			end repeat
		end if

		if shouldArchive then
			return "Saved and archived " & (count of savedFiles) & " message(s) to " & destFolder
		else
			return "Saved " & (count of savedFiles) & " message(s) to " & destFolder
		end if
	end tell
end run

on formatDate(theDate)
	set y to year of theDate as string
	set m to text -2 thru -1 of ("0" & ((month of theDate) as integer as string))
	set d to text -2 thru -1 of ("0" & (day of theDate as string))
	set h to text -2 thru -1 of ("0" & (hours of theDate as string))
	set mi to text -2 thru -1 of ("0" & (minutes of theDate as string))
	set s to text -2 thru -1 of ("0" & (seconds of theDate as string))
	return y & "-" & m & "-" & d & "_" & h & mi & s
end formatDate

on sanitizeFilename(theName)
	set cleanName to ""
	repeat with c in characters of theName
		set c to c as string
		if c is in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_ " then
			set cleanName to cleanName & c
		end if
	end repeat
	-- Replace spaces with underscores
	set AppleScript's text item delimiters to " "
	set parts to text items of cleanName
	set AppleScript's text item delimiters to "_"
	set cleanName to parts as string
	set AppleScript's text item delimiters to ""
	return cleanName
end sanitizeFilename

on uniquePath(filePath)
	set counter to 1
	set basePath to filePath
	-- Strip .eml extension for counter insertion
	if basePath ends with ".eml" then
		set basePath to text 1 thru -5 of basePath
	end if
	set testPath to basePath & ".eml"
	repeat
		try
			do shell script "test -e " & quoted form of testPath
			-- File exists, increment counter
			set testPath to basePath & "_" & (counter as string) & ".eml"
			set counter to counter + 1
		on error
			-- File does not exist, use this path
			exit repeat
		end try
	end repeat
	return testPath
end uniquePath
