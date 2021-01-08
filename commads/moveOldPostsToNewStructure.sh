for folder in ./content/posts/* ; do
  articleFile="$folder/index.md"

  fullDateFile=$(cat $articleFile | sed -n -e '/date: /p' | sed -n -e "/date:/p" | awk '{print $2}' | tr -d "'")
  dateFile="${fullDateFile%T*}"
  yearDateFile="${dateFile%-*-*}"
  monthDateFile="${dateFile%*-*}"
  monthDateFile="${monthDateFile##*-}"
  dayDateFile="${dateFile##*-}"

  fullPathImages="./static/uploads/$yearDateFile/$monthDateFile/$dayDateFile"
  mkdir -p $fullPathImages

  for image in $folder/images/*; do
    filename="${image##*/}"
    newUrlImagePath="\/uploads\/$yearDateFile\/$monthDateFile\/$dayDateFile"

    sed -i -e "s/.\/images\/$filename/$newUrlImagePath\/$filename/g" $articleFile
    mv $image "$fullPathImages/$filename"

#    mv $image "$fullPathImages/$filename"
  done

  mv $articleFile "$folder.md"
  rm -r "$folder/"
done