#! /bin/sh

##########
# How to use:
# $ cd /User/valentincarl/Desktop/prog1/auto-download
# $ ./skript.sh
# > In welchem Ordner sind alle Abgaben für dieses Blatt gespeichert?
# $ /Users/valentincarl/downloads/...
# > Wo ist die Teilnehmerliste gespeichert?
# $ /Users/valentincarl/Desktop/prog1/auto-download/teilnehmer.txt
# > Für welches Blatt sind die Abgaben?
# $ ...
# > Wo sollen die Abgaben gespeichert werden?
# $ /Users/valentincarl/Desktop/prog1
# > ...
# > done

# ALLE_ABGABEN="/Users/valentincarl/downloads/Blatt5"
# TEILNEHMERLISTE="/Users/valentincarl/Desktop/prog1/auto-download/teilnehmer.txt"
# BLATT_NUMMER=5
# PFAD_ZIEL="/Users/valentincarl/Desktop/prog1"

# Pfad alle Abgaben einlesen
read -p "In welchem Ordner sind alle Abgaben für dieses Blatt gespeichert?" ALLE_ABGABEN
if [[ ! -e ${ALLE_ABGABEN} ]]
then 
	echo "${ALLE_ABGABEN} does not exist."
fi

# Teilnehmerliste einlesen
read -p "Wo ist die Teilnehmerliste gespeichert?" TEILNEHMERLISTE
if [[ ! -e ${TEILNEHMERLISTE} ]]
then 
	echo "${TEILNEHMERLISTE} does not exist."
fi

# Einlesen für welches Blatt die Abgaben sind
read -p "Für welches Blatt sind die Abgaben?" BLATT_NUMMER

# Einlesen wo das gespeichert werden soll
read -p "Wo sollen die Abgaben gespeichert werden?" PFAD_ZIEL
if [[ ! -e ${PFAD_ZIEL} ]]
then
	echo "${PFAD_ZIEL} does not exist."
fi

# neuen Ordner für das Blatt erstellen
mkdir "${PFAD_ZIEL}/Blatt_${BLATT_NUMMER}"

# Abgaben umbenennen
cd "${ALLE_ABGABEN}"
for filename in *
do 
	mv "$filename" "${filename%%_*}"
done

# Abgaben verschieben
cd "${ALLE_ABGABEN}"
while IFS= read -r f
do 
	if [[ -e ${ALLE_ABGABEN}/${f} ]]
	then
		echo "${f} hat etwas abgegeben."
		mv "$f" "${PFAD_ZIEL}/Blatt_${BLATT_NUMMER}/$f"
	else
		echo "${f} hat nichts abgegeben."
	fi
done < "$TEILNEHMERLISTE"

# zips entpacken und löschen
cd --
cd "${PFAD_ZIEL}/Blatt_${BLATT_NUMMER}"
while IFS= read -r f
do
	if [[ -e $f ]]
	then
		cd "${f}"
		unzip *.zip
		rm *.zip
		cd ..
	fi
done < "$TEILNEHMERLISTE"

# Alle Abgaben löschen
#rm $ALLE_ABGABEN

# if no errors occured
echo "done"
