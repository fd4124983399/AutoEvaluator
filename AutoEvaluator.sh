CodeFolder="Codes/"
DecompressedFolder="Codes/Decompressed/"
OutputfileFolder="OutputLogs/"
QuestionFolders=("Q1_Fractions/" "Q2_Sort/" "Q3_Palindrome/")
MakefileName=("makefile1" "makefile2" "makefile3")
MainfileName=("main.cpp1" "main.cpp2" "main.cpp3")

if [ ! -d "$OutputfileFolder" ]; then
	mkdir -p "$OutputfileFolder"
fi

if [ ! -d "$DecompressedFolder" ]; then
	mkdir -p "$DecompressedFolder"
fi

for file in  $(ls "$CodeFolder" | egrep -i '*.zip|*.rar|*.7z');
do

	OutputfilePath="$OutputfileFolder""$file".log
	if [ -f "$OutputfilePath" ]; then
		rm -f "$OutputfilePath"
	fi

	FolderContainsQuestions="$DecompressedFolder"

	if [ "$(ls -A  "$DecompressedFolder")" ]; then		# Folder is not empty
		rm -rf "$DecompressedFolder"/*
	fi

	if [[ "$file" =~ ".zip" ]]; then
		unzip "$CodeFolder$file" -d "$DecompressedFolder"
	elif [[ $file =~ ".rar" ]]; then
		rar x "$CodeFolder$file" "$DecompressedFolder"
	elif [[ $file =~ ".7z" ]]; then
		7z x "$CodeFolder$file" -o"$DecompressedFolder"
	fi

	while [ ! -d "${FolderContainsQuestions}""${QuestionFolders[0]}" ]		# try to find the folder which really contains QuestionFolders
	do
		FolderContainsQuestions="$FolderContainsQuestions""$(ls $FolderContainsQuestions -A)/"
	done

	for ((i=0; i < ${#QuestionFolders[@]}; i++))
	do
		cp -f "${MakefileName[$i]}" "$FolderContainsQuestions""${QuestionFolders[$i]}"makefile
		cp -f "${MainfileName[$i]}" "$FolderContainsQuestions""${QuestionFolders[$i]}"main.cpp
		make -C "$FolderContainsQuestions""${QuestionFolders[$i]}"
		"$FolderContainsQuestions""${QuestionFolders[$i]}"binary.out >> "$OutputfilePath"
	done

done