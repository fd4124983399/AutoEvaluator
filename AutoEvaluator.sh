CodeFolder="Codes/"
DecompressedFolder="Codes/Decompressed/"
OutputfileFolder="OutputLogs/"
QuestionFolders=("Q1_Vector/" "Q2_DoublyCircularLinkedList/")
MakefileName=("makefile1" "makefile2")
MainfileName=("main.cpp1" "main.cpp2")
MainfileNameInProject="main.cpp"
OutputfileName="binary.out"
TestCaseAmount=(1 8)

if [ ! -d "$OutputfileFolder" ]; then
	mkdir -p "$OutputfileFolder"
fi

if [ ! -d "$DecompressedFolder" ]; then
	mkdir -p "$DecompressedFolder"
fi

if [ "$(ls -A  "$DecompressedFolder")" ]; then		# Folder is not empty
	sudo rm -rf "$DecompressedFolder"/*
fi

find "$CodeFolder" -maxdepth 1 -name "* *" -type f | rename 's/ /_/g'		# Replace " " to "_" in filename
for file in  $(ls "$CodeFolder" | egrep -i ".*.zip$|.*.rar$|.*.7z$");
do
	OutputfilePath="$OutputfileFolder""$file".log
	if [ -f "$OutputfilePath" ]; then
		sudo rm -f "$OutputfilePath"
	fi

	if [ ! -d "$DecompressedFolder""$file" ]; then
		mkdir -p "$DecompressedFolder""$file"
	fi

	if [[ "$file" =~ .*.zip$ ]]; then
		unzip "$CodeFolder$file" -d "$DecompressedFolder""$file"
	elif [[ $file =~ .*.rar$ ]]; then
		rar x "$CodeFolder$file" "$DecompressedFolder""$file"
	elif [[ $file =~ .*.7z$ ]]; then
		7z x "$CodeFolder$file" -o"$DecompressedFolder""$file"
	fi

	for ((i=0; i < ${#QuestionFolders[@]}; i++))
	do
		FolderContainsQuestions="$(find "$DecompressedFolder""$file" -type d -name ${QuestionFolders[$i]::-1} -printf '%h\n' -quit | sort -u)/"

		if [ $FolderContainsQuestions != "/" ]; then
			break
		fi
	done	

	if [ $FolderContainsQuestions == "/" ]; then
		echo "Solution folder not exist" >> "$OutputfilePath"
	else
		# use [@] to list all the elements of array, use # to get the amount of it
		for ((i=0; i < ${#QuestionFolders[@]}; i++))
		do
			cp -f "${MakefileName[$i]}" "$FolderContainsQuestions""${QuestionFolders[$i]}"makefile
			cp -f "${MainfileName[$i]}" "$FolderContainsQuestions""${QuestionFolders[$i]}""$MainfileNameInProject"
			make -C "$FolderContainsQuestions""${QuestionFolders[$i]}"

			for ((j=1; j <= ${TestCaseAmount[i]}; j++))
			do
				{ "$FolderContainsQuestions""${QuestionFolders[$i]}"binary.out $j; } &>> "$OutputfilePath"
			done
		done
	fi 
done