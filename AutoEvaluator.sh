CodeFolder="Codes/"
DecompressedFolder="Codes/Decompressed/"
QuestionFolders=("Q1_Fractions/" "Q2_Sort/" "Q3_Palindrome/")
MakefileName=("makefile1" "makefile2" "makefile3")

for file in  $(ls $CodeFolder | egrep -i '*.zip|*.rar');
do

	FolderContainsQuestions=$DecompressedFolder

#	if [ -d $DecompressedFolder ]; then		# Folder is not empty
#		rm -r $DecompressedFolder/*
#	fi

#	if [[ $file =~ "zip" ]]; then
#		unzip $CodeFolder$file -d $DecompressedFolder
#	elif [[ $file =~ "rar" ]]; then
#		rar x $CodeFolder$file $DecompressedFolder
#	fi

	while [ ! -d "$FolderContainsQuestions${QuestionFolders[0]}" ]		# try to find the folder which really contains QuestionFolders
	do
		FolderContainsQuestions=$FolderContainsQuestions"$(ls $FolderContainsQuestions -A)/"
	done

	for ((i=0; i < ${#QuestionFolders[@]}; i++))
	do
		cp ${MakefileName[$i]} $FolderContainsQuestions${QuestionFolders[$i]}makefile
	done

	
done