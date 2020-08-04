CodeFolder="Codes/"
DecompressedFolder="Codes/Decompressed/"
OutputfileFolder="OutputLogs/"
QuestionFolders=("Q1_Fractions/" "Q2_Sort/" "Q3_Palindrome/")
MakefileName=("makefile1" "makefile2" "makefile3")
MainfileName=("main.cpp1" "main.cpp2" "main.cpp3")
MainfileNameInProject="main.cpp"
OutputfileName="binary.out"

if [ ! -d "$OutputfileFolder" ]; then
	mkdir -p "$OutputfileFolder"
fi

if [ ! -d "$DecompressedFolder" ]; then
	mkdir -p "$DecompressedFolder"
fi

if [ "$(ls -A  "$DecompressedFolder")" ]; then		# Folder is not empty
	rm -rf "$DecompressedFolder"/*
fi

find "$CodeFolder" -maxdepth 1 -name "* *" -type f | rename 's/ /_/g'
for file in  $(ls "$CodeFolder" | egrep -i '*.zip|*.rar|*.7z');
do
	OutputfilePath="$OutputfileFolder""$file".log
	if [ -f "$OutputfilePath" ]; then
		rm -f "$OutputfilePath"
	fi

	if [[ "$file" =~ ".zip" ]]; then
		unzip "$CodeFolder$file" -d "$DecompressedFolder""$file"
	elif [[ $file =~ ".rar" ]]; then
		rar x "$CodeFolder$file" "$DecompressedFolder""$file"
	elif [[ $file =~ ".7z" ]]; then
		7z x "$CodeFolder$file" -o"$DecompressedFolder""$file"
	fi

	chmod -R 755 "$DecompressedFolder""$file"		# use 7z to create a new folder seems set the permission to 700
	FolderContainsQuestions="$(find "$DecompressedFolder""$file" -type d -name ${QuestionFolders[0]::-1} -printf '%h\n' -quit | sort -u)/"
	for ((i=0; i < ${#QuestionFolders[@]}; i++))
	do
		cp -f "${MakefileName[$i]}" "$FolderContainsQuestions""${QuestionFolders[$i]}"makefile
		cp -f "${MainfileName[$i]}" "$FolderContainsQuestions""${QuestionFolders[$i]}""$MainfileNameInProject"
		make -C "$FolderContainsQuestions""${QuestionFolders[$i]}"
		{ "$FolderContainsQuestions""${QuestionFolders[$i]}""$OutputfileName"; } &>> "$OutputfilePath"
	done
done