CodeFolder="Codes/"
DecompressedFolder="Codes/Decompressed/"
QuestionFolders=("Q1_Fractions/" "Q2_Sort/" "Q3_Palindrome/")
MakefileName=("makefile1" "makefile2" "makefile3")
MainfileName=("main.cpp1" "main.cpp2" "main.cpp3")
OutputfileName="Output"

if [ -f $OutputfileName ]; then
	rm $OutputfileName
fi

for file in  $(ls $CodeFolder | egrep -i '*.zip|*.rar');
do
	echo $file >> $OutputfileName

	FolderContainsQuestions=$DecompressedFolder

	if [ ! -d $DecompressedFolder ]; then
		mkdir  $DecompressedFolder
	fi

	if [ "$(ls -A  $DecompressedFolder)" ]; then		# Folder is not empty
		rm -r $DecompressedFolder/*
	fi

	if [[ $file =~ ".zip" ]]; then
		unzip $CodeFolder$file -d $DecompressedFolder
	elif [[ $file =~ ".rar" ]]; then
		rar x $CodeFolder$file $DecompressedFolder
	fi

	while [ ! -d $FolderContainsQuestions${QuestionFolders[0]} ]		# try to find the folder which really contains QuestionFolders
	do
		FolderContainsQuestions=$FolderContainsQuestions"$(ls $FolderContainsQuestions -A)/"
	done

	for ((i=0; i < ${#QuestionFolders[@]}; i++))
	do
		cp ${MakefileName[$i]} $FolderContainsQuestions${QuestionFolders[$i]}makefile
		cp ${MainfileName[$i]} $FolderContainsQuestions${QuestionFolders[$i]}main.cpp
		make -C $FolderContainsQuestions${QuestionFolders[$i]}
		$FolderContainsQuestions${QuestionFolders[$i]}binary.out >> $OutputfileName 		# create a new process
	done

	echo -------------------------------------------- >> $OutputfileName

done